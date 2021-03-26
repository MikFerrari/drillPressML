function [f,P1] = onesidedFFT(a,Fs)

    L = length(a);
    Y = fft(a);
    P2 = abs(Y/L);
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:floor(L/2))/L;
    
    P1 = P1';
    f = f';
    
end