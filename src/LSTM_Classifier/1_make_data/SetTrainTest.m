%Stabilisco che giorni tenere nel dataset di Training e in quello di Test,
%effettuando delle operazioni preliminari alle timetable con la funzione
%preprocess, e li salvo in cell array.
%% Inizializzo 
XTrainN={};XTestN={};YTrainN=categorical();YTestN=categorical();
XTrainP={};XTestP={};YTrainP=categorical();YTestP=categorical();
YTrain3NorP=categorical();YTest3NorP=categorical();
if FRFflag==1 
    XTrainN_FRF={};XTestN_FRF={};
    XTrainP_FRF={};XTestP_FRF={};
end

%% Definisco i dataset di training e test → caso a vuoto (N)
date_trainN={'05_11','06_11','18a_12','18b_12','20_11'}; %in formato gg_mm
measure_trainN=[4,4,5,5,5]; %misure per ogni giorno di training
date_testN={'27_11'}; %in formato gg_mm
measure_testN=[5]; %misure per ogni giorno di test
NP='N';
for i=1:length(date_trainN) %per ciascun giorno
    for j=1:measure_trainN(i) %per ciascuna misura del giorno
        for k=1:5 %per ciascuna velocità
            eval(['XTrainN=[XTrainN; preprocess(acc_',date_trainN{i},'_N_',int2str(j),'_V',int2str(k),',NP,0)];']);
            if FRFflag == 1
                eval(['XTrainN_FRF=[XTrainN_FRF; preprocess(acc_',date_trainN{i},'_N_',int2str(j),'_V',int2str(k),',NP,1)];']);
            end
        end
        YTrainN=[YTrainN;categorical({'N1'});categorical({'N2'});categorical({'N3'});categorical({'N4'});categorical({'N5'})];
    end
end
for i=1:length(date_testN) %per ciascun giorno
    for j=1:measure_testN(i) %per ciascuna misura del giorno
        for k=1:5 %per ciascuna velocità
            eval(['XTestN=[XTestN; preprocess(acc_',date_testN{i},'_N_',int2str(j),'_V',int2str(k),',NP,0)];']);
            if FRFflag == 1
                eval(['XTestN_FRF=[XTestN_FRF; preprocess(acc_',date_testN{i},'_N_',int2str(j),'_V',int2str(k),',NP,1)];']);
            end
        end
        YTestN=[YTestN;categorical({'N1'});categorical({'N2'});categorical({'N3'});categorical({'N4'});categorical({'N5'})];
    end
end

%% Definisco i dataset di training e test → caso sotto carico (P)
date_trainP={'15_01','18a_12','23_12','20_11'}; %in formato gg_mm
measure_trainP=[4,2,5,4]; %misure per ogni giorno di training
date_testP={'27_11'}; %in formato gg_mm
measure_testP=[4]; %misure per ogni giorno di test
NP='P';
for i=1:length(date_trainP) %per ciascun giorno
    for j=1:measure_trainP(i) %per ciascuna misura del giorno
        for k=1:5 %per ciascuna velocità
            eval(['XTrainP=[XTrainP; preprocess(acc_',date_trainP{i},'_P_',int2str(j),'_V',int2str(k),',NP,0)];']);
            if FRFflag == 1
                eval(['XTrainP_FRF=[XTrainP_FRF; preprocess(acc_',date_trainP{i},'_P_',int2str(j),'_V',int2str(k),',NP,1)];']);
            end
        end
        YTrainP=[YTrainP;categorical({'P1'});categorical({'P2'});categorical({'P3'});categorical({'P4'});categorical({'P5'})];
    end
end
for i=1:length(date_testP) %per ciascun giorno
    for j=1:measure_testP(i) %per ciascuna misura del giorno
        for k=1:5 %per ciascuna velocità
            eval(['XTestP=[XTestP; preprocess(acc_',date_testP{i},'_P_',int2str(j),'_V',int2str(k),',NP,0)];']);   
            if FRFflag == 1
                 eval(['XTestP_FRF=[XTestP_FRF; preprocess(acc_',date_testP{i},'_P_',int2str(j),'_V',int2str(k),',NP,1)];']);
            end
        end
        YTestP=[YTestP;categorical({'P1'});categorical({'P2'});categorical({'P3'});categorical({'P4'});categorical({'P5'})];
    end
end
if FRFflag == 1
    YTrainN_FRF=YTrainN;
    YTestN_FRF=YTestN;
    YTrainP_FRF=YTrainP;
    YTestP_FRF=YTestP;
end

%% Rename features
% YTrainN=renamecats(YTrainN,{'V1_N','V2_N','V3_N','V4_N','V5_N'})';
% YTrainP=renamecats(YTrainP,{'V1_P','V2_P','V3_P','V4_P','V5_P'})';
% YTestN=renamecats(YTestN,{'V1_N','V2_N','V3_N','V4_N','V5_N'})';
% YTestP=renamecats(YTestP,{'V1_P','V2_P','V3_P','V4_P','V5_P'})';

