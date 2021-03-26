%% ACCURACY EVALUATION THROUGH BOOTSTRAPPING (NP case, single-step classification)

% load folderPaths
% load feat_filt_test

% load('workspace.mat')
X=XTest3SD;
Y=YTest3;
modelNP = netNP;
% modelNP = modelNP.trainedClassifier;
loadFlag = '1step';
A=array2table(X');
YT=table(cellstr(Y)'); YT.Properties.VariableNames{1} = 'Y';
feat_filt_test=[A,YT];

% %% ACCURACY EVALUATION THROUGH BOOTSTRAPPING (NP case, single-step classification)
% 
% load folderPaths
% load feat_filt_test
% 
% modelNP = load('KNNmodel_filt_NP');
% modelNP = modelNP.trainedClassifier;
% loadFlag = '1step';

%% Perform Bootstrapping

nboot = round(height(feat_filt_test)/5);
sample_size = round(height(feat_filt_test)/10);
bootstat = table();
accuracies = [];

for i = 1:nboot
%     feat_filt_test_shuffled = feat_filt_test(randperm(size(feat_filt_test,1)),:);
%     feat_filt_test_shuffled = feat_filt_test;
%     selectedData = feat_filt_test_shuffled(1:sample_size,:);
    r = randi([1 size(feat_filt_test,1)-sample_size],1,1);
    selectedData = feat_filt_test(r:r+sample_size,:);
    Ys=categorical(selectedData.Y);
    selectedData.Y=[];
    selectedData=table2array(selectedData);

    sim_result = simulateTest_1step(selectedData',Ys,modelNP);
    bootstat = [bootstat; sim_result];
    actualA=categorical(sim_result.actual);
    predictedA=categorical(sim_result.predicted);
    accuracy = sum(actualA == predictedA)/numel(actualA)*100;
    accuracies = [accuracies accuracy];
end

actual = categorical(bootstat.actual);
pred = categorical(bootstat.predicted);

% Compute Confidence Interval (95%)
accuracies = sort(accuracies,'ascend');
alpha = 0.95;
p = ((1.0-alpha)/2.0)*100;
lower = max(0.0,prctile(accuracies, p));
p = (alpha+((1.0-alpha)/2.0))*100;
upper = min(100.0,prctile(accuracies, p));

%% Display Accuracy Results

disp(['Mean accuracy: ' + string(mean(accuracies)) + ' %'])
disp(['Confidence Interval: [' + string(lower) + ', ' + string(upper) + ']'])

figure('numbertitle','off','Visible','on')
histogram(accuracies,15); % 10 = nbins
title('Accuracy Single-Step Classification')
xlabel('Accuracy')
ylabel('N° of simulations')
hold on
ax = gca;
xline(mean(accuracies),'-','mean','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
xline(lower,'-','2.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
xline(upper,'-','97.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)

% set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
% savefig(strcat(resultsPath,'\accuracy_histCI_bootstrap_',loadFlag,'.fig'))


%% Plot Confusion Matrix
figure('numbertitle','off','Visible','on') % Set to 'off'
plotconfusion(actual,pred);
set(gcf,'Name','Confusion Matrix - Bootstrapping');
title('Confusion Matrix - Testing Data')

% set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
% savefig(strcat(resultsPath,'\accuracy_confusion_bootstrap_',loadFlag,'.fig'))