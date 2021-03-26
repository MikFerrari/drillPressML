function result = simulateTest_1step(data,trainedModel)
    
    pred_vel = trainedModel.predictFcn(data);
    
    test_results = addvars(data,pred_vel);
    test_results = sortrows(test_results,'velocity');
    
    result = table(test_results.velocity,test_results.pred_vel);
    result.Properties.VariableNames = {'actual','predicted'};
    
end

