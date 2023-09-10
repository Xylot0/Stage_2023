function [PCs,nb_pca,stdev,v] = DoPCA(predTotal,variables)

    nb_variables = length(variables);
    k = 1;

   for j = 1:length(predTotal)
        for i=1:nb_variables
            if contains(variables(i),predTotal{j}.Properties.VariableNames) 
                data_pca(:,k) = predTotal{j}(:,variables(i));
                k = k+1;
            end
        end
    end

[data_pca_scaled_na,index] = rmmissing(data_pca); %% Retire les lignes où il manque des données
data_normalize = normalize(data_pca_scaled_na); %% Renvoie le z-score de centre 0 et de déviation standard 1
[coeff,pcaa,latent] = pca(table2array(data_normalize)); %% coeff représente les vecteurs propres, pcaa représente les composantes principales, latent représente les valeurs propres

stdev = sqrt(latent);
nb_pca= sum(latent >= 1);

%% Composantes principales
data_pca1_6 = nan(size(data_pca(:,1),1),6);
PCs = table;

v = ["PC1","PC2","PC3","PC4","PC5","PC6"]; 

pca1 = pcaa(:,1);
data_pca1_6(~index,1) = pca1;
PCs.(v(1)) = data_pca1_6(:,1);

if nb_pca >= 2
    pca2 = pcaa(:,2);
    data_pca1_6(~index,2) = pca2;
    PCs.(v(2)) = data_pca1_6(:,2);
end

if nb_pca >= 3
    pca3 = pcaa(:,3);
    data_pca1_6(~index,3) = pca3;
    PCs.(v(3)) = data_pca1_6(:,3);
end

if nb_pca >= 4
    pca4 = pcaa(:,4);
    data_pca1_6(~index,4) = pca4;
    PCs.(v(4)) = data_pca1_6(:,4);
end

if nb_pca >= 5
    pca5 = pcaa(:,5);
    data_pca1_6(~index,5) = pca5;
    PCs.(v(5)) = data_pca1_6(:,5);
end

if nb_pca >= 6
    pca6 = pcaa(:,6);
    data_pca1_6(~index,6) = pca6;
    PCs.(v(6)) = data_pca1_6(:,6);
end

end