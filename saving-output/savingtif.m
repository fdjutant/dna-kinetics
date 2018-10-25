function [] = savingtif(movie,filename)
    imwrite(im2uint8(movie(:,:,1)/1000),strcat('./output-images/',filename),'WriteMode','overwrite');
    [l,m,n] = size(movie);
    for i=1:n-1
        imwrite(im2uint8(movie(:,:,i+1)/1000),strcat('./output-images/',filename),'WriteMode','append');
    end
end

