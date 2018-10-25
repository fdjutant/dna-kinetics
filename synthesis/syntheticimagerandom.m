function [image] = syntheticimage(range,peak_height,num_peaks,noise_level)
   
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
    % imwrite(im2uint8(Z(:,:,1)/1000),'NoNoise.tif');
    
    %% Add noise for fun
    noise1 = noisegen(noise_level,range,5) % large noise
    noise2 = noisegen(noise_level,range,1) % small noise (grainy)
    image = Z + noise1 +  noise2;
    % imwrite(im2uint8(Zsynthetic(:,:,1)/1000),'WithNoise.tif');
end

