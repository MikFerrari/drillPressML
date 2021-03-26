function result = simulateTest_1step(data,Ys,netNP)
    
%     pred_vel = trainedModel.predictFcn(data);
    pred_vel = cellstr(classify(netNP,data))';
    dataT=array2table(data');
    velocity=cellstr(Ys);
    test_results = addvars(dataT,velocity,pred_vel);
    test_results = sortrows(test_results,'velocity');
    
    result = table(test_results.velocity,test_results.pred_vel);
    result.Properties.VariableNames = {'actual','predicted'};
    
end

