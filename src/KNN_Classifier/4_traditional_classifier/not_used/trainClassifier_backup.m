% TRADITIONAL CLASSIFIER
% Run after |featureExtraction.m|

clearvars
load folderPaths.mat


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


%% Validation and Training of Models from Different Classification Algorithms

% classificationLearner


%% Testing of the Selected Model on the Test Dataset - Unfiltered Data

% loadFlag = 'N';
% loadFlag = 'P';
loadFlag = 'NP';

[trainedClassifier, validationAccuracy] = trainClassifier_unfilt_N(feat_unfilt_train_Norm);

% Training Data
pred_vel = trainedClassifier.predictFcn(feat_unfilt_train_Norm);
comp = (pred_vel == table2array(feat_unfilt_train_Norm(:,end)));
KNN_TrainAccuracy = (length(find(comp)))/length(comp)*100;
%{
train_results = addvars(feat_unfilt_train_Norm,pred_vel);
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
pred_vel = trainedClassifier.predictFcn(feat_unfilt_test_Norm);
comp = (pred_vel == table2array(feat_unfilt_test_Norm(:,end)));
KNN_TestAccuracy = (length(find(comp)))/length(comp)*100;

test_results = addvars(feat_unfilt_test_Norm,pred_vel);
test_results = sortrows(test_results,'velocity');

% Plot "staircase" accuracy diagram
figure('numbertitle','off','Name','Accuracy Diagram - Unfiltered Data','Visible','off')
scatter(1:numel(test_results.pred_vel),test_results.pred_vel)
hold on
plot(test_results.velocity,'LineWidth',2)
title('Actual vs Predicted Velocities - Testing Data');
legend('predicted','actual','location','northwest')
xlabel('entry number')
ylabel('velocity class')
grid on

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(plotsPath,'\KNN_accuracy_unfilt_',loadFlag,'.fig'))

% Plot Confusion Matrix
figure('numbertitle','off','Visible','off')
plotconfusion(test_results.velocity,test_results.pred_vel);
set(gcf,'Name','Confusion Matrix - Unfiltered Data');
title('Confusion Matrix - Testing Data')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(plotsPath,'\KNN_confusion_unfilt_',loadFlag,'.fig'))

disp('[KNN classifier - Unfiltered]');
disp(['Validation accuracy (5-folds): ',num2str(KNN_TrainAccuracy), ' %']);
disp(['Test Accuracy: ',num2str(KNN_TestAccuracy), ' %']);


%% Testing of the Selected Model on the Test Dataset - Filtered Data

% [trainedClassifier, validationAccuracy] = trainClassif_unfilt_NP_Method3(feat_filt_train_Norm);
[trainedClassifier, validationAccuracy] = prova(feat_filt_train_Norm);

% Training Data
pred_vel = trainedClassifier.predictFcn(feat_filt_train_Norm);
comp = (pred_vel == table2array(feat_filt_train_Norm(:,end)));
KNN_TrainAccuracy = (length(find(comp)))/length(comp)*100;
%{
train_results = addvars(feat_filt_train_Norm,pred_vel);
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
pred_vel = trainedClassifier.predictFcn(feat_filt_test_Norm);
comp = (pred_vel == table2array(feat_filt_test_Norm(:,end)));
KNN_TestAccuracy = (length(find(comp)))/length(comp)*100;

test_results = addvars(feat_filt_test_Norm,pred_vel);
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
savefig(strcat(plotsPath,'\KNN_accuracy_filt_',loadFlag,'.fig'))

% Plot Confusion Matrix
figure('numbertitle','off','Visible','off')
plotconfusion(test_results.velocity,test_results.pred_vel);
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('Confusion Matrix - Testing Data')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(plotsPath,'\KNN_confusion_filt_',loadFlag,'.fig'))

disp('[KNN classifier - Filtered]');
disp(['Validation accuracy (5-folds): ',num2str(KNN_TrainAccuracy), ' %']);
disp(['Test Accuracy: ',num2str(KNN_TestAccuracy), ' %']);