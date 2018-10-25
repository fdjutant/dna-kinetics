function [yvalue] = sinusoidal(amp,freq,phase,x)
    yvalue = amp*sin(2*pi*freq*x+phase)
end
