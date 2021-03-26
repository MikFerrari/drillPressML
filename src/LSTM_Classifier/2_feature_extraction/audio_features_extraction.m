freqThres = 55;
aFE = audioFeatureExtractor( ...
    "SampleRate",fs, ...
    "FFTLength", [], ...
    "OverlapLength",round(0.02*fs), ...
    "spectralCentroid",true, ...
    "spectralCrest",true, ...
    "spectralDecrease",true, ...
    "spectralEntropy",true, ...
    "spectralFlatness",true, ...
    "spectralFlux",false, ...
    "spectralKurtosis",true, ...
    "spectralRolloffPoint",true, ...
    "spectralSkewness",true, ...
    "spectralSlope",true, ...
    "spectralSpread",true);
setExtractorParams(aFE,"linearSpectrum","FrequencyRange",[0 freqThres]);
feature_idx = info(aFE);
feature_names = fields(feature_idx);
feature_names = cellfun(@(x) replace(x,'spectral',''),feature_names,'UniformOutput',false);
feature_names = cellfun(@(x) [lower(x(1)) x(2:end)],feature_names,'UniformOutput',false);
nrows=size(feature_names,1)*3;

XTrain3N=zeros(nrows,size(XTrainND,1));
for i=1:size(XTrainND,1)
    XTrain3N(:,i)=[extract(aFE,XTrainND{i}(:,1))';
        extract(aFE,XTrainND{i}(:,2))';
        extract(aFE,XTrainND{i}(:,3))'];
end

XTrain3P=zeros(nrows,size(XTrainPD,1));
for i=1:size(XTrainPD,1)
    XTrain3P(:,i)=[extract(aFE,XTrainPD{i}(:,1))';
        extract(aFE,XTrainPD{i}(:,2))';
        extract(aFE,XTrainPD{i}(:,3))'];
end

XTest3N=zeros(nrows,size(XTestND,1));
for i=1:size(XTestND,1)
    XTest3N(:,i)=[extract(aFE,XTestND{i}(:,1))';
        extract(aFE,XTestND{i}(:,2))';
        extract(aFE,XTestND{i}(:,3))'];
end

XTest3P=zeros(nrows,size(XTestPD,1));
for i=1:size(XTestPD,1)
    XTest3P(:,i)=[extract(aFE,XTestPD{i}(:,1))';
        extract(aFE,XTestPD{i}(:,2))';
        extract(aFE,XTestPD{i}(:,3))'];
end

% Merge features for NP and NorP
XTrain3=[XTrain3N XTrain3P];
XTest3=[XTest3N XTest3P];
YTrain3=[YTrainND' YTrainPD'];
YTest3=[YTestND' YTestPD'];

% XTrain3N=zeros(nrows,size(XTrainND,1));
% for i=1:size(XTrainND,1)
%     XTrain3N(:,i)=[rms(extract(aFE,XTrainND{i}(:,1))',2);
%         rms(extract(aFE,XTrainND{i}(:,2))',2);
%         rms(extract(aFE,XTrainND{i}(:,3))',2);
%         max(abs(XTrainND{i}))';
%         std(XTrainND{i})'];
% end
% 
% XTrain3P=zeros(nrows,size(XTrainPD,1));
% for i=1:size(XTrainPD,1)
%     XTrain3P(:,i)=[rms(extract(aFE,XTrainPD{i}(:,1))',2);
%         rms(extract(aFE,XTrainPD{i}(:,2))',2);
%         rms(extract(aFE,XTrainPD{i}(:,3))',2);
%         max(abs(XTrainPD{i}))';
%         std(XTrainPD{i})'];
% end
% 
% XTest3N=zeros(nrows,size(XTestND,1));
% for i=1:size(XTestND,1)
%     XTest3N(:,i)=[rms(extract(aFE,XTestND{i}(:,1))',2);
%         rms(extract(aFE,XTestND{i}(:,2))',2);
%         rms(extract(aFE,XTestND{i}(:,3))',2);
%         max(abs(XTrainND{i}))';
%         std(XTrainND{i})'];
% end
% 
% XTest3P=zeros(nrows,size(XTestPD,1));
% for i=1:size(XTestPD,1)
%     XTest3P(:,i)=[rms(extract(aFE,XTestPD{i}(:,1))',2);
%         rms(extract(aFE,XTestPD{i}(:,2))',2);
%         rms(extract(aFE,XTestPD{i}(:,3))',2);
%         max(abs(XTrainPD{i}))';
%         std(XTrainPD{i})'];
% end

% % XTrain3N=zeros(nrows,size(XTrainND,1));
% for i=1:size(XTrainND,1)
%     XTrain3P(:,i)=[rms(extract(aFE,XTrainND{i}(:,1))',2);
%         extract(aFE,XTrainND{i}(:,2))';
%         extract(aFE,XTrainND{i}(:,3))'];
% end
% 
% XTrain3P=zeros(nrows,size(XTrainPD,1));
% for i=1:size(XTrainPD,1)
%     XTrain3P(:,i)=[extract(aFE,XTrainPD{i}(:,1))';
%         extract(aFE,XTrainPD{i}(:,2))';
%         extract(aFE,XTrainPD{i}(:,3))'];
% end
% 
% XTest3N=zeros(nrows,size(XTestND,1));
% for i=1:size(XTestND,1)
%     XTest3N(:,i)=[extract(aFE,XTestND{i}(:,1))';
%         extract(aFE,XTestND{i}(:,2))';
%         extract(aFE,XTestND{i}(:,3))'];
% end
% 
% XTest3P=zeros(nrows,size(XTestPD,1));
% for i=1:size(XTestPD,1)
%     XTest3P(:,i)=[extract(aFE,XTestPD{i}(:,1))';
%         extract(aFE,XTestPD{i}(:,2))';
%         extract(aFE,XTestPD{i}(:,3))'];
% end
% 
% 
% % Merge features for NP and NorP
% XTrain3=[XTrain3N XTrain3P];
% XTest3=[XTest3N XTest3P];
% YTrain3=[YTrainND' YTrainPD'];
% YTest3=[YTestND' YTestPD'];

% Doppio merge
% XTrain3=[XTrain3N XTrain3P XTrain3P];
% XTest3=[XTest3N XTest3P XTest3P];
% YTrain3=[YTrainND' YTrainPD' YTrainPD'];
% YTest3=[YTestND' YTestPD' YTestPD'];

% features = extract(aFE,record(:,1));
% audio_featX=cellfun(@(x)extract(aFE,x(:,1))',XTrainND,'UniformOutput',false);
% audio_featY=cellfun(@(x)extract(aFE,x(:,2))',XTrainND,'UniformOutput',false);
% audio_featZ=cellfun(@(x)extract(aFE,x(:,3))',XTrainND,'UniformOutput',false);
% XTrain3N = [XTrain2N{:}];
% XTest3N = [XTest2N{:}];