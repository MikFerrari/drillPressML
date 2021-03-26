% FEATURE EXTRACTION (no-Load)  → USE FILTERED DATA
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
names_acc_train = {'05_11_N','06_11_N','18_12am_N','18_12pm_N','20_11_N'};
names_acc_test = {'27_11_N'};
              
exclusions_train = {'05_11_N_5','06_11_N_5'};
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
% acc_unfilt_train = acc_train(:,1);
% acc_unfilt_test = acc_test(:,1);
acc_filt_train = acc_train(:,2);
acc_filt_test = acc_test(:,2);


%% Feature Selection and Extraction

% Set parameters for feature extraction algorithm
recordLength = 1;   % s
fs = 2000;          % Hz

% Training data
% feat_unfilt_train = table;
feat_filt_train = table;
for i = 1:length(acc_train)
%     feat_unfilt_train = [feat_unfilt_train; ...
%                          extrFeatFromBuffers_Audioread(acc_unfilt_train{i},recordLength,fs)];
    feat_filt_train = [feat_filt_train; ...
                       extrFeatFromBuffers_Audioread(acc_filt_train{i},recordLength,fs)];
end

% Testing data
% feat_unfilt_test = table;
feat_filt_test = table;
for i = 1:length(acc_test)
%     feat_unfilt_test = [feat_unfilt_test; ...
%                         extrFeatFromBuffers_Audioread(acc_unfilt_test{i},recordLength,fs)];
    feat_filt_test = [feat_filt_test; ...
                      extrFeatFromBuffers_Audioread(acc_filt_test{i},recordLength,fs)];
end


%% Feature Normalization
% Normalize features according to training data

% Unfiltered data
% feat_unfilt_train = normalizeFeatures(feat_unfilt_train);
% feat_unfilt_test = normalizeFeatures(feat_unfilt_test);

% Filtered data
feat_filt_train = normalizeFeatures(feat_filt_train);
feat_filt_test = normalizeFeatures(feat_filt_test);


%% BOOTSTRAPPING (Filtered Data)
 
load labelMap

for i = 1:length(labelMap.labelValueN)
    
    % Train
    features_selected = feat_filt_train(feat_filt_train.velocity == labelMap.labelValueN(i),:);
    
    nsims = 4*height(features_selected);
    
    features_simulated = bootstrap(features_selected,nsims);
    feat_filt_train= [feat_filt_train; features_simulated];
    
    % Test
    features_selected = feat_filt_test(feat_filt_test.velocity == labelMap.labelValueN(i),:);
    
    nsims = 4*height(features_selected);
    
    features_simulated = bootstrap(features_selected,nsims);
    feat_filt_test = [feat_filt_test; features_simulated];
    
end


%% Save normalized features

% save(strcat(featuresPath,'\feat_unfilt_train.mat'),'feat_unfilt_train')
save(strcat(featuresPath,'\feat_filt_train.mat'),'feat_filt_train')
% save(strcat(featuresPath,'\feat_unfilt_test.mat'),'feat_unfilt_test')
save(strcat(featuresPath,'\feat_filt_test.mat'),'feat_filt_test')

toc