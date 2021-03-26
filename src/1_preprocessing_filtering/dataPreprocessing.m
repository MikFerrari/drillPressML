% DATA PREPROCESSING AND FILTERING
% Run after |dataImport.m|

clearvars
load folderPaths.mat
load labelMap.mat

%% Load Imported Data

load accTimetables.mat
load forcesTimetables.mat
load accDataset.mat
load forcesDataset.mat
load accTimetableNames.mat
load forceTimetableNames.mat


%% Data Pre-processing

% Filtering frequency
fs_filter = 60;  % Hz

% Crop tables to proper size and add Labels column
rowsSubmultiple_acc = 5000;     % Crop to sizes multiple of this number
selectedColumns = 1:6;          % Select all columns (x-y-z base and top)

[accUnfilteredDataset, accFilteredDataset] = preprocessData( ...
                    accDataset,accTimetableNames,selectedColumns, ...
                    rowsSubmultiple_acc,fs_filter,labelMap);

rowsSubmultiple_force = 1000;   % Crop to sizes multiple of this number
selectedColumns = 1;            % Just one column (vertical force)

[forcesUnfilteredDataset, forcesFilteredDataset] = preprocessData( ...
                    forcesDataset,forceTimetableNames,selectedColumns, ...
                    rowsSubmultiple_force,fs_filter,labelMap);
                        
                
%% Save preprocessed datasets

save(strcat(processedDataPath,'\accUnfilteredDataset.mat'), ...
     'accUnfilteredDataset')
save(strcat(processedDataPath,'\accFilteredDataset.mat'), ...
     'accFilteredDataset')
save(strcat(processedDataPath,'\forcesUnfilteredDataset.mat'), ...
     'forcesUnfilteredDataset')
save(strcat(processedDataPath,'\forcesFilteredDataset.mat'), ...
     'forcesFilteredDataset')