%% DOUBLE STEP KNN CLASSIFICATION
% Used in |drillPressML_main.m|

tic
clearvars
load folderPaths.mat


%% Train model for distinguishing between no-Load and Load conditions

disp('- Extracting features from Load and no-Load data (double-step classification)...')
disp('--> STEP 1')
featureExtraction_NorP
% featureExtraction_NorP_manualFeat

%%
disp('- Training classification model (KNN-algorithm) on Load and no-Load data (double-step classification)...')
disp('--> STEP 1')
traditionalClassifier_NorP

feat_test_N = test_results(test_results.pred_vel == 'N',:);
feat_test_N = feat_test_N(:,1:end-1);
feat_test_P = test_results(test_results.pred_vel == 'P',:);
feat_test_P = feat_test_P(:,1:end-1);


%% Predict velocity within N or P class separately

% No-Load
disp('- Predict velocity among data under NO operation condition (double-step classification)...')
disp('--> STEP 2 - no-Load')
predict_N_2steps

% Load
disp('- Predict velocity among data under operation condition (double-step classification)...')
disp('--> STEP 2 - Load')
predict_P_2steps


%% Compute Overall Accuracy and Confusion Matrix

actual = [actual_N; actual_P];
pred = [pred_N; pred_P];

results = table(actual,pred);
results_sorted = sortrows(results,'actual');

% Plot "staircase" accuracy diagram
figure('numbertitle','off','Name','Accuracy Diagram - Filtered Data','Visible','off')
scatter(1:numel(results_sorted.pred),results_sorted.pred)
hold on
plot(results_sorted.actual,'LineWidth',2)
title('Actual vs Predicted Velocities - Testing Data');
legend('predicted','actual','location','northwest')
xlabel('entry number')
ylabel('velocity class')
grid on

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\KNN_accuracy_filt_2steps_total.fig'))

% Plot Confusion Matrix
figure('numbertitle','off','Visible','off')
plotconfusion(results_sorted.actual,results_sorted.pred);
set(gcf,'Name','Confusion Matrix - Filtered Data');
title('Confusion Matrix - Testing Data')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\KNN_confusion_filt_2steps_total.fig'))

toc