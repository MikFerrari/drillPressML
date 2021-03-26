function [f,P1] = spectrum(a,Fs)

    L=length(a);
    Y=fft(a);
    P2 = abs(Y/L);
    P1 = P2(1:floor(L/2+1));
    P1(2:floor(end-1)) = 2*P1(2:floor(end-1));
    f = Fs*(0:floor(L/2))/L;
    
    %Prendo solo le frequenze basse → filtraggio viene effettuato
    %direttamente in LSTM_features_extraction
%     max=151;
%     P1=P1(1:max);
%     f=f(1:max);
    
    %Grafico
%     plot(f,P1)     
%     title('Single-Sided Amplitude Spectrum of a(t)')
%     xlabel('f(Hz)')
%     ylabel('|A(f)|')
%     grid on
end