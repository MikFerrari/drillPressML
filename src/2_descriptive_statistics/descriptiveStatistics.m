% DESCRIPTIVE STATISTICS
% Run after |dataPreprocessing.m|

clearvars
load folderPaths.mat
load accTimetableNames.mat
load forceTimetableNames.mat

%% Load Preprocessed Data

load accUnfilteredDataset.mat
load accFilteredDataset.mat
load forcesUnfilteredDataset.mat
load forcesFilteredDataset.mat


%% Useful graphical properties for plots and sampling frequency

colors = {[0, 0.4470, 0.7410],[0.8500, 0.3250, 0.0980], ...
          [0.9290, 0.6940, 0.1250],[0.4940, 0.1840, 0.5560], ...
          [0.4660, 0.6740, 0.1880]};
titles = {'V1: 560 RPM','V2: 780 RPM','V3: 1200 RPM','V4: 1900 RPM', ...
          'V5: 3000 RPM'};

fs = 2000;          % Hz
fs_downsmpl = 110;  % Hz
      
%% Time-Domain Preliminary Analysis - Accelerations
% PLOT, HISTOGRAM

accs = {'ax_top','ay_top','az_top','ax_base','ay_base','az_base'};

% No load operation, Unfiltered
selection = 'acc_18_12am_N_2';
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accUnfilteredDataset(idx);

for i = 1:size(accs,2)
    plotTimeSeries(varsSubset,colors,titles,selection,accs{i},'unfilt',plotsPath);
    histTimeSeries(varsSubset,colors,titles,selection,accs{i},'unfilt',plotsPath);
end

% No load operation, Filtered
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accFilteredDataset(idx);

for i = 1:size(accs,2)
    plotTimeSeries(varsSubset,colors,titles,selection,accs{i},'filt',plotsPath);
    histTimeSeries(varsSubset,colors,titles,selection,accs{i},'filt',plotsPath);
end

% Load operation, Unfiltered
selection = 'acc_18_12am_P_2';
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accUnfilteredDataset(idx);

for i = 1:size(accs,2)
    plotTimeSeries(varsSubset,colors,titles,selection,accs{i},'unfilt',plotsPath);
    histTimeSeries(varsSubset,colors,titles,selection,accs{i},'unfilt',plotsPath);
end

% Load operation, Filtered
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accFilteredDataset(idx);

for i = 1:size(accs,2)
    plotTimeSeries(varsSubset,colors,titles,selection,accs{i},'filt',plotsPath);
    histTimeSeries(varsSubset,colors,titles,selection,accs{i},'filt',plotsPath);
end


%% Frequency-Domain Analysis - Accelerations
% FFT, FFT - mean(FFT), PSD, PSD - mean(PSD), SPECTROGRAM

accs = {'ax_top','ay_top','az_top','ax_base','ay_base','az_base'};

% No load operation, Unfiltered
selection = 'acc_18_12am_N_2';
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accUnfilteredDataset(idx);

for i = 1:size(accs,2)
    psdTimeSeries(varsSubset,colors,titles,selection,accs{i},fs,'unfilt',plotsPath);
    fftTimeSeries(varsSubset,colors,titles,selection,accs{i},fs,'unfilt',plotsPath);
    timeFreqAnalysis(varsSubset,colors,titles,selection,accs{i},fs,'unfilt','noload',plotsPath);
end

% No load operation, Filtered
% --> Non-sense, carries no information: not enough data points!

% Load operation, Unfiltered
selection = 'acc_18_12am_P_2';
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accUnfilteredDataset(idx);

for i = 1:size(accs,2)
    psdTimeSeries(varsSubset,colors,titles,selection,accs{i},fs,'unfilt',plotsPath);
    fftTimeSeries(varsSubset,colors,titles,selection,accs{i},fs,'unfilt',plotsPath);
    timeFreqAnalysis(varsSubset,colors,titles,selection,accs{i},fs,'unfilt','load',plotsPath);
end

% Load operation, Filtered
% --> Non-sense, carries no information: not enough data points!


%% Frequency-Domain Analysis - Accelerations
% FRF BASE - TOP

accs = {'ax_base','ay_base','az_base','ax_top','ay_top','az_top'};

% No load operation, Unfiltered
selection = 'acc_18_12am_N_2';
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accUnfilteredDataset(idx);

frfTopBase(varsSubset,titles,selection,accs,fs,'unfilt',plotsPath);

% No load operation, Filtered --> Non-sense, carries no information: too
%                                    little data points!
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accFilteredDataset(idx);

frfTopBase(varsSubset,titles,selection,accs,fs_downsmpl,'filt',plotsPath);

% Load operation, Unfiltered
selection = 'acc_18_12am_P_2';
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accUnfilteredDataset(idx);

frfTopBase(varsSubset,titles,selection,accs,fs,'unfilt',plotsPath);
    
% Load operation, Filtered --> Non-sense, carries no information: too
%                                 little data points!
idx = cell2mat(cellfun(@(x) contains(x,selection),accTimetableNames,'UniformOutput',false));
varsSubset = accFilteredDataset(idx);

frfTopBase(varsSubset,titles,selection,accs,fs_downsmpl,'filt',plotsPath);


%% Time-Domain and Frequency-Domain Analysis - Forces
% PLOT, HISTOGRAM, SPECTROGRAM

selection = 'force_15_01_P_3';

% Unfiltered
idx = cell2mat(cellfun(@(x) contains(x,selection),forceTimetableNames,'UniformOutput',false));
varsSubset = forcesUnfilteredDataset(idx);

plotTimeSeries(varsSubset,colors,titles,selection,[],'unfilt',plotsPath);
histTimeSeries(varsSubset,colors,titles,selection,[],'unfilt',plotsPath);
timeFreqAnalysis(varsSubset,colors,titles,selection,[],fs,'unfilt',[],plotsPath);

% Filtered
idx = cell2mat(cellfun(@(x) contains(x,selection),forceTimetableNames,'UniformOutput',false));
varsSubset = forcesFilteredDataset(idx);

plotTimeSeries(varsSubset,colors,titles,selection,[],'filt',plotsPath);
histTimeSeries(varsSubset,colors,titles,selection,[],'filt',plotsPath);
timeFreqAnalysis(varsSubset,colors,titles,selection,[],fs_downsmpl,'filt',[],plotsPath);