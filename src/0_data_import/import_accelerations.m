function accelerations = import_accelerations(filename, dataLines)
    %IMPORT_ACCELERATIONS Import accelerations from a text file
    %  ACCELERATIONS = IMPORT_ACCELERATIONS(FILENAME, DATALINES) reads data from text file FILENAME
    %  for the selection specified by DATALINES.  Returns the data as a table.

    %% Input handling

    % If dataLines is not specified, define defaults
    if nargin < 2
        dataLines = [6, Inf];
    end

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 7);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = "\t";

    % Specify column names and types
    opts.VariableNames = ["time", "ax_base", "ay_base", "az_base", "ax_top", "ay_top", "az_top"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, "time", "InputFormat", "dd/MM/yyyy HH:mm:ss,SSSSSS");
    opts = setvaropts(opts, ["ax_base", "ay_base", "az_base", "ax_top", "ay_top", "az_top"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["ax_base", "ay_base", "az_base", "ax_top", "ay_top", "az_top"], "DecimalSeparator", ",");
    opts = setvaropts(opts, ["ax_base", "ay_base", "az_base", "ax_top", "ay_top", "az_top"], "ThousandsSeparator", ".");

    % Import the data
    accelerations = readtable(filename, opts);
    accelerations = fillmissing(accelerations,'linear');

    % Convert to timetable and adjust time vector and offset
    accelerations = table2timetable(accelerations);
    accelerations.Variables = accelerations.Variables - mean(accelerations.Variables);
    accelerations.time = accelerations.time - accelerations.time(1);
    accelerations.time.Format = 'mm:ss.SSSS';
    
end