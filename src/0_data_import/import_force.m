function force = import_force(filename, dataLines)
    %IMPORT_FORCE Import force from a text file
    %  FORCE = IMPORT_FORCE(FILENAME, DATALINES) reads data from text file FILENAME
    %  for the selection specified by DATALINES.  Returns the data as a table.

    %% Input handling

    % If dataLines is not specified, define defaults
    if nargin < 2
        dataLines = [6, Inf];
    end

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 2);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = "\t";

    % Specify column names and types
    opts.VariableNames = ["time", "force"];
    opts.VariableTypes = ["datetime", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, "time", "InputFormat", "dd/MM/yyyy HH:mm:ss,SSSSSS");
    opts = setvaropts(opts, "force", "TrimNonNumeric", true);
    opts = setvaropts(opts, "force", "DecimalSeparator", ",");
    opts = setvaropts(opts, "force", "ThousandsSeparator", ".");

    % Import the data
    force = readtable(filename, opts);
    force = fillmissing(force,'linear');

    % Convert to timetable and adjust time vector
    force = table2timetable(force);
    force.time = force.time - force.time(1);
    force.time.Format = 'mm:ss.SSSS';
    
end