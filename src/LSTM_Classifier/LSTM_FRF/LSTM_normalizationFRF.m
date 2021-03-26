mu = mean(XTrain3,2);
sg = std(XTrain3,[],2);

XTrain2SD = XTrain2;
XTrain2SD = cellfun(@(x)(x-mu)./sg,XTrain2SD,'UniformOutput',false);

XTest2SD = XTest2;
XTest2SD = cellfun(@(x)(x-mu)./sg,XTest2SD,'UniformOutput',false);

XTrain3SD=(XTrain3-mu)./sg;
XTest3SD=(XTest3-mu)./sg;
YTrain3=YTrain2';
YTest3=YTest2';