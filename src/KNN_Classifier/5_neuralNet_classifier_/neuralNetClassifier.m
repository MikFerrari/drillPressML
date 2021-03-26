% NEURAL NETWORK CLASSIFIER
% Run after |featureExtraction.m|
% Alternative approach compared to |traditionalClassifier.m|

clearvars
load folderPaths.mat
load labelMap.mat

%% Load Training and Testing data (Features)

% Un-normalized
load feat_unfilt_train_unNorm.mat
load feat_unfilt_test_unNorm.mat
load feat_filt_train_unNorm.mat
load feat_filt_test_unNorm.mat

% Normalized
load feat_unfilt_train_Norm.mat
load feat_unfilt_test_Norm.mat
load feat_filt_train_Norm.mat
load feat_filt_test_Norm.mat

numFeatures = size(feat_unfilt_train_Norm,2)-1;

% Only No Load operations
% numResponses = size(labelMap.labelValueN,1);

% Load and No-load operations
numResponses = size(labelMap.labelValueN,1)+size(labelMap.labelValueP,1);


%% LSTM Neural Network Initialization and Training

numHiddenUnits = 50;

XTrain = feat_unfilt_train_Norm(:,1:end-1).Variables';
YTrain = feat_unfilt_train_Norm.velocity';
XTest = feat_unfilt_test_Norm(:,1:end-1).Variables';
YTest = feat_unfilt_test_Norm(:,end).velocity';

layers = [ ...
    sequenceInputLayer(numFeatures,'Name','Input')
    lstmLayer(numHiddenUnits,'Name','Hidden')
    dropoutLayer(0.05,'Name','Dropout') 
    fullyConnectedLayer(numResponses)
    softmaxLayer('Name','SoftMax')
    classificationLayer('Name','Output')
    ];

options = trainingOptions('adam', ...
    'MaxEpochs',100,...
    'MiniBatchSize',150, ...
    'InitialLearnRate',0.002, ...
    'GradientThreshold',1, ...
    'ExecutionEnvironment','cpu',...
    'Plots','training-progress', ...
    'ValidationData',{XTest,YTest}, ...
    'ValidationFrequency',2, ... 
    'Verbose',false);

net = trainNetwork(XTrain,YTrain,layers,options);


%% LSTM Neural Network Accuracy Assessment

% Test with training data
YPred_test = classify(net,XTrain);
LSTM_TrainAccuracy = sum(YPred_test == YTrain)/numel(YTrain)*100;
figure
plotconfusion(YTrain,YPred_test,'Train');
title('Confusion Matrix - Training Data')

% Test with test data
YPred_test = classify(net,XTest);
LSTM_TestAccuracy = sum(YPred_test == YTest)/numel(YTest)*100;
figure
plotconfusion(YTest,YPred_test,'Test');
title('Confusion Matrix - Testing Data')

disp('[LSTM Neural Network classification]');
disp(['Validation accuracy: ',num2str(LSTM_TrainAccuracy), ' %']);
disp(['Test Accuracy: ',num2str(LSTM_TestAccuracy), ' %']);


%% Pattern Neural Network Initialization and Training

% Reset random number generators
rng default

% Initialize a Neural Network with 18 nodes in hidden layer
% (assume the choice of the number 18 here is arbitrary)
net = patternnet(18);

% Train network
XTrain = table2array(feat_unfilt_train_Norm(:,1:end-1));
YTrain = zeros(size(feat_unfilt_train_Norm,1),1);
for i = 1:size(feat_unfilt_train_Norm,1)
    % Only No Load operations
    % YTrain(i) = labelMap.labelNum(labelMap.labelValue == feat_unfilt_train_Norm.velocity(i));
    
    % Load and No-load operations
    idxN = labelMap.labelValueN == feat_unfilt_train_Norm.velocity(i);
    idxP = labelMap.labelValueP == feat_unfilt_train_Norm.velocity(i);
    if sum(idxN ~= 0) ~= 0
        YTrain(i) = labelMap.labelNum(idxN);
    else
        YTrain(i) = labelMap.labelNum(idxP)+size(labelMap.labelNum,1);
    end
end

net = train(net,XTrain',dummyvar(YTrain)');

%% Pattern Neural Network Accuracy Assessment

% Training data
pred_train = net(XTrain');
%pred_train = round(pred_train);

YPred_train = zeros(size(pred_train,2),1);
for i = 1:size(YPred_train,1)
    [~,result] = max(pred_train(:,i));
    [Q,R] = quorem(sym(result),sym(size(labelMap.labelNum,1)));
        
    if eval(R) == 0
        idx = size(labelMap.labelNum,1);
    else
        idx = R;
    end
        
    YPred_train(i) = labelMap.labelNum(idx);
end

PATT_TrainAccuracy = sum(YPred_train == YTrain)/numel(YTrain)*100;
figure
plotconfusion(dummyvar(YTrain)',pred_train)
title('Confusion Matrix - Training Data')


% Testing data
XTest = table2array(feat_unfilt_test_Norm(:,1:end-1));
YTest = zeros(size(feat_unfilt_test_Norm,1),1);
for i = 1:size(feat_unfilt_test_Norm,1)
    % Only No Load operations
    % YTest(i) = labelMap.labelNum(labelMap.labelValue == feat_unfilt_train_Norm.velocity(i));
    
    % Load and No-load operations
    idxN = labelMap.labelValueN == feat_unfilt_test_Norm.velocity(i);
    idxP = labelMap.labelValueP == feat_unfilt_test_Norm.velocity(i);
    if sum(idxN ~= 0) ~= 0
        YTest(i) = labelMap.labelNum(idxN);
    else
        YTest(i) = labelMap.labelNum(idxP)+size(labelMap.labelNum,1);
    end
end

pred_test = net(XTest');
% pred_test = round(pred_test);

YPred_test = zeros(size(pred_test,2),1);
for i = 1:size(YPred_test,1)
    [~,result] = max(pred_test(:,i));
    [Q,R] = quorem(sym(result),sym(size(labelMap.labelNum,1)));
        
    if eval(R) == 0
        idx = size(labelMap.labelNum,1);
    else
        idx = R;
    end
        
    YPred_test(i) = labelMap.labelNum(idx);
end

PATT_TestAccuracy = sum(YPred_test == YTest)/numel(YTest)*100;
figure
plotconfusion(dummyvar(YTest)',pred_test)
title('Confusion Matrix - Testing Data')


disp('[Pattern Neural Network classification]');
disp(['Validation Accuracy: ',num2str(PATT_TrainAccuracy), ' %']);
disp(['Test Accuracy: ',num2str(PATT_TestAccuracy), ' %']);