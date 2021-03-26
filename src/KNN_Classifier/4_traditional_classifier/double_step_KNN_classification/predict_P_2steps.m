load KNNmodel_filt_P
loadFlag = 'P';

pred_vel = trainedClassifier.predictFcn(feat_test_P);
comp = (pred_vel == table2array(feat_test_P(:,end-1)));
KNN_TestAccuracy = (length(find(comp)))/length(comp)*100;

test_results = addvars(feat_test_P,pred_vel);
test_results = sortrows(test_results,'velocity');

% Plot "staircase" accuracy diagram
figure('numbertitle','off','Name','Accuracy Diagram - Filtered Data','Visible','off')
scatter(1:numel(test_results.pred_vel),test_results.pred_vel)
hold on
plot(test_results.velocity,'LineWidth',2)
title('Actual vs Predicted Velocities - Testing Data');
legend('predicted','actual','location','northwest')
xlabel('entry number')
ylabel('velocity class')
grid on

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\KNN_accuracy_filt_',loadFlag,'_2steps.fig'))

% Plot Confusion Matrix
figure('numbertitle','off','Visible','off')
plotconfusion(test_results.velocity,test_results.pred_vel);
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('Confusion Matrix - Testing Data')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\KNN_confusion_filt_',loadFlag,'_2steps.fig'))

disp('[KNN classifier - Filtered]');
disp(['Validation accuracy (5-folds): ',num2str(KNN_TrainAccuracy), ' %']);
disp(['Test Accuracy: ',num2str(KNN_TestAccuracy), ' %']);

% Get numerical values in the Confusion Matrix
% confMat_P = confusionmat(test_results.velocity,test_results.pred_vel)';
% Transpose in order to keep consistent with the convention used by plotconfusion

actual_P = test_results.velocity;
pred_P = test_results.pred_vel;