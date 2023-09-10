function result_final = MonachePCA(i,M,Y,Y_pred,Ynan,nb_pca,Na,target,variables)

y = Y_pred(i,:);
Y_local = Y;
nb_series = nb_pca;
analogs_final = cell(1,length(variables));

    if sum(isnan(y)) < 0.5 * (2*M + 1) * nb_series
        A = (Y_local - y).^2;

        Anan = sum(isnan(A),2) > 0.5 * (2*M + 1) * nb_series;

        A1 = sqrt(sum(A(:,1:(2*M+1)),2,'omitnan'));
        A2 = 0;
        A3 = 0;
        A4 = 0;
        A5 = 0;
        A6 = 0;

        if nb_pca >= 2 
            index_debut = 1;
            A2 = sqrt(sum(A(:,(index_debut*(2*M + 1) + 1):((index_debut+1)*(2*M + 1))),2,'omitnan'));
        end

        if nb_pca >= 3
            index_debut = 2;
            A3 = sqrt(sum(A(:,(index_debut*(2*M + 1) + 1):((index_debut+1)*(2*M + 1))),2,'omitnan'));
        end

        if nb_pca >= 4 
            index_debut = 3;
            A4 = sqrt(sum(A(:,(index_debut*(2*M + 1) + 1):((index_debut+1)*(2*M + 1))),2,'omitnan'));
        end

        if nb_pca >= 5
            index_debut = 4;
            A5 = sqrt(sum(A(:,(index_debut*(2*M + 1) + 1):((index_debut+1)*(2*M + 1))),2,'omitnan'));
        end

        if nb_pca >= 6
            index_debut = 5;
            A6 = sqrt(sum(A(:,(index_debut*(2*M + 1) + 1):((index_debut+1)*(2*M + 1))),2,'omitnan'));
        end

        metric = A1 + A2 + A3 + A4 + A5 + A6;
        metric(Anan) = Inf;
        metric(Ynan) = Inf;
        [~,index] = sort(metric);
        Na_index = index(1:Na);

        for j = 1:length(variables)
            analogs_final(1,j) = {target.(variables(j))(Na_index)};
        end

        result_final = cellfun(@(x) mean(x,'omitnan'), analogs_final);
    else
        result_final = nan(1,length(variables));
    end
end