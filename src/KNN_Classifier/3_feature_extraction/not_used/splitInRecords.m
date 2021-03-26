function records = splitInRecords(data,recordLength)

    recordLength = seconds(recordLength);
    records = {};
    for i = 1:length(data)
        currentTable = data{i};
        ti = currentTable.time(1);
        tf = currentTable.time(end);
        t = (ti:recordLength:tf)';
        
        for j = 2:length(t)
            records{end+1} = currentTable(currentTable.time > t(j-1) & currentTable.time < t(j),:);
        end
    end

    records = records';
    
end

