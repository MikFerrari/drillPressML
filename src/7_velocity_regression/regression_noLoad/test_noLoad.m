function [accuracy] = test_noLoad(Mtest,Vtest,trainedModel)
yfit=trainedModel.predictFcn(Mtest);
accuracy=calcolo_accuracy(yfit,Vtest);
figure
set(0,'defaultAxesFontSize',12)
plot(yfit,'g')
hold on
plot(Vtest,'k','MarkerSize',10)
grid on
legend('predetta','effettiva','Location','northwest')
title(['Regressione velocità a vuoto - ',accuracy])
xlabel('Campioni')
ylabel('Velocità [RPM]')
xlim([0 numel(Vtest)])
exportgraphics(gcf,'regression_noLoad.pdf')
end

