function [output,filteredOutput] = preprocessData( ...
                vars,varNames,selectedColumns,rowSubmul,fs_filter,labelMap)

    % Loop through the entire dataset
    output = {};
    filteredOutput = {};
    
    % Crop timetables
    for i = 1:size(vars,1)
        
        if mod(i,5) == 0
            minSize = min(cellfun(@(x) size(x,1),vars(i-4:i)));
            nSubs = floor(minSize/rowSubmul);
            for j = i-4:i
                vars{j} = vars{j}(1:nSubs*rowSubmul,selectedColumns);
            end
        end
        
    end
    
    % Filter data and add categorical labels
%     LPF = generateFilter;
    for i = 1:size(vars,1)
        
        currentTable = vars{i};
        
%         filtered = filter(LPF,currentTable.Variables);
%         filteredTable = currentTable;
%         filteredTable.Variables = filtered;

        % Filtering with moving average
        filteredTable = smoothdata(currentTable,'movmean',seconds(1/fs_filter));
        
%         Only No Load operations
%         lbl = labelMap.labelValue(labelMap.labelNum == str2double(varNames{i}(end)));
        
        % Load and No-load operations
        if contains(varNames{i},'_N_')
            lbl = labelMap.labelValueN(labelMap.labelNum == str2double(varNames{i}(end)));
        elseif contains(varNames{i},'_P_')
            lbl = labelMap.labelValueP(labelMap.labelNum == str2double(varNames{i}(end)));
        end
        
        label = repmat(lbl,size(currentTable,1),1);
        currentTable = addvars(currentTable,label);
        output{end+1} = currentTable;
        
        label = repmat(lbl,size(filteredTable,1),1);
        filteredTable = addvars(filteredTable,label);
        filteredOutput{end+1} = filteredTable;
        
    end

    output = output';
    filteredOutput = filteredOutput';
    
end