function result_final = ClustAnEn(i,M,Y,Y_pred,Ynan,nb_pca,Na,variables,analogs_final,centres,clusterAn,Ypurged)

    analogs_final2 = cell(1,length(variables));
    y = Y_pred(i,:);
    
    if sum(isnan(y)) < 0.5 * (2*M+1) * nb_pca
        A = (centres - y).^2;
        metric = sqrt(sum(A,2,'omitnan'));
        [~,cluster_min] = min(metric);
        ensCluster = (clusterAn == cluster_min);
        clusterElem = Ypurged(ensCluster,:);
        
        B = (clusterElem - y).^2;
        metric2 = sqrt(sum(B,2,'omitnan'));
        [~,index] = sort(metric2);
        
        if length(index) >= Na
            Na_index = index(1:Na);
        else
            Na_index = index;
        end
        
        analogs_final_local = analogs_final(ensCluster,:);
        
        for j=1:length(variables)
            analogs_final2(1,j) = {analogs_final_local(Na_index,j)};
        end
        
        result_final = cellfun(@(x) mean(x,'omitnan'),analogs_final2);
    else
        result_final = nan(1,length(variables));
    end
    
end