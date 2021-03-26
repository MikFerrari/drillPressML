function normalized_features_table = normalizeFeatures_NorP(features_table)

    mu = mean(table2array(features_table(:,1:end-2)));
    sigma = std(table2array(features_table(:,1:end-2)));

    normalized_features_table = features_table;
    normalized_features_table(:,1:end-2) = array2table( ...
        (table2array(features_table(:,1:end-2))-mu)./sigma);

end

