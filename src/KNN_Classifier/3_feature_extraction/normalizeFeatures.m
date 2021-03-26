function normalized_features_table = normalizeFeatures(features_table)

    mu = mean(table2array(features_table(:,1:end-1)));
    sigma = std(table2array(features_table(:,1:end-1)));

    normalized_features_table = features_table;
    normalized_features_table(:,1:end-1) = array2table( ...
        (table2array(features_table(:,1:end-1))-mu)./sigma);

end

