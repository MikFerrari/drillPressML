%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Velocity Classification through Vibration Pattern Recognition %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% STARTUP OPERATIONS
% Before launching the script, make sure to activate the current
% project by double clicking on it (|DrillPress_machineLearning.prj|)
% in the "Current Folder" pane

tic

disp('- Starting up project...')
startupProject
toc


%% DATA IMPORT

disp('- Importing data...')
dataImport
toc


%% DATA PREPROCESSING

disp('- Preprocessing data...')
dataPreprocessing
toc


%% DESCRIPTIVE STATISTICS
% (Just to have a look at the data and to choose proper features)

% disp('- Producing and saving plots...')
% descriptiveStatistics
% toc


%% FEATURE EXTRACTION

% % Only no-Load data
% disp('- Extracting features from no-Load data...')
% featureExtraction_N
% % featureExtraction_N_manualFeat
% toc

% Only Load data
disp('- Extracting features from Load data...')
featureExtraction_P
% featureExtraction_P_manualFeat
toc

% % Load and no-Load data (single-step classification with mixed data)
% disp('- Extracting features from Load and no-Load data (single-step classification)...')
% % featureExtraction_NP
% featureExtraction_NP_manualFeat
% toc


%% TRADITIONAL (KNN) CLASSIFICATION

% % Only no-Load data
% disp('- Training classification model (KNN-algorithm) on no-Load data...')
% traditionalClassifier_N
% toc

% Only Load data
disp('- Training classification model (KNN-algorithm) on Load data...')
traditionalClassifier_P
toc

% % Load and no-Load data (single-step classification with mixed data)
% disp('- Training classification model (KNN-algorithm) on Load and no-Load data (single-step classification)...')
% traditionalClassifier_NP
% % traditionalClassifier_NP_unfilt
% toc


%% Alternative: DOUBLE-STEP CLASSIFICATION
% 1) Distinguish between N or P
% 2) Distinguish among the 5 possible velocity values

% doubleStep_KNNclassification
% toc


%% FEATURE IMPORTANCE (PCA-based Algorithm)

disp('- Computing feature relevance...')
featureRanking_PCA
toc


%% BOOTSTRAPPING FOR EVALUATING CLASSIFICATION ACCURACY

disp('- Evaluating overall accuracy through Bootstrapping...')
evalAccuracyBootstrap
toc


%% NEURAL NETWORK CLASSIFICATION
% 
% disp('- Training neural network for classification...')
% neuralNetClassifier
% toc


%% VELOCITY REGRESSION MODEL

% disp('- Training velocity regression model...')
% velocityRegression
% toc


%% FORCE ESTIMATION

disp('- Computing vertical force for classified velocity...')
forceEstimation
toc