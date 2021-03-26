%% ACCURACY EVALUATION THROUGH BOOTSTRAPPING (NP case, double-step classification)

load folderPaths
load feat_filt_test

modelN = load('KNNmodel_filt_N');
modelN = modelN.trainedClassifier;
modelP = load('KNNmodel_filt_P');
modelP = modelP.trainedClassifier;
modelNorP = load('KNNmodel_filt_NorP');
modelNorP = modelNorP.trainedClassifier;

loadFlag = '2steps';


%% Perform Bootstrapping

nboot = round(height(feat_filt_test)/10);
sample_size = round(height(feat_filt_test)/10);
bootstat = table();
accuracies = [];


for i = 1:nboot
    feat_filt_test_shuffled = feat_filt_test(randperm(size(feat_filt_test,1)),:);
    selectedData = feat_filt_test_shuffled(1:sample_size,:);
    sim_result = simulateTest_2steps(selectedData,modelNorP,modelN,modelP);
    bootstat = [bootstat; sim_result];
    
    accuracy = sum(sim_result.actual == sim_result.predicted)/numel(sim_result.actual)*100;
    accuracies = [accuracies accuracy];
end

actual = bootstat.actual;
pred = bootstat.predicted;

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

figure('numbertitle','off','Visible','off')
histogram(accuracies,15); % 10 = nbins
title('Accuracy Double-Step Classification')
xlabel('Accuracy')
ylabel('N° of simulations')
hold on
ax = gca;
xline(mean(accuracies),'-','mean','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
xline(lower,'-','2.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
xline(upper,'-','97.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\accuracy_histCI_bootstrap_',loadFlag,'.fig'))

% Italian Plot
figure('numbertitle','off','Visible','off')
histogram(accuracies,15,'EdgeColor','w','FaceColor','#4DBEEE');
title('KNN - Accuracy Classificazione Double-Step')
xlabel('Accuracy')
ylabel('Numero di simulazioni')
hold on
ax = gca;
pbaspect([2 1 1])
xline(mean(accuracies),'-','mean','LabelVerticalAlignment','middle','LabelHorizontalAlignment','left','Color',[1 0 0],'LineWidth',2)
xline(lower,'-','2.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','left','Color',[1 0 0],'LineWidth',2)
xline(upper,'-','97.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','left','Color',[1 0 0],'LineWidth',2)

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\accuracy_histCI_bootstrap_',loadFlag,'ITA.fig'))
exportgraphics(gcf,strcat(resultsPath,'\accuracy_histCI_bootstrap_',loadFlag,'_ITA.pdf'))


%% Plot Confusion Matrix

figure('numbertitle','off','Visible','off')
plotconfusion(actual,pred);
set(gcf,'Name','Confusion Matrix - Bootstrapping');
title('Confusion Matrix - Testing Data')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\accuracy_confusion_bootstrap_',loadFlag,'.fig'))