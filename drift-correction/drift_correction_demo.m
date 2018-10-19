%% Coarse drift correction
interval = 100; % number of frames in each block
p = 49;
q = 464; % p and q are defined so that only the central region of each image is taken into account
H = fspecial('average', [11 11]);
drift_by_int = zeros(ceil(N_frames/interval),2); %N_frames is the number of frames in that movie
img_meanfilt = imfilter(avg_img,H); %avg_img is the average image from the first block.
avg_img_masked = zeros(size(avg_img));
avg_img_masked(:) = avg_img(:).* ...
    (img_meanfilt(:)>(mean(nonzeros(img_meanfilt(:)))+std(nonzeros(img_meanfilt(:)))));
% Go through intervals
for i = 1:size(drift_by_int,1)
    ai = zeros(size(avg_img));
    for j = 1:min([interval N_frames-(i-1)*interval])
        ai = ai + movie{(i-1)*interval+i}; % if "movie" were a cell array containing all the frames of the movie. 
                    % Actually, the frame that has to be added to ai is
                    % loaded from the .fits file here.
    end
    ai = ai./interval;
    tmp = normxcorr2(ai(p:q,p:q), avg_img_masked(p:q,p:q));
    [v, ind] = max(tmp(:));
    [a, b] = ind2sub(size(tmp),ind);
    drift_by_int(i,1) = 416-b;
    drift_by_int(i,2) = 416-a;
end

% drift_by_int is then used to add/subtract the drift from the starting
% positions obtained from the first block average image.


%% Fine drift correction

% if the centroid x/y-positions are an array 'pos' with size N_frames-by-2

medians101 = medfilt1_trunc_2d(pos,101); % I'm also attaching this function file to the email
dispmed101 = pos - medians101;
radialDisp = sqrt(dispmed101(:,1).^2+dispmed101(:,2).^2);
