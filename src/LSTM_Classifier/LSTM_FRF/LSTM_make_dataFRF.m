%% Set training and test dataset
SetTrainTestN_FRF;
SetTrainTestP_FRF;
%% Prepare data for training and test

%Uso la funzione splitSignals per dividere in report di lunghezza uguale
[XTrainN_D_FRF,YTrainN_D_FRF] = splitSignals(XTrainN_FRF,YTrainN_FRF);
[XTestN_D_FRF,YTestN_D_FRF] = splitSignals(XTestN_FRF,YTestN_FRF);

[XTrainP_D_FRF,YTrainP_D_FRF] = splitSignals(XTrainP_FRF,YTrainP_FRF);
[XTestP_D_FRF,YTestP_D_FRF] = splitSignals(XTestP_FRF,YTestP_FRF);

XTrainD_FRF=[XTrainN_D_FRF;XTrainP_D_FRF];
YTrainD_FRF=[YTrainN_D_FRF;YTrainP_D_FRF];
XTestD_FRF=[XTestN_D_FRF;XTestP_D_FRF];
YTestD_FRF=[YTestN_D_FRF;YTestP_D_FRF];

%% Make row data
%{
rev=[];
XTrainDrFRF={};
for i=1:numel(XTrainDFRF)
        for j=1:size(XTrainDFRF{1},2)
            rev=[rev; (XTrainDFRF{i}(:,j))'];
        end
        rev={rev};
        XTrainDrFRF=[XTrainDrFRF;rev];
        rev=[];
end
XTestDrFRF={};
for i=1:numel(XTestDFRF)
        for j=1:size(XTestDFRF{1},2)
            rev=[rev; (XTestDFRF{i}(:,j))'];
        end
        rev={rev};
        XTestDrFRF=[XTestDrFRF;rev];
        rev=[];
end
%}