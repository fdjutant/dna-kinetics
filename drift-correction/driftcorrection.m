function [correctedimage] = driftcorrection(image)
    [l,m,n] = size(image);
    correctedimage = zeros(l,m,n);
    correctedimage(:,:,1) = image(:,:,1);
    ypeak = 0; xpeak = 0;
    temp = zeros(l,m);
    for i = 1:n-1
        c = normxcorr2(image(:,:,1),image(:,:,i+1));
        [xpeak,ypeak] = find(c==max(c(:)));
        xoffset = xpeak-size(image(:,:,1),1);
        yoffset = ypeak-size(image(:,:,1),2);
        
        correctedimage(1:end-xoffset,1:end-yoffset,i+1) = image(1+xoffset:end,1+yoffset:end,i+1);
    end
end
