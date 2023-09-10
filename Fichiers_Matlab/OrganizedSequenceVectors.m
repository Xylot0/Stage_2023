function [Y_analogs,Y_predictions,Ynan] = OrganizedSequenceVectors(PCs,nb_pca,M,pred1_n0,pred1_N,v)

nanRow = array2table(NaN(M, nb_pca), 'VariableNames', cellstr("PC" + (1:nb_pca)));
PCs = [nanRow; PCs; nanRow];

n = size(PCs,1);

Y = zeros(n-2*M,(2*M+1)*nb_pca);
for j = 1:nb_pca
    data_into_vectors = zeros(n-2*M,2*M+1);
    for i = 1:(2*M+1)
        data_into_vectors(:,i) = PCs.(v(j))(i:n - (2*M + 1) + i);
    end
    Y(:,(2*M+1)*(j-1)+1:(2*M+1)*j) = data_into_vectors;
end

Y_analogs = Y(1:pred1_n0-1,:);
Y_predictions = Y(pred1_n0:pred1_N,:);

%% Ynan
Ynan = sum(isnan(Y_analogs),2) >= 0.5 * M * nb_pca;

end