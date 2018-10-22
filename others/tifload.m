clc, clear all, close all

%% Input the Tif file to the codes
FileTif = '2562bp_P1_Red20.tif';
InfoImage = imfinfo(FileTif);
mImage = InfoImage(1).Width; nImage = InfoImage(1).Height;
NumberImages = length(InfoImage);
FinalImage = zeros(nImage,mImage,NumberImages,'uint16');

TifLink = Tiff(FileTif,'r');
for i = 1: NumberImages
    TifLink.setDirectory(i);
    FinalImage(:,:,i) = TifLink.read();
end
TifLink.close()

%% Show tif files with a slider
% StackSlider(FileImage)

%% Averaging images
nblock = 10;
AverageImage(:,:,:) = zeros(300,300,floor(length(FinalImage)/nblock));
int = 1; i = 1;
while int < length(FinalImage)
    AverageImage(:,:,i) = mean(FinalImage(:,:,int:int+(nblock-1)),3);
    int = int + nblock; i = i + 1;
end
% StackSlider(avg_img)

%% Coarse drift correction
avg_img = AverageImage(:);
movie = FinalImage(:);
nframes = length(movie);

interval = 10; % number of frames in each block
H = fspecial('average',[11 11]);
drift_by_int = zeros(ceil(nframes/interval),2);  % length(drift_by_int) = 300 2 
img_meanfilt = imfilter(avg_img,H);  % avg_img is the average images from the first block
avg_img_masked = zeros(size(avg_img));
 
avg_img_masked(:) = avg_img(:).*...     % removing noise (values that is less than 1 std)
    (img_meanfilt(:)>( mean(nonzeros(img_meanfilt(:))) + std(nonzeros(img_meanfilt(:))) ) ); % True OR False
    
% Going through intervals
for i = 1:size(drift_by_int,1)
    ai = zeros(size(avg_img));
    for j = 1:min([interval nframes-(i-1)*interval])
        % (i-1)*interval+i
        ai = ai + FinalImage{(i-1)*interval+i};
    end
    ai = ai./interval;
    tmp = normxcorr2(ai,avg_img_masked);
    [v, ind] = max(tmp(:));
    [a, b] = ind2sub(size(tmp),ind);
    drift_by_int(i,1) = 416 - b;
    drift_by_int(i,2) = 416 - a;
end
