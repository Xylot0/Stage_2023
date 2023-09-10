function data_pca_av = CheckAvailabilityV2(data_pca,av_threshold)

    data_pca_av = table;
    av = sum(isnan(table2array(data_pca)),1) / size(data_pca,1);
    for i = 1:size(data_pca,2)
       if av(i) < 1 - av_threshold
           data_pca_av = [data_pca_av, data_pca(:,i)];
       end
    end

end