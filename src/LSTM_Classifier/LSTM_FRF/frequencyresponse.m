function frf = frequencyresponse(matrix,fs,fmax,opt)
%frequencyresponse produce in output le 3 funzioni di risposta in frequenza
% relative alle 6 accelerazioni. timetable è la timetable delle
% accelerazioni, fs è la frequenza di campionamento.
a=matrix;
a1=rmmissing((a(:,1)));
a2=rmmissing((a(:,2)));
a3=rmmissing((a(:,3)));
a4=rmmissing((a(:,4)));
a5=rmmissing((a(:,5)));
a6=rmmissing((a(:,6)));
w=hamming(fs);
frf1=modalfrf(a1,a4,fs,w);
frf2=modalfrf(a2,a5,fs,w);
frf3=modalfrf(a3,a6,fs,w);
if opt=="abs"
    frf=[abs(frf1(1:fmax)),abs(frf2(1:fmax)),abs(frf3(1:fmax))];
elseif opt=="real"
    frf=[real(frf1(1:fmax)),real(frf2(1:fmax)),real(frf3(1:fmax))];
elseif opt=="imag"
    frf=[imag(frf1(1:fmax)),imag(frf2(1:fmax)),imag(frf3(1:fmax))];
elseif opt=="mediacomplex"
    frf=[mediacomplex(frf1(1:61));mediacomplex(frf2(1:61));mediacomplex(frf3(1:61))];
end
