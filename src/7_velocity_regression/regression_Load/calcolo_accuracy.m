function [message] = calcolo_accuracy(yfit,Vtest)
n=length(Vtest);
cont=0;
for i=1:n
    if yfit(i)>(Vtest(i)-0.1) && yfit(i)<(Vtest(i)+0.1)
        cont=cont+1;
    end
end
Rsq1=1 - sum((Vtest - yfit).^2)/sum((Vtest - mean(Vtest)).^2);
%accuracy=cont/n;
%RMSE=sqrt(mean((yfit-Vtest).^2));
message=sprintf('R^2 = %.2f',Rsq1);
end

% Rsq1 = 1 - sum((Vtest - yfit).^2)/sum((Vtest - mean(Vtest)).^2)