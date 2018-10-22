function [zvalue] = gaussian2d(X,Y,x0,y0,amp,sigmax,sigmay)
    zvalue = amp*exp(-(X-x0).^2/(2*sigmax^2) - (Y-y0).^2/(2*sigmay^2));
end
