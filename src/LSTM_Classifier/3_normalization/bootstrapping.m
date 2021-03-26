function [XTrain,YTrain]=bootstrapping(XTrain,YTrain,labels)
for i=1:size(labels)
    nboot=20;
    LP=labels(i); %per ciascuna etichetta (=classe)
    num=cellstr(LP); num=num{1}(2); 
    LN=categorical(cellstr(strcat('N',num)));
    numsims=size(YTrain(YTrain==LN),2)-size(YTrain(YTrain==LP),2);
    if numsims<0
        continue
    end

    X=XTrain(:,YTrain==LP)'; %estrapolo i sample della classe L
    bootstat=bootstrp(nboot,@(x)[mean(x) std(x)],X);
%     bootstat=mean(bootstat);
%     mu=bootstat(:,1:2:end-1);
%     sigma=bootstat(:,2:2:end);
    mu=mean(bootstat(:,1:2:end-1),1,'omitnan');
    sigma=mean(abs(bootstat(:,2:2:end)),1,'omitnan');
    
    simulatedData=zeros(numsims,length(mu));
    for i=1:1:numsims
        simulatedData(i,:)=normrnd(mu,abs(sigma));
    end
  
    %aggiungo i nuovi sample alla matrice finale
    XTrain=[XTrain simulatedData'];
    Y=categorical();
    Y(1:numsims)=categorical(LP); %replico le etichette di L
    YTrain=[YTrain Y];
end