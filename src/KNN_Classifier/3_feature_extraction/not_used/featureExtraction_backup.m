% FEATURE EXTRACTION (backup)
% Run after |dataPreprocessing.m|
tic
clearvars
load folderPaths.mat

%% Load Preprocessed Filtered and Filtered Data

load accUnfilteredDataset.mat
load accFilteredDataset.mat
load accTimetableNames.mat


%% Dataset Selection

accelerations = [accUnfilteredDataset accFilteredDataset accTimetableNames];

% Select variables (timetables corresponding to one day) by names
% |No-load operations|
% names_acc_train = {'06_11_N','18_12am_N','18_12pm_N','20_11_N'};
% names_acc_test = {'05_11_N','27_11_N'};
%               
% exclusions_train = {};
% exclusions_test = {};

% |Load operations|
% names_acc_train = {'27_11_P','18_12am_P','20_11_P','23_12_P'};
% names_acc_test = {'15_01_P'};
%               
% exclusions_train = {'27_11_P_1'};
% exclusions_test = {};

% |Load and No-load operations|
names_acc_train = {'06_11_N_1','06_11_N_2','18_12am_N_1','18_12am_N_2','18_12am_N_3', ...
                   '18_12pm_N_1','18_12pm_N_2', ...
                   '20_11_N_1','20_11_N_2','20_11_N_3' ...
                   '27_11_P','18_12am_P','20_11_P','23_12_P'};
names_acc_test = {'05_11_N_1','27_11_N_1','27_11_N_2' ...
                  '15_01_P'};
              
exclusions_train = {'27_11_P_1'};
exclusions_test = {};


idx_acc_train = [];
idx_acc_test = [];
for i = 1:length(accTimetableNames)
    if containsStrings(accTimetableNames{i},names_acc_train,exclusions_train)
        idx_acc_train = [idx_acc_train i];
    end
    if containsStrings(accTimetableNames{i},names_acc_test,exclusions_test)
        idx_acc_test = [idx_acc_test i];
    end
end

acc_train = accelerations(idx_acc_train,:);
acc_test = accelerations(idx_acc_test,:);

% Prepare datasets for feature extraction
acc_unfilt_train = acc_train(:,1);
acc_unfilt_test = acc_test(:,1);
% acc_filt_train = acc_train(:,2);
% acc_filt_test = acc_test(:,2);


%% Feature Selection and Extraction

% Set parameters for feature extraction algorithm
recordLength = 1;   % s
fs = 2000;          % Hz

% Training data
feat_unfilt_train = table;
% feat_filt_train = table;
for i = 1:length(acc_train)
    feat_unfilt_train = [feat_unfilt_train; ...
                         extrFeatFromBuffers(acc_unfilt_train{i},recordLength,fs)];
%     feat_filt_train = [feat_filt_train; ...
%                        extrFeatFromBuffers(acc_filt_train{i},recordLength,fs)];
end

% Testing data
feat_unfilt_test = table;
% feat_filt_test = table;
for i = 1:length(acc_test)
    feat_unfilt_test = [feat_unfilt_test; ...
                        extrFeatFromBuffers(acc_unfilt_test{i},recordLength,fs)];
%     feat_filt_test = [feat_filt_test; ...
%                       extrFeatFromBuffers(acc_filt_test{i},recordLength,fs)];
end

% Save un-normalized features
save(strcat(featuresPath,'\feat_unfilt_train_unNorm.mat'),'feat_unfilt_train')
% save(strcat(featuresPath,'\feat_filt_train_unNorm.mat'),'feat_filt_train')
save(strcat(featuresPath,'\feat_unfilt_test_unNorm.mat'),'feat_unfilt_test')
% save(strcat(featuresPath,'\feat_filt_test_unNorm.mat'),'feat_filt_test')


%% Feature Selection and Extraction

