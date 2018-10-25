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
num_peaks = 20;
noise_level = 100;

%% Generate image
image = syntheticimage(pixel,peak_height,num_peaks,noise_level);

%{
%% Artificial drift addition
nframes = 50;
moviesdrifted = artificialdrift(image,nframes);

%% Calculate the image correlation
moviescorrected = driftcorrection(moviesdrifted);
StackSlider(moviescorrected)

%% Save the files to tiff
savingtif(moviesdrifted,'originalmovies.tif');
savingtif(moviescorrected,'correctedmovies.tif');
%}

%% Find the peak by local maxima
peak = FastPeakFind(image);
% centroid = FastPeakFind(image,0.1*max(image(:)),10,2)
xypeaks = zeros(length(peak)/2,2);
temp = 1; i = 1;
while i < length(peak)/2+1
    xypeaks(i,2) = peak(temp)
    xypeaks(i,1) = peak(temp+1)
    temp = temp + 2;
    i = i + 1
end

%% Find the centroids
cent = findcentroids(image,xypeaks)
figure;
    imagesc(image); colormap('gray'); axis equal; hold on;
    plot(xypeaks(:,1),xypeaks(:,2),'ro','LineWidth',1)
    plot(cent(:,1),cent(:,2),'bx','LineWidth',1)
    plot(peak(2:2:end),peak(1:2:end),'g+')
