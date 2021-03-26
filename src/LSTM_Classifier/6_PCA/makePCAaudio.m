function [Tsorted,coeff,latent,explained]=makePCAaudio(data,titolo)

[coeff,~,latent,~,explained] = pca(data');

for i=1:size(coeff,2)
    A(:,i)=abs(coeff(:,i)).*explained(i)/100;
end

S=sum(A,2);
S=S/sum(S)*100;
                                                       
features=["spectralCentroidX";"spectralCentroidY";"spectralCentroidZ";...
            "spectralCrestX"; "spectralCrestY"; "spectralCrestZ";...
            "spectralDecreaseX"; "spectralDecreaseY"; "spectralDecreaseZ";...
            "spectralEntropyX"; "spectralEntropyY"; "spectralEntropyZ";...
            "spectralFlatnessX"; "spectralFlatnessY"; "spectralFlatnessZ";...
            "spectralFluxX"; "spectralFluxY"; "spectralFluxZ";...
            "spectralKurtosisX"; "spectralKurtosisY"; "spectralKurtosisZ";...
            "spectralRolloffPointX"; "spectralRolloffPointY"; "spectralRolloffPointZ";...
            "spectralSkewnessX"; "spectralSkewnessY"; "spectralSkewnessZ";...
            "spectralSlopeX"; "spectralSlopeY"; "spectralSlopeZ"
            "spectralSpreadX"; "spectralSpreadY"; "spectralSpreadZ"];   
        
features=categorical(cellstr(features));
T=table(features,S);
Tsorted=sortrows(T,2,{'descend'});
%Plot dei risultati
T.features = reordercats(T.features,cellstr(T.features));
figure
bar(T.features,T.S)
ax=gca;
ax.TickLabelInterpreter='none';
title(titolo)