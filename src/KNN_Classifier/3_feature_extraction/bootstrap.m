function simulatedData = bootstrap(data,nsims)
        
    nboot = round(height(data)/10);
    bootstat = bootstrp(nboot,@(x)[mean(x) std(x)],table2array(data(:,1:end-1)));
    mu = mean(bootstat(:,1:2:end-1),1,'omitnan');
    sigma = mean(abs(bootstat(:,2:2:end)),1,'omitnan');
    
    simulatedData = zeros(nsims,length(mu));
    for i = 1:nsims
        simulatedData(i,:) = normrnd(mu,sigma/20); % Divide by 20 to increase data clusterization
    end
    
    simulatedData = array2table(simulatedData);
    
    simulatedData.Properties.VariableNames = data.Properties.VariableNames(1:end-1);
    velocity = repmat(data(1,end),height(simulatedData),1);
    simulatedData = [simulatedData velocity];
    
%     figure
%     scatter(data.std_ax,data.std_az);
%     hold on
%     scatter(simulatedData.std_ax,simulatedData.std_az);
    
end