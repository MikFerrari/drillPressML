% STARTUP

clear
close all

proj = currentProject;
rootFolder = proj.RootFolder;


%% Create project folders name

rawDataPath = strcat(rootFolder,'\raw_data');
importedDataPath = strcat(rootFolder,'\imported_data');
processedDataPath = strcat(rootFolder,'\processed_data');
plotsPath = strcat(rootFolder,'\plots');
resultsPath = strcat(rootFolder,'\results');
featuresPath = strcat(rootFolder,'\features');
modelsPath = strcat(rootFolder,'\models');

save(strcat(rootFolder,'\folderPaths.mat'), ...
     'rawDataPath','importedDataPath','processedDataPath', ...
     'plotsPath','resultsPath','featuresPath','modelsPath')

 
%% Create Hash-Map (kind of) to map label keys to label names

% Only No Load operations
% labelMap = struct();
% labelMap.labelNum = (1:5)';
% labelMap.labelValue = categorical({'V1: 560 RPM','V2: 780 RPM','V3: 1200 RPM', ...
%                           'V4: 1900 RPM','V5: 3000 RPM'})';

% Load and No-load operations
labelMap = struct();
labelMap.labelNum = (1:5)';
labelMap.labelValueN = categorical({'V1_N: 560 RPM','V2_N: 780 RPM','V3_N: 1200 RPM', ...
                                    'V4_N: 1900 RPM','V5_N: 3000 RPM'})';
labelMap.labelValueP = categorical({'V1_P: 560 RPM','V2_P: 780 RPM','V3_P: 1200 RPM', ...
                                    'V4_P: 1900 RPM','V5_P: 3000 RPM'})';
                      
save(strcat(rootFolder,'\labelMap.mat'),'labelMap');

clearvars