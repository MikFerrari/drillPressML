%% FEATURE RANKING via a PCA-based Algorithm

load folderPaths
load feat_filt_train
loadFlag = 'NP';

[coeff,~,~,~,explained,~] = pca(table2array(feat_filt_train(:,1:end-1)));

% Not useful: coeff are already normalized, it is sufficient to take their
% absolute value
% normalized_coeff = zeros(size(coeff));
% for i = 1:size(coeff,1)
%     for j = 1:size(coeff,2)
%         normalized_coeff(i,j) = abs(coeff(i,j))/norm(coeff(:,j));
% 
%     end
% end

normalized_coeff = abs(coeff);

% How the single original component explain variance in the dataset
original_explained = normalized_coeff.*explained';
% Rows: original features
% Columns: principal components as computed by PCA

original_explained_total = sum(original_explained,2);
original_explained_percent = original_explained_total/sum(original_explained_total)*100;

feature_ranking = table(categorical(feat_filt_train.Properties.VariableNames(1:end-1)'),original_explained_percent);
feature_ranking.Properties.VariableNames = {'feature_name','variance_explained_percent'};
% feature_ranking = sortrows(feature_ranking,'variance_explained_percent','descend');
feature_ranking.feature_name = reordercats(feature_ranking.feature_name,cellstr(feature_ranking.feature_name));

figure('Visible','off')
bar(feature_ranking.feature_name,feature_ranking.variance_explained_percent)
ax = gca;
ax.TickLabelInterpreter = 'none';
title('Relevance of selected features before PCA')
xlabel('Feature name')
ylabel('Explained variance [%]')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\feature_ranking',loadFlag,'.fig'))

% Italian plot
figure('Visible','off')
set(0,'defaultAxesFontSize',12)
bar(feature_ranking.feature_name,feature_ranking.variance_explained_percent)
ax = gca;
ax.TickLabelInterpreter = 'none';
title('Rilevanza Features Estrattore Audio tramite PCA')
xlabel('Feature')
ylabel('Varianza Spiegata [%]')

set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
savefig(strcat(resultsPath,'\feature_ranking',loadFlag,'_ITA.fig'))
exportgraphics(gcf,strcat(resultsPath,'\feature_ranking',loadFlag,'_ITA.pdf'))