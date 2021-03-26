%Questo script si occupa dell'estrazione delle features da XTrainD e XTestD
fmax=51;
%% pwelch
%Trovo il massimo a cui filtrare
kk=XTrainPD{1}(:,1);
[ppkk,fkk]=pwelch(kk,[],[],[],fs);
idx=find(fkk<fmax);
max1=max(idx); %valore della riga che corrisponde a circa 60Hz

pwelchTrainP = cellfun(@(x)pwelch(x,[],[],[],fs)',XTrainPD,'UniformOutput',false);
pwelchTestP = cellfun(@(x)pwelch(x,[],[],[],fs)',XTestPD,'UniformOutput',false);

for i=1:numel(pwelchTrainP)
        pwelchTrainP{i}=pwelchTrainP{i}(:,(1:max1));
end
for i=1:numel(pwelchTestP)
        pwelchTestP{i}=pwelchTestP{i}(:,(1:max1));
end

%calcolo la media della pwelch filtrata su ogni asse (di quelle top)
mean_pwelchTrainP=cellfun(@(x)mean(x')',pwelchTrainP,'UniformOutput',false);
mean_pwelchTestP=cellfun(@(x)mean(x')',pwelchTestP,'UniformOutput',false);
rms_pwelchTrainP=cellfun(@(x)rms(x,2),pwelchTrainP,'UniformOutput',false);
rms_pwelchTestP=cellfun(@(x)rms(x,2),pwelchTestP,'UniformOutput',false);
std_pwelchTrainP=cellfun(@(x)std(x,0,2),pwelchTrainP,'UniformOutput',false);
std_pwelchTestP=cellfun(@(x)std(x,0,2),pwelchTestP,'UniformOutput',false);
%% spectrum
s=[];
spectrumTrainP={};
for i=1:numel(XTrainPD)
        for j=1:size(XTrainPD{1},2)
            [~,sp]=(spectrum(XTrainPD{i}(:,j),fs));
            sp=(sp)';
            s=[s;sp];
        end
        spectrumTrainP=[spectrumTrainP;{s}];
    s=[];
end
spectrumTestP={};
for i=1:numel(XTestPD)
        for j=1:size(XTestPD{1},2)
            [~,sp]=(spectrum(XTestPD{i}(:,j),fs));
            sp=(sp)';
            s=[s;sp];
        end
        spectrumTestP=[spectrumTestP;{s}];
    s=[];
end

%filtro tenendo lo spettro solo sotto i 50Hz
for i=1:numel(spectrumTrainP)
        spectrumTrainP{i}=spectrumTrainP{i}(:,1:fmax);
end
for i=1:numel(spectrumTestP)
        spectrumTestP{i}=spectrumTestP{i}(:,1:fmax);
end

%calcolo la media degli spettri filtrati
mean_spectrumTrainP=cellfun(@(x)mean(x')',spectrumTrainP,'UniformOutput',false);
mean_spectrumTestP=cellfun(@(x)mean(x')',spectrumTestP,'UniformOutput',false);
%% Massimo e deviazione standard
%massimo
maxTrainP=cellfun(@(x)max(x)',XTrainPD,'UniformOutput',false);
maxTestP=cellfun(@(x)max(x)',XTestPD,'UniformOutput',false);

%deviazione standard
stdTrainP=cellfun(@(x)std(x)',XTrainPD,'UniformOutput',false);
stdTestP=cellfun(@(x)std(x)',XTestPD,'UniformOutput',false);
%% FRF
%%{
if FRFflag == 1
    %calcolo la FRF già filtrata a 50Hz dalla funzione freqeuncyresponse
    frfTrain_absP = cellfun(@(x)frequencyresponse(x,fs,fmax,"abs"),XTrainPD_FRF,'UniformOutput',false);
    frfTest_absP = cellfun(@(x)frequencyresponse(x,fs,fmax,"abs"),XTrainPD_FRF,'UniformOutput',false);
    mean_frfTrain_absP = cellfun(@(x)mean(x)',frfTrain_absP,'UniformOutput',false);
    mean_frfTest_absP = cellfun(@(x)mean(x)',frfTest_absP,'UniformOutput',false);

    frfTrainRP = cellfun(@(x)frequencyresponse(x,fs,fmax,"real"),XTrainPD_FRF,'UniformOutput',false);
    frfTestRP = cellfun(@(x)frequencyresponse(x,fs,fmax,"real"),XTrainPD_FRF,'UniformOutput',false);
    mean_frfTrainRP = cellfun(@(x)mean(x)',frfTrainRP,'UniformOutput',false);
    mean_frfTestRP = cellfun(@(x)mean(x)',frfTestRP,'UniformOutput',false);

    frfTrainIP = cellfun(@(x)frequencyresponse(x,fs,fmax,"imag"),XTrainPD_FRF,'UniformOutput',false);
    frfTestIP = cellfun(@(x)frequencyresponse(x,fs,fmax,"imag"),XTrainPD_FRF,'UniformOutput',false);
    mean_frfTrainIP = cellfun(@(x)mean(x)',frfTrainIP,'UniformOutput',false);
    mean_frfTestIP = cellfun(@(x)mean(x)',frfTestIP,'UniformOutput',false);

    %Unisco
    for i=1:size(mean_frfTrainRP,1)
        mean_frfTrainP{i}=[mean_frfTrainRP{i};mean_frfTrainIP{i};mean_frfTrain_absP{i}];
        mean_frfTestP{i}=[mean_frfTestRP{i};mean_frfTestIP{i};mean_frfTest_absP{i}];
    end
end
%}
%% Combine all features
%combino tutte le features in un unico cell array. 
%In ogni cella ciascuna feature occupa una riga. In questo caso, usando
%solo medie, ciascuna cella sarà quindi un vettore colonna, ma questa
%struttura è molto comoda nel caso in cui una features sia un vettore, in
%questo modo andrebbe ad occupare una riga di ciascuna cella. 

% Con FRF
if FRFflag == 1
    for i=1:numel(XTrainD)    
        XTrain2P{i}=[mean_pwelchTrainP{i};rms_pwelchTrainP{i};std_pwelchTrainP{i};mean_spectrumTrainP{i};mean_frfTrain{i};maxTrainP{i};stdTrainP{i}];
    end
    for i=1:numel(XTestD)    
        XTest2P{i}=[mean_pwelchTestP{i};rms_pwelchTestP{i};std_pwelchTestP{i};mean_spectrumTestP{i};mean_frfTest{i};maxTestP{i};stdTestP{i}];
    end
    
%Senza FRF
elseif FRFflag == 0
    for i=1:numel(XTrainPD)    
        XTrain2P{i}=[mean_pwelchTrainP{i};rms_pwelchTrainP{i};std_pwelchTrainP{i};mean_spectrumTrainP{i};maxTrainP{i};stdTrainP{i}];
    end
    for i=1:numel(XTestPD)    
        XTest2P{i}=[mean_pwelchTestP{i};rms_pwelchTestP{i};std_pwelchTestP{i};mean_spectrumTestP{i};maxTestP{i};stdTestP{i}];
    end
end

%Essendo ciascuna cella un vettore colonna è comodo passare dai cell array
%alle table, in cui ciascuna cella va a occupare una colonna e ciascuna
%riga corrisponde a una feature.
XTrain3P = [XTrain2P{:}];
XTest3P = [XTest2P{:}];

%I vettori con i label diventano vettori riga, comodo per come ragiona la LSTM.
YTrain3P=YTrainPD'; 
YTest3P=YTestPD';