% % Split signals into records of specified length
% recordLength = 1;   % s
% 
% acc_unfilt_train = splitInRecords(acc_unfilt_train,recordLength);
% acc_unfilt_test = splitInRecords(acc_unfilt_test,recordLength);
% % acc_filt_train = splitInRecords(acc_filt_train,recordLength);
% % acc_filt_test = splitInRecords(acc_filt_test,recordLength);
% 
% % Set parameters for feature extraction algorithm
% fs = 2000;          % Hz
% 
% % Training data
% feat_unfilt_train = cellfun(@(x) extractFeatures_Method2(x,fs),acc_unfilt_train,'UniformOutput',false);
% % feat_filt_train = cellfun(@(x) extractFeatures_Method2(x,fs),acc_filt_train,'UniformOutput',false);
% 
% feat_unfilt_train = vertcat(feat_unfilt_train{:});
% % feat_filt_train = vertcat(feat_filt_train{:});
% 
% % Testing data
% feat_unfilt_test = cellfun(@(x) extractFeatures_Method2(x,fs),acc_unfilt_test,'UniformOutput',false);
% % feat_filt_test = cellfun(@(x) extractFeatures_Method2(x,fs),acc_filt_test,'UniformOutput',false);
% 
% feat_unfilt_test = vertcat(feat_unfilt_test{:});
% % feat_filt_test = vertcat(feat_filt_test{:});
% 
% % Save un-normalized features
% save(strcat(featuresPath,'\feat_unfilt_train_unNorm.mat'),'feat_unfilt_train')
% % save(strcat(featuresPath,'\feat_filt_train_unNorm.mat'),'feat_filt_train')
% save(strcat(featuresPath,'\feat_unfilt_test_unNorm.mat'),'feat_unfilt_test')
% % save(strcat(featuresPath,'\feat_filt_test_unNorm.mat'),'feat_filt_test')


%% Feature Selection and Extraction

% % Split signals into records of specified length
% recordLength = 1;   % s
% 
% acc_unfilt_train = splitInRecords(acc_unfilt_train,recordLength);
% acc_unfilt_test = splitInRecords(acc_unfilt_test,recordLength);
% % acc_filt_train = splitInRecords(acc_filt_train,recordLength);
% % acc_filt_test = splitInRecords(acc_filt_test,recordLength);
% 
% % Set parameters for feature extraction algorithm
% fs = 2000;          % Hz
% 
% % Training data
% feat_unfilt_train = extractFeatures_Method3(acc_unfilt_train,fs);
% % feat_filt_train = extractFeatures_Method3(acc_filt_train,fs);
% 
% % % Testing data
% feat_unfilt_test = extractFeatures_Method3(acc_unfilt_test,fs);
% % feat_filt_test = extractFeatures_Method3(acc_filt_test,fs);
% 
% % Save un-normalized features
% save(strcat(featuresPath,'\feat_unfilt_train_unNorm.mat'),'feat_unfilt_train')
% % save(strcat(featuresPath,'\feat_filt_train_unNorm.mat'),'feat_filt_train')
% save(strcat(featuresPath,'\feat_unfilt_test_unNorm.mat'),'feat_unfilt_test')
% % save(strcat(featuresPath,'\feat_filt_test_unNorm.mat'),'feat_filt_test')


%% Feature Normalization
% Normalize features according to training data

% Unfiltered data
feat_unfilt_train_Norm = normalizeFeatures(feat_unfilt_train);
feat_unfilt_test_Norm = normalizeFeatures(feat_unfilt_test);

% Filtered data
% feat_filt_train_Norm = normalizeFeatures(feat_filt_train);
% feat_filt_test_Norm = normalizeFeatures(feat_filt_test);
   
% Save normalized features
save(strcat(featuresPath,'\feat_unfilt_train_Norm.mat'),'feat_unfilt_train_Norm')
% save(strcat(featuresPath,'\feat_filt_train_Norm.mat'),'feat_filt_train_Norm')
save(strcat(featuresPath,'\feat_unfilt_test_Norm.mat'),'feat_unfilt_test_Norm')
% save(strcat(featuresPath,'\feat_filt_test_Norm.mat'),'feat_filt_test_Norm')
toc