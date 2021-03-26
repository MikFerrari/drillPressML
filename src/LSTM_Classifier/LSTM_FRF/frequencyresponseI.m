function frf = frequencyresponseI(matrix,fs)
%frequencyresponse produce in output le 3 funzioni di risposta in frequenza
% relative alle 6 accelerazioni. timetable è la timetable delle
% accelerazioni, fs è la frequenza di campionamento.
a=matrix;
max=61;
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
frf=[imag(frf1(1:max)),imag(frf2(1:max)),imag(frf3(1:max))];
end
