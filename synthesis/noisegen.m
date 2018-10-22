function [noise] = noisegen(noise_level,range,sigma)
    noise = noise_level*exp(-(rand(range)).^2/(2*sigma^2));
end
