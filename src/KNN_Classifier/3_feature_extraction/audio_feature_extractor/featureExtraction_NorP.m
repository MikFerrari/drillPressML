% FEATURE EXTRACTION (Load and no-Load) → USE FILTERED DATA
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
% |Load and No-load operations|
% N
names_acc_trainN = {'05_11_N','06_11_N','18_12am_N','18_12pm_N','20_11_N'};
names_acc_testN = {'27_11_N'};
              
exclusions_trainN = {'05_11_N_5','06_11_N_5'};
exclusions_testN = {};

% P
names_acc_trainP = {'15_01_P','18_12am_P','20_11_P','23_12_P'};
names_acc_testP = {'27_11_P'};
              
exclusions_trainP = {'15_01_P_5','18_12am_P_3','18_12am_P_4','18_12am_P_5','20_11_P_5'};
exclusions_testP = {'27_11_P_5'};

% NP
names_acc_train = {names_acc_trainN,names_acc_trainP};
names_acc_test = {names_acc_testN,names_acc_testP};
              
exclusions_train = {exclusions_trainN,exclusions_trainP};
exclusions_test = {exclusions_testN,exclusions_testP};


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
%                          extrFeatFromBuffers_NorP(acc_unfilt_train{i},recordLength,fs)];
    feat_filt_train = [feat_filt_train; ...
                       extrFeatFromBuffers_NorP(acc_filt_train{i},recordLength,fs)];
end

% Testing data
% feat_unfilt_test = table;
feat_filt_test = table;
for i = 1:length(acc_test)
%     feat_unfilt_test = [feat_unfilt_test; ...
%                         extrFeatFromBuffers_NorP(acc_unfilt_test{i},recordLength,fs)];
    feat_filt_test = [feat_filt_test; ...
                      extrFeatFromBuffers_NorP(acc_filt_test{i},recordLength,fs)];
end


%% Feature Normalization
% Normalize features according to training data

% Unfiltered data
% feat_unfilt_train = normalizeFeatures(feat_unfilt_train);
% feat_unfilt_test = normalizeFeatures(feat_unfilt_test);

% Filtered data
feat_filt_train = normalizeFeatures_NorP(feat_filt_train);
feat_filt_test = normalizeFeatures_NorP(feat_filt_test);


%% BOOTSTRAPPING (Filtered Data)

load labelMap
labels = [labelMap.labelValueN; labelMap.labelValueP];

for i = 1:length(labelMap.labelValueP)
    
    % Train
    features_selected = feat_filt_train(feat_filt_train.velocity == labelMap.labelValueP(i),:);
    
    numN = size(feat_filt_train(feat_filt_train.velocity == labelMap.labelValueN(i),:),1);
    numP = size(feat_filt_train(feat_filt_train.velocity == labelMap.labelValueP(i),:),1);
    nsims = numN-numP;
    
    features_simulated = bootstrap_NorP(features_selected,nsims);
    feat_filt_train= [feat_filt_train; features_simulated];
    
    % Test
    features_selected = feat_filt_test(feat_filt_test.velocity == labelMap.labelValueP(i),:);
    
    numN = size(feat_filt_test(feat_filt_test.velocity == labelMap.labelValueN(i),:),1);
    numP = size(feat_filt_test(feat_filt_test.velocity == labelMap.labelValueP(i),:),1);
    nsims = numN-numP;
    
    features_simulated = bootstrap_NorP(features_selected,nsims);
    feat_filt_test = [feat_filt_test; features_simulated];
    
end


%% Save normalized features

% save(strcat(featuresPath,'\feat_unfilt_train.mat'),'feat_unfilt_train')
save(strcat(featuresPath,'\feat_filt_train.mat'),'feat_filt_train')
% save(strcat(featuresPath,'\feat_unfilt_test.mat'),'feat_unfilt_test')
save(strcat(featuresPath,'\feat_filt_test.mat'),'feat_filt_test')

toc