%% Merge data for NP and NorP classification
XTrain3=[XTrain3N XTrain3P];
YTrain3=[YTrain3N YTrain3P];
XTest3=[XTest3N XTest3P];
YTest3=[YTest3N YTest3P];

%% Double data
% XTrain3=[XTrain3N XTrain3P XTrain3P];
% YTrain3=[YTrain3N YTrain3P YTrain3P];
% XTest3=[XTest3N XTest3P XTest3P];
% YTest3=[YTest3N YTest3P YTest3P];

%% Bootstrapping
% labels=[categorical({'P1'});categorical({'P2'});categorical({'P3'});categorical({'P4'});categorical({'P5'})];
% [XTrain3,YTrain3]=bootstrapping(XTrain3,YTrain3,labels);
% [XTest3,YTest3]=bootstrapping(XTest3,YTest3,labels);

% %% Creo il vettore di etichette per la classificazione NorP
% YTrain3NorP=YTrain3;
% YTest3NorP=YTest3;
% YTrain3NorP(YTrain3NorP=='N1')='N';
% YTrain3NorP(YTrain3NorP=='N2')='N';
% YTrain3NorP(YTrain3NorP=='N3')='N';
% YTrain3NorP(YTrain3NorP=='N4')='N';
% YTrain3NorP(YTrain3NorP=='N5')='N';
% YTrain3NorP(YTrain3NorP=='P1')='P';
% YTrain3NorP(YTrain3NorP=='P2')='P';
% YTrain3NorP(YTrain3NorP=='P3')='P';
% YTrain3NorP(YTrain3NorP=='P4')='P';
% YTrain3NorP(YTrain3NorP=='P5')='P';
% YTest3NorP(YTest3NorP=='N1')='N';
% YTest3NorP(YTest3NorP=='N2')='N';
% YTest3NorP(YTest3NorP=='N3')='N';
% YTest3NorP(YTest3NorP=='N4')='N';
% YTest3NorP(YTest3NorP=='N5')='N';
% YTest3NorP(YTest3NorP=='P1')='P';
% YTest3NorP(YTest3NorP=='P2')='P';
% YTest3NorP(YTest3NorP=='P3')='P';
% YTest3NorP(YTest3NorP=='P4')='P';
% YTest3NorP(YTest3NorP=='P5')='P';
% YTrain3NorP=categorical(cellstr(YTrain3NorP));
% YTest3NorP=categorical(cellstr(YTest3NorP));