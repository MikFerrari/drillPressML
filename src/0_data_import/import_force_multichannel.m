function force = import_force_multichannel(filename, dataLines)
    %IMPORT_FORCE Import force from a text file
    %  FORCE = IMPORT_FORCE(FILENAME, DATALINES) reads data from text file FILENAME
    %  for the selection specified by DATALINES.  Returns the data as a table.

    %% Input handling

    % If dataLines is not specified, define defaults
    if nargin < 2
        dataLines = [6, Inf];
    end

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 3);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = "\t";

    % Specify column names and types
    opts.VariableNames = ["time", "channel_1", "channel_2"];
    opts.SelectedVariableNames = ["time", "channel_1", "channel_2"];
    opts.VariableTypes = ["datetime", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, "time", "InputFormat", "dd/MM/yyyy HH:mm:ss,SSSSSS");
    opts = setvaropts(opts, ["channel_1", "channel_2"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["channel_1", "channel_2"], "DecimalSeparator", ",");
    opts = setvaropts(opts, ["channel_1", "channel_2"], "ThousandsSeparator", ".");

    % Import the data
    force = readtable(filename, opts);
    force = fillmissing(force,'linear');

    % Choose the correct channel
    % One of the 2 channels presents an oscillating trend and does not
    % carry useful information
    if abs(max(force.channel_1)-min(force.channel_1)) > ...
       abs(max(force.channel_2)-min(force.channel_2))
        force = removevars(force,'channel_1');
    else
        force = removevars(force,'channel_2');
    end
    force.Properties.VariableNames = {'time','force'};
    
    % Convert to timetable and adjust time vector
    force = table2timetable(force);
    force.time = force.time - force.time(1);
    force.time.Format = 'mm:ss.SSSS';

end