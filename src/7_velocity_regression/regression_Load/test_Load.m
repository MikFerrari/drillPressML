function [accuracy] = test_Load(Mtest,Vtest,trainedModel)
yfit=trainedModel.predictFcn(Mtest);
accuracy=calcolo_accuracy(yfit,Vtest);
figure
set(0,'defaultAxesFontSize',12)
plot(yfit,'g')
grid on
hold on
plot(Vtest,'k','MarkerSize',10)
legend('predetta','effettiva','Location','northwest')
title(['Regressione velocità sotto carico - ',accuracy])
xlabel('Campioni')
ylabel('Velocità [RPM]')
xlim([0 numel(Vtest)])
exportgraphics(gcf,'regression_Load.pdf')
end

