clear
clc


%% 0) FRF yes/no?

FRFflag=0; %No FRF
% FRFflag=1; %Yes FRF


%% 1) data

make_data;


%% 2) feature exctraction: select manual features or audio features

% MSorAFE=0; %manual features
MSorAFE=1; %audio features

if MSorAFE==0
    features_extractionN;
    features_extractionP;
    features_extractionNP;
elseif MSorAFE==1
    audio_features_extraction;
end

%% 3) Normalization

normalization;
summary(YTrain3)
summary(YTest3)
clearvars -except XTrain3 XTest3 XTrain3SD XTest3SD XTrain3NSD XTest3NSD XTrain3PSD XTest3PSD ...
                  YTrain3 YTest3 YTrain3N YTrain3P YTest3N YTest3P YTrain3NorP YTest3NorP
              
              
%% Rename features

YTrain3=renamecats(YTrain3,{'V1_N: 560 RPM','V2_N: 780 RPM','V3_N: 1200 RPM','V4_N: 1900 RPM','V5_N: 3000 RPM','V1_P: 560 RPM','V2_P: 780 RPM','V3_P: 1200 RPM','V4_P: 1900 RPM','V5_P: 3000 RPM'});
YTrain3N=renamecats(YTrainND,{'V1_N: 560 RPM','V2_N: 780 RPM','V3_N: 1200 RPM','V4_N: 1900 RPM','V5_N: 3000 RPM'})';
YTrain3P=renamecats(YTrainPD,{'V1_P: 560 RPM','V2_P: 780 RPM','V3_P: 1200 RPM','V4_P: 1900 RPM','V5_P: 3000 RPM'})';
YTest3=renamecats(YTest3,{'V1_N: 560 RPM','V2_N: 780 RPM','V3_N: 1200 RPM','V4_N: 1900 RPM','V5_N: 3000 RPM','V1_P: 560 RPM','V2_P: 780 RPM','V3_P: 1200 RPM','V4_P: 1900 RPM','V5_P: 3000 RPM'});
YTest3N=renamecats(YTestND,{'V1_N: 560 RPM','V2_N: 780 RPM','V3_N: 1200 RPM','V4_N: 1900 RPM','V5_N: 3000 RPM'})';
YTest3P=renamecats(YTestPD,{'V1_P: 560 RPM','V2_P: 780 RPM','V3_P: 1200 RPM','V4_P: 1900 RPM','V5_P: 3000 RPM'})';


%% 4)Train networks

NorP_train_net;
N_train_net;
P_train_net;
NP_train_net;


%% 5) Classification

classification;


%% 6) PCA

if MSorAFE==0
    [TsortedNP,coeffNP,~,explainedNP]=makePCA(XTrain3SD,FRFflag,"NP");
    [TsortedN,coeffN,~,explainedN]=makePCA(XTrain3NSD,FRFflag,"N");
    [TsortedP,coeffP,~,explainedP]=makePCA(XTrain3PSD,FRFflag,"P");

elseif MSorAFE==1
    [TsortedNP,coeffNP,~,explainedNP]=makePCAaudio(XTrain3SD,"NP");
    [TsortedN,coeffN,~,explainedN]=makePCAaudio(XTrain3NSD,"N");
    [TsortedP,coeffP,~,explainedP]=makePCAaudio(XTrain3PSD,"P");
end