%% Synthetic data
clc, clear all, close all

%% Add path
addpath(genpath('./synthesis'));
addpath(genpath('./stacks-slider'));
addpath(genpath('./math-equations'));
addpath(genpath('./drift-correction'));
addpath(genpath('./centroid-finder'));
addpath(genpath('./saving-output'));

%% Image parameters
pixel = 500;
peak_height = 300;
num_peaks = 10;
noise_level = 100;

% {{{
% %% Generate image
% image = syntheticimage(pixel,peak_height,num_peaks,noise_level);
% % load 'sampleimage.mat' image;
% 
% %% Artificial drift addition
% nframes = 50;
% moviesdrifted = artificialdrift(image,nframes);
% 
% %% Calculate the image correlation
% moviescorrected = driftcorrection(moviesdrifted);
% StackSlider(moviescorrected)
% 
% %% Save the files to tiff
% savingtif(moviesdrifted,'originalmovies.tif');
% savingtif(moviescorrected,'correctedmovies.tif');
% }}}

%% Generate movie of jitters molecule
% image = syntheticimage(xs,ys,pixel,peak_height,num_peaks,noise_level);
% load 'sampleimage.mat' image;
x = -pi:0.9:pi';
nframes = length(x);
% loc = pixel*rand(num_peaks);
% for j = 1:num_peaks
%     for i = 1:nframes
%         xs(i) = pixel*rand(num_peaks) + sinusoidal(5,4,0,x(i));
%         ys(i) = pixel*rand(num_peaks) + sinusoidal(3,4,0,x(i));
%     end
% end
for i = 1:nframes
    xs(i) = 200 + sinusoidal(5,4,0,x(i));
    ys(i) = 300 + sinusoidal(3,4,0,x(i));
end
movies = zeros(pixel,pixel,nframes);
for i = 1: nframes
    image = syntheticimage(xs(i),ys(i),pixel,peak_height,num_peaks,noise_level);
    movies(:,:,i) = image;
end
% StackSlider(movies);
savingtif(movies,'sinusoidal.tif');

%% Find the peak by local maxima
% peaks = FastPeakFind(image);
temp = zeros(1,2);
peaks = zeros(1,2);
for i = 1:nframes
    temp = FastPeakFind(movies(:,:,i));
    peaks = cat(1,peaks,temp);
end
peaks = peaks(2:end,:);

%% Find the centroids
% cent = findcentroids(image,peaks);
temp = zeros(1,2);
cent = zeros(1,2);
for i = 1:nframes
    temp = findcentroids(movies(:,:,i),peaks(i,:));
    cent = cat(1,cent,temp);
end
cent = cent(2:end,:);

%% Make movies from figures
% figure;
%     imagesc(image); colormap('gray'); axis equal; hold on;
%     plot(peaks(:,1),peaks(:,2),'ro','LineWidth',1);
%     plot(cent(:,1),cent(:,2),'bx','LineWidth',1);
figure; axes;
vidObj = VideoWriter('juggling.mp4','MPEG-4');
open(vidObj);
for i = 1:nframes
    h(1) = imagesc(movies(:,:,i)); colormap('gray'); axis equal; hold on;
    h(2) = plot(cent(i,1),cent(i,2),'bx','LineWidth',1);
    % h(2) = plot(peaks(i,1),peaks(i,2),'ro','LineWidth',1);
    % set(gca,'xlim',[0 2*pi],'ylim',[-1.3 1.3])

    currFrame = getframe;

    writeVideo(vidObj,currFrame);
    delete(h)
end
close(vidObj)
close all


%% Calculate distance
% dist = zeros(length(cent)-1,1);
% for i = 1:length(cent)-1
%     dist(i) = sqrt( (cent(i+1,1) - cent(i,1))^2 + (cent(i+1,2) - cent(i,2))^2 );
% end
