function result = simulateTest_2steps(data,modelNorP,modelN,modelP)
    
    pred_Load = modelNorP.predictFcn(data);
    data = addvars(data,pred_Load);
    data = sortrows(data,'loadLabel');
    
    data_pred_N = data(data.pred_Load == 'N',:);
    data_pred_N = data_pred_N(:,1:end-2);
    data_pred_P = data(data.pred_Load == 'P',:);
    data_pred_P = data_pred_P(:,1:end-2);
    
    pred_vel_N = modelN.predictFcn(data_pred_N);
    data_final_N = addvars(data_pred_N,pred_vel_N);
    data_final_N = sortrows(data_final_N,'pred_vel_N');
    data_final_N.Properties.VariableNames(end) = {'pred_vel'};
    
    pred_vel_P = modelP.predictFcn(data_pred_P);
    data_final_P = addvars(data_pred_P,pred_vel_P);
    data_final_P = sortrows(data_final_P,'pred_vel_P');
    data_final_P.Properties.VariableNames(end) = {'pred_vel'};
    
    test_results = [data_final_N; data_final_P];
    test_results = sortrows(test_results,'velocity');
    
    result = table(test_results.velocity,test_results.pred_vel);
    result.Properties.VariableNames = {'actual','predicted'};
    
end

