% DATA IMPORT

load folderPaths.mat

%% Import accelerations (accelerometers data)

% Select folder and import data from subfolders
mainFolder_acc = strcat(rawDataPath,'\accelerometers');

% Select folder to save variables and variable names in
savingPath_acc = importedDataPath;             
               
accDataset = scan_and_import(mainFolder_acc,savingPath_acc,'acceleration');

% Save accelerations
save(strcat(savingPath_acc,'\accTimetables.mat'),'-regexp','acc_\d{2}')
save(strcat(savingPath_acc,'\accDataset.mat'),'accDataset')


%% Import forces (load cell data)

% Select folder and import data from subfolders
mainFolder_force = strcat(rawDataPath,'\loadCell');

% Select folder to save variables and variable names in
savingPath_force = importedDataPath;               
               
forcesDataset = scan_and_import(mainFolder_force,savingPath_force,'force');

% Save forces and clear workspace
save(strcat(savingPath_force,'\forcesTimetables.mat'),'-regexp','force_\d{2}')
save(strcat(savingPath_force,'\forcesDataset.mat'),'forcesDataset')
clearvars