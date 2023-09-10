function model = DoPCR(X_train,y_train)

    % Gérer les valeurs NaN dans les données d'entraînement
    nan_indices = any(isnan([X_train, y_train]), 2);
    X_train(nan_indices, :) = [];
    y_train(nan_indices) = [];

    % Centrer les données d'entraînement
    X_train_centered = normalize(X_train);
    y_train_centered = normalize(y_train);


    % Effectuer l'analyse en composantes principales (PCA) sur les données d'entraînement
    [coeff, scores, latent, ~, ~] = pca(X_train_centered);

    stdev = sqrt(latent);
    nb_pca= sum(latent >= 1);

    pc = scores;

    c = regress(y_train_centered, pc);

    model.coeff = coeff;
    model.mean_X = mean(X_train);
    model.mean_y = mean(y_train);
    model.c = c;


end