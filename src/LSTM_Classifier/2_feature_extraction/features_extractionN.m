%Questo script si occupa dell'estrazione delle features da XTrainD e XTestD
tic
fmax=51;
%% pwelch
%Trovo il massimo a cui filtrare
kk=XTrainND{1}(:,1);
[ppkk,fkk]=pwelch(kk,[],[],[],fs);
idx=find(fkk<fmax);
max1=max(idx); %valore della riga che corrisponde a circa 60Hz

pwelchTrainN = cellfun(@(x)pwelch(x,[],[],[],fs)',XTrainND,'UniformOutput',false);
pwelchTestN = cellfun(@(x)pwelch(x,[],[],[],fs)',XTestND,'UniformOutput',false);

for i=1:numel(pwelchTrainN)
        pwelchTrainN{i}=pwelchTrainN{i}(:,(1:max1));
end
for i=1:numel(pwelchTestN)
        pwelchTestN{i}=pwelchTestN{i}(:,(1:max1));
end

%calcolo la media della pwelch filtrata su ogni asse (di quelle top)
mean_pwelchTrainN=cellfun(@(x)mean(x')',pwelchTrainN,'UniformOutput',false);
mean_pwelchTestN=cellfun(@(x)mean(x')',pwelchTestN,'UniformOutput',false);
rms_pwelchTrainN=cellfun(@(x)rms(x,2),pwelchTrainN,'UniformOutput',false);
rms_pwelchTestN=cellfun(@(x)rms(x,2),pwelchTestN,'UniformOutput',false);
std_pwelchTrainN=cellfun(@(x)std(x,0,2),pwelchTrainN,'UniformOutput',false);
std_pwelchTestN=cellfun(@(x)std(x,0,2),pwelchTestN,'UniformOutput',false);
%% spectrum
s=[];
spectrumTrainN={};
for i=1:numel(XTrainND)
        for j=1:size(XTrainND{1},2)
            [~,sp]=(spectrum(XTrainND{i}(:,j),fs));
            sp=(sp)';
            s=[s;sp];
        end
        spectrumTrainN=[spectrumTrainN;{s}];
    s=[];
end
spectrumTestN={};
for i=1:numel(XTestND)
        for j=1:size(XTestND{1},2)
            [~,sp]=(spectrum(XTestND{i}(:,j),fs));
            sp=(sp)';
            s=[s;sp];
        end
        spectrumTestN=[spectrumTestN;{s}];
    s=[];
end

%filtro tenendo lo spettro solo sotto i 50Hz
for i=1:numel(spectrumTrainN)
        spectrumTrainN{i}=spectrumTrainN{i}(:,1:fmax);
end
for i=1:numel(spectrumTestN)
        spectrumTestN{i}=spectrumTestN{i}(:,1:fmax);
end

%calcolo la media degli spettri filtrati
mean_spectrumTrainN=cellfun(@(x)mean(x')',spectrumTrainN,'UniformOutput',false);
mean_spectrumTestN=cellfun(@(x)mean(x')',spectrumTestN,'UniformOutput',false);
%% Massimo e deviazione standard
%massimo
maxTrainN=cellfun(@(x)max(x)',XTrainND,'UniformOutput',false);
maxTestN=cellfun(@(x)max(x)',XTestND,'UniformOutput',false);

%deviazione standard
stdTrainN=cellfun(@(x)std(x)',XTrainND,'UniformOutput',false);
stdTestN=cellfun(@(x)std(x)',XTestND,'UniformOutput',false);
%% FRF
%%{
if FRFflag == 1
    %calcolo la FRF già filtrata a 50Hz dalla funzione freqeuncyresponse
    frfTrain_absN = cellfun(@(x)frequencyresponse(x,fs,fmax,"abs"),XTrainND_FRF,'UniformOutput',false);
    frfTest_absN = cellfun(@(x)frequencyresponse(x,fs,fmax,"abs"),XTrainND_FRF,'UniformOutput',false);
    mean_frfTrain_absN = cellfun(@(x)mean(x)',frfTrain_absN,'UniformOutput',false);
    mean_frfTest_absN = cellfun(@(x)mean(x)',frfTest_absN,'UniformOutput',false);

    frfTrainRN = cellfun(@(x)frequencyresponse(x,fs,fmax,"real"),XTrainND_FRF,'UniformOutput',false);
    frfTestRN = cellfun(@(x)frequencyresponse(x,fs,fmax,"real"),XTrainND_FRF,'UniformOutput',false);
    mean_frfTrainRN = cellfun(@(x)mean(x)',frfTrainRN,'UniformOutput',false);
    mean_frfTestRN = cellfun(@(x)mean(x)',frfTestRN,'UniformOutput',false);

    frfTrainIN = cellfun(@(x)frequencyresponse(x,fs,fmax,"imag"),XTrainND_FRF,'UniformOutput',false);
    frfTestIN = cellfun(@(x)frequencyresponse(x,fs,fmax,"imag"),XTrainND_FRF,'UniformOutput',false);
    mean_frfTrainIN = cellfun(@(x)mean(x)',frfTrainIN,'UniformOutput',false);
    mean_frfTestIN = cellfun(@(x)mean(x)',frfTestIN,'UniformOutput',false);

    %Unisco
    for i=1:size(mean_frfTrainRN,1)
        mean_frfTrainN{i}=[mean_frfTrainRN{i};mean_frfTrainIN{i};mean_frfTrain_absN{i}];
        mean_frfTestN{i}=[mean_frfTestRN{i};mean_frfTestIN{i};mean_frfTest_absN{i}];
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
        XTrain2N{i}=[mean_pwelchTrainN{i};rms_pwelchTrainN{i};std_pwelchTrainN{i};mean_spectrumTrainN{i};mean_frfTrainN{i};maxTrainN{i};stdTrainN{i}];
    end
    for i=1:numel(XTestD)    
        XTest2N{i}=[mean_pwelchTestN{i};rms_pwelchTestN{i};std_pwelchTestN{i};mean_spectrumTestN{i};mean_frfTestN{i};maxTestN{i};stdTestN{i}];
    end
    
%Senza FRF
elseif FRFflag == 0
    for i=1:numel(XTrainND)    
        XTrain2N{i}=[mean_pwelchTrainN{i};rms_pwelchTrainN{i};std_pwelchTrainN{i};mean_spectrumTrainN{i};maxTrainN{i};stdTrainN{i}];
    end
    for i=1:numel(XTestND)    
        XTest2N{i}=[mean_pwelchTestN{i};rms_pwelchTestN{i};std_pwelchTestN{i};mean_spectrumTestN{i};maxTestN{i};stdTestN{i}];
    end
end

%Essendo ciascuna cella un vettore colonna è comodo passare dai cell array
%alle table, in cui ciascuna cella va a occupare una colonna e ciascuna
%riga corrisponde a una feature.
XTrain3N = [XTrain2N{:}];
XTest3N = [XTest2N{:}];

%I vettori con i label diventano vettori riga, comodo per come ragiona la LSTM.
YTrain3N=YTrainND'; 
YTest3N=YTestND';