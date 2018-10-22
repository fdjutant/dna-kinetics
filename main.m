%% Synthetic data
clc, clear all, close all

%% Add path
addpath(genpath('./synthesis'));
addpath(genpath('./stacks-slider'));
addpath(genpath('./math-equations'));
addpath(genpath('./drift-correction'));

%% Image parameters
range = 500;
peak_height = 300;
num_peaks = 80;
noise_level = 100;

%% Generate image
Zsynthetic = syntheticimage(range,peak_height,num_peaks,noise_level);

%% Drift the images
nframes = 50;
Zstacks = zeros(range,range,nframes);
temp = zeros(range,range);

xdrift = 1; ydrift = 1;
Zstacks(:,:,1) = Zsynthetic(:,:); % reference

for i = 1:nframes
    temp(xdrift:end,ydrift:end) = Zsynthetic(1:end-(xdrift-1),1:end-(ydrift-1));
    xdrift = xdrift + 1;
    ydrift = ydrift + 1;
    Zstacks(:,:,i+1) = temp(:,:);
    temp = zeros(range,range);
end
% StackSlider(Zstacks)

%% Calculate the image correlation
Zcorrected = driftcorrection(Zstacks);
StackSlider(Zcorrected)

%% Save the files to tiff
imwrite(im2uint8(Zcorrected(:,:,1)/1000),'./output-images/Synthetic.tif');
imwrite(im2uint8(Zstacks(:,:,1)/1000),'./output-images/Undrift.tif');
for i=1:nframes-1
    imwrite(im2uint8(Zstacks(:,:,i+1)/1000),'./output-images/Synthetic.tif','WriteMode','append');
    imwrite(im2uint8(Zcorrected(:,:,i+1)/1000),'./output-images/Drifted.tif','WriteMode','append');
end
