function model = DoPLSR(X_train,nb_LV)
        
    % Gérer les valeurs NaN dans les données d'entraînement
    nan_indices = any(isnan(X_train), 2);
    X_train(nan_indices, :) = [];

    % Centrer les données d'entraînement
    X_train_centered = normalize(X_train);
    
    % Effectuer l'analyse en composantes principales (PCA) sur les données d'entraînement
    [Xloadings,~,~,~,beta,~,~,~] = plsregress(X_train_centered(:,1:end-1),X_train_centered(:,end),nb_LV);
  
    model.coeff = Xloadings;
    model.mean_X = mean(X_train(:,1:end-1));
    model.mean_y = mean(X_train(:,end));
    model.c = beta;


end