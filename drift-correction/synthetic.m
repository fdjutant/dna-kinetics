%% Synthetic data
% function [syn_image] = synthetic(
clc, clear all, close all

%% image parameters
range = 500;
peak_height = 300;
num_peaks = 80;
noise_level = 100;
threshold = 60;

x = linspace(0,range,range);
y = linspace(0,range,range);
[X,Y] = meshgrid(x,y);
Z = X*0;

xs = range*rand(num_peaks);
ys = range*rand(num_peaks);
for i = 1:length(xs)
    widthx = 2 + rand(1);
    widthy = 2 + rand(1);
    Z = Z + gaussian2d(X,Y,xs(i),ys(i),peak_height,widthx,widthy);
end
imwrite(im2uint8(Z(:,:,1)/1000),'NoNoise.tif');

%% Add noise for fun
noise1 = noisegen(noise_level,range,5) % large noise
noise2 = noisegen(noise_level,range,1) % small noise (grainy)
Zsynthetic = Z + noise1 +  noise2;
imwrite(im2uint8(Zsynthetic(:,:,1)/1000),'WithNoise.tif');

%% Drift the images
nframes = 50;
Zstacks = zeros(range,range,nframes);
temp = zeros(range,range) + noise1 + noise2;
xdrift = 1; ydrift = 1;
Zstacks(:,:,1) = Zsynthetic(:,:); % reference

for i = 1:nframes
    temp(xdrift:end,ydrift:end) = Zsynthetic(1:end-(xdrift-1),1:end-(ydrift-1));
    xdrift = xdrift + 1;
    ydrift = ydrift + 1;
    Zstacks(:,:,i+1) = temp(:,:);
    temp = zeros(range,range) + noise1 + noise2;
end
% StackSlider(Zstacks)

%% Calculate the image correlation
Zundrift = zeros(range,range,nframes) + noise1 + noise2;
Zundrift(:,:,1) = Zstacks(:,:,1);
ypeak = 0; xpeak = 0;
temp = zeros(range,range);
for i = 1:nframes
    c = normxcorr2(Zstacks(:,:,1),Zstacks(:,:,i+1));
    [xpeak,ypeak] = find(c==max(c(:)));
    xoffset = xpeak-size(Zstacks(:,:,1),1);
    yoffset = ypeak-size(Zstacks(:,:,1),2);
    
    Zundrift(1:end-xoffset,1:end-yoffset,i+1) = Zstacks(1+xoffset:end,1+yoffset:end,i+1);
end
% StackSlider(Zundrift)

%% Save the files to tiff
imwrite(im2uint8(Zundrift(:,:,1)/1000),'Synthetic.tif');
imwrite(im2uint8(Zstacks(:,:,1)/1000),'Undrift.tif');
for i=1:nframes-1
    imwrite(im2uint8(Zstacks(:,:,i+1)/1000),'Synthetic.tif','WriteMode','append');
    imwrite(im2uint8(Zundrift(:,:,i+1)/1000),'Drifted.tif','WriteMode','append');
end


%% Plot stuff
% figure; axis off;
% subplot(1,3,1); imagesc(Z); axis equal;
% subplot(1,3,2); imagesc(Znew); axis equal;
% subplot(1,3,3); imagesc(Z1); axis equal;

%% ALL functions
function [noise] = noisegen(noise_level,range,sigma)
    noise = noise_level*exp(-(rand(range)).^2/(2*sigma^2));
end

function [zvalue] = gaussian2d(X,Y,x0,y0,amp,sigmax,sigmay)
    zvalue = amp*exp(-(X-x0).^2/(2*sigmax^2) - (Y-y0).^2/(2*sigmay^2));
end
