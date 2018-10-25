function [driftedimage] = artificialdrift(image,n)
    [l,m] = size(image);
    stacks = zeros(l,m,n);

    noise_level = 100; pixel = l;
    noise1 = noisegen(noise_level,pixel,5) % large noise
    noise2 = noisegen(noise_level,pixel,1) % small noise (grainy)
    temp = zeros(l,m) + noise1 + noise2;
    
    xdrift = 1; ydrift = 1;
    stacks(:,:,1) = image(:,:); % reference
    
    for i = 1:n-1
        temp(xdrift:end,ydrift:end) = image(1:end-(xdrift-1),1:end-(ydrift-1));
        xdrift = xdrift + 1;
        ydrift = ydrift + 1;
        stacks(:,:,i+1) = temp(:,:);
        temp = zeros(l,m) + noise1 + noise2;
    end
    driftedimage = stacks;
end

