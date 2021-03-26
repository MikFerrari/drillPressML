%% Load accelerations and set training and test dataset

%In questo script vengono caricate le accelerazioni e vengono suddivise in
%report della stessa lunghezza usando la funzione "splisignals".
% load accelerations.mat
load accelerations.mat
fs=2000;
SetTrainTest;

%% Prepare data for training and test

%Genero un istogramma che mostra le lunghezze dei vari record → serve per
%decidere la lunghezza da impostare per i report
%{
figure
L = cellfun(@length,X);
h = histogram(L);
title('signal sengths')
xlabel('Length')
ylabel('Count')
%}

%Uso la funzione splitSignals per dividere in report di lunghezza uguale 
[XTrainND,YTrainND] = splitSignals(XTrainN,YTrainN,fs);
[XTestND,YTestND] = splitSignals(XTestN,YTestN,fs);

[XTrainPD,YTrainPD] = splitSignals(XTrainP,YTrainP,fs);
[XTestPD,YTestPD] = splitSignals(XTestP,YTestP,fs);

%% Dati raddoppiati
%{
% XTrainD=[XTrainND;XTrainPD;XTrainPD];
% YTrainD=[YTrainND;YTrainPD;YTrainPD];
% XTestD=[XTestND;XTestPD;XTestPD];
% YTestD=[YTestND;YTestPD;YTestPD];

% Dati NON raddoppiati
XTrainD=[XTrainND;XTrainPD];
YTrainD=[YTrainND;YTrainPD];
XTestD=[XTestND;XTestPD];
YTestD=[YTestND;YTestPD];

%% Dati FRF
if FRFflag == 1
    %Uso la funzione splitSignals per dividere in report di lunghezza uguale
    [XTrainN_D_FRF,YTrainN_D_FRF] = splitSignals(XTrainN_FRF,YTrainN_FRF,fs);
    [XTestN_D_FRF,YTestN_D_FRF] = splitSignals(XTestN_FRF,YTestN_FRF,fs);

    [XTrainP_D_FRF,YTrainP_D_FRF] = splitSignals(XTrainP_FRF,YTrainP_FRF,fs);
    [XTestP_D_FRF,YTestP_D_FRF] = splitSignals(XTestP_FRF,YTestP_FRF,fs);
    
%     % Dati NON raddoppiati
    XTrainD_FRF=[XTrainN_D_FRF;XTrainP_D_FRF];
    YTrainD_FRF=[YTrainN_D_FRF;YTrainP_D_FRF];
    XTestD_FRF=[XTestN_D_FRF;XTestP_D_FRF];
    YTestD_FRF=[YTestN_D_FRF;YTestP_D_FRF];

    % Dati raddoppiati
%     XTrainD_FRF=[XTrainN_D_FRF;XTrainP_D_FRF;XTrainP_D_FRF];
%     YTrainD_FRF=[YTrainN_D_FRF;YTrainP_D_FRF;YTrainP_D_FRF];
%     XTestD_FRF=[XTestN_D_FRF;XTestP_D_FRF;XTestP_D_FRF];
%     YTestD_FRF=[YTestN_D_FRF;YTestP_D_FRF;YTestP_D_FRF];
end
%}