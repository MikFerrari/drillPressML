% TRADITIONAL CLASSIFIER
% Run after |featureExtraction.m|

clearvars
load folderPaths.mat


%% Load Training and Testing data (Normalized Features)

load feat_filt_train.mat
load feat_filt_test.mat


%% Validation and Training of Models from Different Classification Algorithms

% classificationLearner


%% Testing of the Selected Model on the Test Dataset - Filtered Data

loadFlag = 'N';

% [trainedClassifier, validationAccuracy] = trainClassifier_filt_N(feat_filt_train);
[trainedClassifier, validationAccuracy] = trainClassifier_filt_N_manualFeat(feat_filt_train);
save(strcat(modelsPath,'\KNNmodel_filt_N.mat'),'trainedClassifier');

% Training Data
pred_vel = trainedClassifier.predictFcn(feat_filt_train);
comp = (pred_vel == table2array(feat_filt_train(:,end)));
KNN_TrainAccuracy = (length(find(comp)))/length(comp)*100;

%{
train_results = addvars(feat_filt_train,pred_vel);
train_results = sortrows(train_results,'velocity');

% Plot "staircase" accuracy diagram
figure
scatter(1:numel(train_results.pred_vel),train_results.pred_vel)
hold on
plot(train_results.velocity,'LineWidth',2)
title('Actual vs Predicted Velocities - Training Data');
legend('predicted','actual','location','northwest')
xlabel('entry number')
ylabel('velocity class')
grid on

% Plot Confusion Matrix
figure
plotconfusion(train_results.velocity,train_results.pred_vel);
title('Confusion Matrix - Training Data')
%}


% Testing Data
pred_vel = trainedClassifier.predictFcn(feat_filt_test);
comp = (pred_vel == table2array(feat_filt_test(:,end)));
KNN_TestAccuracy = (length(find(comp)))/length(comp)*100;

test_results = addvars(feat_filt_test,pred_vel);
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
savefig(strcat(resultsPath,'\KNN_accuracy_filt_',loadFlag,'.fig'))

% Plot Confusion Matrix
figure('numbertitle','off','Visible','off')
plotconfusion(test_results.velocity,test_results.pred_vel);
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('Confusion Matrix - Testing Data')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\KNN_confusion_filt_',loadFlag,'.fig'))
exportgraphics(gcf,strcat(resultsPath,'\KNN_confusion_filt_',loadFlag,'.pdf'))

disp('[KNN classifier - Filtered]');
disp(['Validation accuracy (5-folds): ',num2str(KNN_TrainAccuracy), ' %']);
disp(['Test Accuracy: ',num2str(KNN_TestAccuracy), ' %']);