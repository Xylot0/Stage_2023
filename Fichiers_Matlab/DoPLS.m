function [LVs,var] = DoPLS(data_pcaa,tar,nb_LV)
    
    data_pcaa = [data_pcaa, tar];
    
    % Gérer les valeurs NaN dans les données d'entraînement
    all_training = table2array(data_pcaa);
    nan_indices = any(isnan(all_training), 2);
    all_training(nan_indices,:) = [];

    all_training_scaled = normalize(all_training);
    ncomp = size(all_training_scaled,2)-1;
 
    [Xloadings,~,Xscores,Yscores,~,~,~,~] = plsregress(all_training_scaled(:,1:end-1),all_training_scaled(:,end),ncomp); %% XL = loadings du prédicteur  
     
    LVS = all_training_scaled(:,1:end-1) * Xloadings;
   
    %% Composantes principales
    data_pca1_6 = nan(size(data_pcaa(:,1),1),nb_LV);

    LVs = table;
    var = ["PC1","PC2","PC3","PC4","PC5","PC6"]; 

    pca1 = LVS(:,1);
    data_pca1_6(~nan_indices,1) = pca1;
    LVs.(var(1)) = data_pca1_6(:,1);

    if nb_LV >= 2
        pca2 = LVS(:,2);
        data_pca1_6(~nan_indices,2) = pca2;
        LVs.(var(2)) = data_pca1_6(:,2);
    end

    if nb_LV >= 3
        pca3 = LVS(:,3);
        data_pca1_6(~nan_indices,3) = pca3;
        LVs.(var(3)) = data_pca1_6(:,3);
    end

    if nb_LV >= 4
        pca4 = LVS(:,4);
        data_pca1_6(~nan_indices,4) = pca4;
        LVs.(var(4)) = data_pca1_6(:,4);
    end

    if nb_LV >= 5
        pca5 = LVS(:,5);
        data_pca1_6(~nan_indices,5) = pca5;
        LVs.(var(5)) = data_pca1_6(:,5);
    end

    if nb_LV >= 6
        pca6 = LVS(:,6);
        data_pca1_6(~nan_indices,6) = pca6;
        LVs.(var(6)) = data_pca1_6(:,6);
    end
end