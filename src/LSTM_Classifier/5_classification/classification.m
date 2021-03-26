%%
% YTest3=renamecats(YTest3,{'V1_N','V2_N','V3_N','V4_N','V5_N','V1_P','V2_P','V3_P','V4_P','V5_P'});
% YTest3N=renamecats(YTestND,{'V1_N','V2_N','V3_N','V4_N','V5_N'})';
% YTest3P=renamecats(YTestPD,{'V1_P','V2_P','V3_P','V4_P','V5_P'})';

%% NorP
%Test with train data
% NorP_trainpred = classify(netNorP,XTrain3SD);
% NorP_train_accuracy = sum(NorP_trainpred == YTrain3NorP)/numel(YTrain3NorP)*100
% figure
% figure('numbertitle','off','Visible','off')
% plotconfusion(YTrain3NorP,NorP_trainpred);
% set(gcf,'Name','Confusion Matrix - Filtered Data');
% title('Confusion Matrix - NorP Training Data')

% Test with test data
NorP_testpred = classify(netNorP,XTest3SD);
NorP_test_accuracy = sum(NorP_testpred == YTest3NorP)/numel(YTest3NorP)*100
hNorP=figure('numbertitle','off','Visible','off')
plotconfusion(YTest3NorP,NorP_testpred,'Test');
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('NorP - Test Data')
%% N 
%Test with training data
% N_trainpred = classify(netN,XTrain3NSD);
% N_train_accuracy  = sum(N_trainpred == YTrain3N)/numel(YTrain3N)*100
% figure
% plotconfusion(YTrain3N,N_trainpred,'Train');

% Test with test data
N_testpred = classify(netN,XTest3NSD);
N_test_accuracy = sum(N_testpred == YTest3N)/numel(YTest3N)*100
hN=figure('numbertitle','off','Visible','off')
plotconfusion(YTest3N,N_testpred,'Test');
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('N - Test Data')
%% P
%Test with training data
% P_trainpred = classify(netP,XTrain3PSD);
% P_train_accuracy = sum(P_trainpred == YTrain3P)/numel(YTrain3P)*100
% figure
% plotconfusion(YTrain3P,P_trainpred,'Train');

% Test with test data
P_testpred = classify(netP,XTest3PSD);
P_test_accuracy = sum(P_testpred == YTest3P)/numel(YTest3P)*100
hP=figure('numbertitle','off','Visible','off')
plotconfusion(YTest3P,P_testpred,'Test');
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('P - Test Data')
%% NP (10 classes)
tic
%Test with train data
% NP_trainpred = classify(netNP,XTrain3SD);
% toc
% NP_train_accuracy = sum(NP_trainpred == YTrain3)/numel(YTrain3)*100
% figure
% plotconfusion(YTrain3,NP_trainpred,'Train');

% Test with test data
NP_testpred = classify(netNP,XTest3SD);
NP_test_accuracy = sum(NP_testpred == YTest3)/numel(YTest3)*100
hNP=figure('numbertitle','off','Visible','off')
plotconfusion(YTest3,NP_testpred,'Test');
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('NP - Test Data')

%% NP shuffled
% YTest3T=table(cellstr(YTest3'));YTest3T.Properties.VariableNames{1} = 'velocity';
% XT=array2table(XTest3SD');
% T=[XT YTest3T];
% T_shuff = T(randperm(size(T,1)),:);
% YTest=categorical(T.velocity)';
% T_shuff.velocity=[];
% XTest=table2array(T_shuff)';
% [XTest3SDs,YTest3s]=shuffle_data(XTest3SD,YTest3)
% NP_testpred = classify(netNP,XTest3SDs);
% NP_test_accuracy = sum(NP_testpred == YTest3s)/numel(YTest3s)*100
% hNP=figure('numbertitle','off','Visible','off')
% plotconfusion(YTest3s,NP_testpred,'Test');
% set(gcf,'Name','Confusion Matrix - Filtered Data');
% title('NP - Test Data')