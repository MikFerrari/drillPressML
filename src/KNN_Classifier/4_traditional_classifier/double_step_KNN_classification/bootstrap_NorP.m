function simulatedData = bootstrap_NorP(data,nsims)
        
    nboot = round(height(data)/10);
    bootstat = bootstrp(nboot,@(x)[mean(x) std(x)],table2array(data(:,1:end-2)));
    mu = mean(bootstat(:,1:2:end-1),1);
    sigma = std(bootstat(:,2:2:end),1);
    
    simulatedData = zeros(nsims,length(mu));
    for i = 1:nsims
        simulatedData(i,:) = normrnd(mu,sigma);
    end
    
    simulatedData = array2table(simulatedData);
    
    simulatedData.Properties.VariableNames = data.Properties.VariableNames(1:end-2);
    velocity = repmat(data(1,end-1),height(simulatedData),1);
    loadLabel = repmat(data(1,end),height(simulatedData),1);
    simulatedData = [simulatedData velocity loadLabel];
    
%     figure
%     scatter(data.std_ax,data.std_az);
%     hold on
%     scatter(simulatedData.std_ax,simulatedData.std_az);
    
end