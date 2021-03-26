% FORCE ESTIMATION

clearvars
load folderPaths.mat


%% Load Preprocessed Filtered and Filtered Data

load forcesUnfilteredDataset.mat
load forcesFilteredDataset.mat
load forceTimetableNames.mat

load accUnfilteredDataset.mat
load accFilteredDataset.mat
load accTimetableNames.mat


%% Dataset Selection

forces = [forcesUnfilteredDataset forcesFilteredDataset forceTimetableNames];

names_forces = {'23_12_P','15_01_P'};
exclusions = {};

idx = [];
for i = 1:length(forceTimetableNames)
    if containsStrings(forceTimetableNames{i},names_forces,exclusions)
        idx = [idx i];
    end
end

forces_selected = forces(idx,:);

forces_unfilt = forces_selected(:,1);
forces_filt = forces_selected(:,2);


%% Mean calculation over subintervals to obtain the steady-state mean force

pts_forces_unfilt = cellfun(@(x) findchangepts(x.force,'MaxNumChanges',3),forces_unfilt,'UniformOutput',false);
pts_forces_filt = cellfun(@(x) findchangepts(x.force,'MaxNumChanges',3),forces_filt,'UniformOutput',false);

% Unfiltered
chunks_unfilt = cell(length(forces_unfilt),1);
means_unfilt = cell(length(forces_unfilt),1);
mean_force_unfilt = cell(length(forces_unfilt),1);

for i = 1:length(forces_unfilt)
    
    currentPts = pts_forces_unfilt{i};
    currentTable = forces_unfilt{i};
    out = {};
    out{end+1} = currentTable(1:currentPts(1),:);
    for j = 2:length(currentPts)
        out{end+1} = currentTable(currentPts(j-1):currentPts(j),:);
    end
    out{end+1} = currentTable(currentPts(end):end,:);
    
    chunks_unfilt{i} = out;
    means_unfilt{i} = cell2mat(cellfun(@(x) mean(x.force),chunks_unfilt{i},'UniformOutput',false));
    means_unfilt{i} = sort(means_unfilt{i});
    mean_force_unfilt{i} = mean(means_unfilt{i}(end-1:end));
    
end

force_values_unfilt_idx = cell2mat( ...
                          [cellfun(@(x) contains(x,'V1'),forceTimetableNames,'UniformOutput',false)'; ...
                           cellfun(@(x) contains(x,'V2'),forceTimetableNames,'UniformOutput',false)'; ...
                           cellfun(@(x) contains(x,'V3'),forceTimetableNames,'UniformOutput',false)'; ...
                           cellfun(@(x) contains(x,'V4'),forceTimetableNames,'UniformOutput',false)'; ...
                           cellfun(@(x) contains(x,'V5'),forceTimetableNames,'UniformOutput',false)'; ...
                          ]);
                      
force_values_unfilt = [mean(cell2mat(mean_force_unfilt(force_values_unfilt_idx(1,:)))); ...
                       mean(cell2mat(mean_force_unfilt(force_values_unfilt_idx(2,:)))); ...
                       mean(cell2mat(mean_force_unfilt(force_values_unfilt_idx(3,:)))); ...
                       mean(cell2mat(mean_force_unfilt(force_values_unfilt_idx(4,:)))); ...
                       mean(cell2mat(mean_force_unfilt(force_values_unfilt_idx(5,:)))); ...
                      ];
                  
                  
% Filtered
chunks_filt = cell(length(forces_filt),1);
means_filt = cell(length(forces_filt),1);
mean_force_filt = cell(length(forces_filt),1);

for i = 1:length(forces_filt)
    
    currentPts = pts_forces_filt{i};
    currentTable = forces_filt{i};
    out = {};
    out{end+1} = currentTable(1:currentPts(1),:);
    for j = 2:length(currentPts)
        out{end+1} = currentTable(currentPts(j-1):currentPts(j),:);
    end
    out{end+1} = currentTable(currentPts(end):end,:);
    
    chunks_filt{i} = out;
    means_filt{i} = cell2mat(cellfun(@(x) mean(x.force),chunks_filt{i},'UniformOutput',false));
    means_filt{i} = sort(means_filt{i});
    mean_force_filt{i} = mean(means_filt{i}(end-1:end));
    
end
                      
force_values_filt = [mean(cell2mat(mean_force_filt(force_values_unfilt_idx(1,:)))); ...
                     mean(cell2mat(mean_force_filt(force_values_unfilt_idx(2,:)))); ...
                     mean(cell2mat(mean_force_filt(force_values_unfilt_idx(3,:)))); ...
                     mean(cell2mat(mean_force_filt(force_values_unfilt_idx(4,:)))); ...
                     mean(cell2mat(mean_force_filt(force_values_unfilt_idx(5,:)))); ...
                    ];


forces_meanForces = [forces_unfilt mean_force_unfilt ...
                     forces_filt mean_force_filt forceTimetableNames(idx)];
 

% Save mean forces data
save(strcat(processedDataPath,'\forces_meanForces.mat'),'forces_meanForces');
save(strcat(processedDataPath,'\mean_force_unfilt.mat'),'mean_force_unfilt');
save(strcat(processedDataPath,'\mean_force_filt.mat'),'mean_force_filt');
save(strcat(processedDataPath,'\force_values_unfilt.mat'),'force_values_unfilt');
save(strcat(processedDataPath,'\force_values_filt.mat'),'force_values_filt');     


%% Concatenate mean forces to feature tables and velocity labels

% Load features tables

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


% Concatenation
idx = char(feat_unfilt_train.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_unfilt_train_force = addvars(feat_unfilt_train,force_label);

idx = char(feat_unfilt_test.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_unfilt_test_force = addvars(feat_unfilt_test,force_label);

idx = char(feat_filt_train.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_filt_train_force = addvars(feat_filt_train,force_label);

idx = char(feat_filt_test.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_filt_test_force = addvars(feat_filt_test,force_label);

idx = char(feat_unfilt_train_Norm.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_unfilt_train_Norm_force = addvars(feat_unfilt_train_Norm,force_label);

idx = char(feat_unfilt_test_Norm.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_unfilt_test_Norm_force = addvars(feat_unfilt_test_Norm,force_label);

idx = char(feat_filt_train_Norm.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_filt_train_Norm_force = addvars(feat_filt_train_Norm,force_label);

idx = char(feat_filt_test_Norm.velocity);
idx = str2num(idx(:,2)); %#ok<ST2NM>
force_label = force_values_unfilt(idx);
feat_filt_test_Norm_force = addvars(feat_filt_test_Norm,force_label);


% Save complete feature tables

% Un-normalized
save(strcat(featuresPath,'\feat_unfilt_train_unNorm_force.mat'),'feat_unfilt_train_force');
save(strcat(featuresPath,'\feat_unfilt_test_unNorm_force.mat'),'feat_unfilt_test_force');
save(strcat(featuresPath,'\feat_filt_train_unNorm_force.mat'),'feat_filt_train_force');
save(strcat(featuresPath,'\feat_filt_test_unNorm_force.mat'),'feat_filt_test_force');

% Normalized
save(strcat(featuresPath,'\feat_unfilt_train_Norm_force.mat'),'feat_unfilt_train_Norm_force');
save(strcat(featuresPath,'\feat_unfilt_test_Norm_force.mat'),'feat_unfilt_test_Norm_force');
save(strcat(featuresPath,'\feat_filt_train_Norm_force.mat'),'feat_filt_train_Norm_force');
save(strcat(featuresPath,'\feat_filt_test_Norm_force.mat'),'feat_filt_test_Norm_force');