function cellDataset = scan_and_import(dataFolder,namesFolder,type)
%SCAN_AND_IMPORT Import data from all subfolders 
%   SCAN_AND_IMPORT(DATAFOLDER,TYPE) Import data from all subfolders
%   of DATAFOLDER. TYPE allows to select proper code for importing
%   different physical quantities:
%   --> 'acceleration' for importing accelerations
%   --> 'force' for importing forces

    % Main folder
    folder = dataFolder;

    % Get list of all subfolders.
    allSubFolders = genpath(folder);

    % Parse into a cell array.
    remain = allSubFolders; 
    
    % Save names of the timetables;
    timetableNames = {};
    
    % Save timetables in a single cell array
    cellDataset = {};
    
    % While there are still subfolder to be parsed, continue the import
    while true

        % Get the name of the current subfolder containing the files
        % to import data from
        [singleSubFolder,remain] = strtok(remain,';');

        if isempty(singleSubFolder)
            break;
        end

        % Change according to subfolder names containing files to import
        % regexp --> check if string ends with \ + any number of digits
        if isempty(regexp(singleSubFolder,"\\\d+$",'once'))
            continue;
        end

        % Get all files in the selected subfolder
        files = dir(singleSubFolder);
        files = files([files.isdir]==0);
        files = files(~strcmp({files.name},'desktop.ini'));

        % Get name of files and manipulate strings that will become the header
        % of the timetables (name of the variable)
        filenames = strcat(extractfield(files,'folder'),'\',extractfield(files,'name'))';
        
        if strcmp(type,'acceleration')
            full_titles = split(filenames,'accelerometers\');
        elseif strcmp(type,'force')
            full_titles = split(filenames,'loadCell\');    
        end
        
        % Allows import even if a folder contains a single file
        if size(full_titles,2) == 1
            titles = full_titles{2,:};
        else
            titles = full_titles(:,2);
        end
        
        titles = erase(titles,".txt");
        titles = replace(titles,'\','_');
        titles = replace(titles," ",'_');
        titles = replace(titles,'.','_');
        
        if strcmp(type,'acceleration')
            titles = strcat('acc_',titles);
        elseif strcmp(type,'force')
            titles = strcat('force_',titles);    
        end
        
        % Import data, change the name of the timetable and save it
        for i = 1:size(filenames,1)

            if strcmp(type,'acceleration')
                new_data = import_accelerations(char(filenames(i)));
            elseif strcmp(type,'force')
                new_data = import_force_multichannel(char(filenames(i)));
            end
            
            % Allows import even if a folder contains a single file
            if size(full_titles,2) == 1
                assignin('base',titles,new_data);
                timetableNames = [timetableNames; titles];
                cellDataset{end+1} = new_data;
            else
                assignin('base',char(titles(i)),new_data);
                timetableNames = [timetableNames; char(titles(i))];
                cellDataset{end+1} = new_data;
            end
                
        end

    end
    
    if strcmp(type,'acceleration')
        accTimetableNames = timetableNames;
        
        % Determine loadFlags
        uppers = isstrprop(accTimetableNames,'upper');
        loadFlags = cell(size(accTimetableNames));
        for i = 1:size(loadFlags,1)
            loadFlags{i} = accTimetableNames{i}(uppers{i});
            loadFlags{i} = loadFlags{i}(1);
        end

        save(strcat(namesFolder,'\accTimetableNames'),'accTimetableNames');
        save(strcat(namesFolder,'\loadFlags'),'loadFlags');
        
    elseif strcmp(type,'force')
        forceTimetableNames = timetableNames;
        save(strcat(namesFolder,'\forceTimetableNames'),'forceTimetableNames');
    end
    
    cellDataset = cellDataset';
    
end

