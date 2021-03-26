%Viene effettuata una classica normalizzazione con z-score, cioè sottraendo
%la media e dividendo per la deviazione standard (entrambe del dataset di
%training). Ovviamente normalizzo solo i dati X (cioè le features estratte)
%e non le Y (cioè le etichette).

%NP e NorP
mu = mean(XTrain3,2);
sg = std(XTrain3,[],2);
tic
XTrain3SD=(XTrain3-mu)./sg;
XTest3SD=(XTest3-mu)./sg;
toc

%N
muN = mean(XTrain3N,2);
sgN = std(XTrain3N,[],2);
XTrain3NSD=(XTrain3N-muN)./sgN;
XTest3NSD=(XTest3N-muN)./sgN;

%P
muP = mean(XTrain3P,2);
sgP = std(XTrain3P,[],2);
XTrain3PSD=(XTrain3P-muP)./sgP;
XTest3PSD=(XTest3P-muP)./sgP;

%% Bootstrapping
labels=[categorical({'P1'});categorical({'P2'});categorical({'P3'});categorical({'P4'});categorical({'P5'})];
[XTrain3SD,YTrain3]=bootstrapping(XTrain3SD,YTrain3,labels);
[XTest3SD,YTest3]=bootstrapping(XTest3SD,YTest3,labels);

%% sort
% Training
YT=table(cellstr(YTrain3)');YT.Properties.VariableNames{1} = 'velocity';
T=[array2table(XTrain3SD'),YT];
T=sortrows(T,'velocity');
YTrain3=categorical(T.velocity)';
T.velocity=[];
XTrain3SD=table2array(T)';

% Test
YT=table(cellstr(YTest3)');YT.Properties.VariableNames{1} = 'velocity';
T=[array2table(XTest3SD'),YT];
T=sortrows(T,'velocity');
YTest3=categorical(T.velocity)';
T.velocity=[];
XTest3SD=table2array(T)';

%% Creo il vettore di etichette per la classificazione NorP
YTrain3NorP=YTrain3;
YTest3NorP=YTest3;
YTrain3NorP(YTrain3NorP=='N1')='N';
YTrain3NorP(YTrain3NorP=='N2')='N';
YTrain3NorP(YTrain3NorP=='N3')='N';
YTrain3NorP(YTrain3NorP=='N4')='N';
YTrain3NorP(YTrain3NorP=='N5')='N';
YTrain3NorP(YTrain3NorP=='P1')='P';
YTrain3NorP(YTrain3NorP=='P2')='P';
YTrain3NorP(YTrain3NorP=='P3')='P';
YTrain3NorP(YTrain3NorP=='P4')='P';
YTrain3NorP(YTrain3NorP=='P5')='P';
YTest3NorP(YTest3NorP=='N1')='N';
YTest3NorP(YTest3NorP=='N2')='N';
YTest3NorP(YTest3NorP=='N3')='N';
YTest3NorP(YTest3NorP=='N4')='N';
YTest3NorP(YTest3NorP=='N5')='N';
YTest3NorP(YTest3NorP=='P1')='P';
YTest3NorP(YTest3NorP=='P2')='P';
YTest3NorP(YTest3NorP=='P3')='P';
YTest3NorP(YTest3NorP=='P4')='P';
YTest3NorP(YTest3NorP=='P5')='P';
YTrain3NorP=categorical(cellstr(YTrain3NorP));
YTest3NorP=categorical(cellstr(YTest3NorP));