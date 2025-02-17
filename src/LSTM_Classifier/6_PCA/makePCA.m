function [Tsorted,coeff,latent,explained]=makePCA(data,FRFflag,titolo)

[coeff,~,latent,~,explained] = pca(data');

for i=1:size(coeff,2)
    A(:,i)=abs(coeff(:,i)).*explained(i)/100;
end

S=sum(A,2);
S=S/sum(S)*100;
if FRFflag == 1
    features=["mean_pwelchTrainX";"mean_pwelchTrainY";"mean_pwelchTrainZ";...
                                    "rms_pwelchTrainX"; "rms_pwelchTrainY"; "rms_pwelchTrainZ";...
                                    "std_pwelchTrainX"; "std_pwelchTrainY"; "std_pwelchTrainZ";...
                                    "mean_spectrumTrainX"; "mean_spectrumTrainY"; "mean_spectrumTrainZ";...
                                    "mean_frfTrainRX"; "mean_frfTrainRY"; "mean_frfTrainRZ";...
                                    "mean_frfTrainIX"; "mean_frfTrainIY"; "mean_frfTrainIZ";...
                                    "mean_frfTrainabsX"; "mean_frfTrainabsY"; "mean_frfTrainabsZ";...
                                    "maxTrainX"; "maxTrainY"; "maxTrainZ";...
                                    "stdTrainX"; "stdTrainY"; "stdTrainZ"];
elseif FRFflag == 0
    features=["mean_pwelchTrainX";"mean_pwelchTrainY";"mean_pwelchTrainZ";...
                                    "rms_pwelchTrainX"; "rms_pwelchTrainY"; "rms_pwelchTrainZ";...
                                    "std_pwelchTrainX"; "std_pwelchTrainY"; "std_pwelchTrainZ";...
                                    "mean_spectrumTrainX"; "mean_spectrumTrainY"; "mean_spectrumTrainZ";...
                                    "maxTrainX"; "maxTrainY"; "maxTrainZ";...
                                    "stdTrainX"; "stdTrainY"; "stdTrainZ"];                        
end                     

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