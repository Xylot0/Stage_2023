[pred1,validHours,name1] = LoadStation(name_pred1,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);

predi_n0 = find(pred1.data_t == prediction_t0);
predi_N = length(pred1.data_t);

[target,~,name13] = LoadStation(name_target,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);

target_n0 = predi_n0;
target_N = predi_N;

[pred2,~,name2] = LoadStation(name_pred2,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred3,~,name3] = LoadStation(name_pred3,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred4,~,name4] = LoadStation(name_pred4,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred5,~,name5] = LoadStation(name_pred5,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred6,~,name6] = LoadStation(name_pred6,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred7,~,name7] = LoadStation(name_pred7,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred8,~,name8] = LoadStation(name_pred8,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred9,~,name9] = LoadStation(name_pred9,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred10,~,name10] = LoadStation(name_pred10,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred11,~,name11] = LoadStation(name_pred11,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
[pred12,~,name12] = LoadStation(name_pred12,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);

data_pca = pred1(:,variables);
nb_variables = length(variables);

data_pca(:,nb_variables+1:2*nb_variables) = pred2(:,variables);
data_pca(:,2*nb_variables+1:3*nb_variables) = pred3(:,variables);
data_pca(:,3*nb_variables+1:4*nb_variables) = pred4(:,variables);
data_pca(:,4*nb_variables+1:5*nb_variables) = pred5(:,variables);
data_pca(:,5*nb_variables+1:6*nb_variables) = pred6(:,variables);
data_pca(:,6*nb_variables+1:7*nb_variables) = pred7(:,variables);
data_pca(:,7*nb_variables+1:8*nb_variables) = pred8(:,variables);
data_pca(:,8*nb_variables+1:9*nb_variables) = pred9(:,variables);
data_pca(:,9*nb_variables+1:10*nb_variables) = pred10(:,variables);
data_pca(:,10*nb_variables+1:11*nb_variables) = pred11(:,variables);
data_pca(:,11*nb_variables+1:12*nb_variables) = pred12(:,variables);

    for i = 1:length(variables)
        data_pca.Properties.VariableNames{i} = name1{i};
        data_pca.Properties.VariableNames{nb_variables+i} = name2{i};
        data_pca.Properties.VariableNames{2*nb_variables+i} = name3{i};
        data_pca.Properties.VariableNames{3*nb_variables+i} = name4{i};
        data_pca.Properties.VariableNames{4*nb_variables+i} = name5{i};
        data_pca.Properties.VariableNames{5*nb_variables+i} = name6{i};
        data_pca.Properties.VariableNames{6*nb_variables+i} = name7{i};
        data_pca.Properties.VariableNames{7*nb_variables+i} = name8{i};
        data_pca.Properties.VariableNames{8*nb_variables+i} = name9{i};
        data_pca.Properties.VariableNames{9*nb_variables+i} = name10{i};
        data_pca.Properties.VariableNames{10*nb_variables+i} = name11{i};
        data_pca.Properties.VariableNames{11*nb_variables+i} = name12{i};
    end

data_pca_av = CheckAvailabilityV2(data_pca,0.85);

%% PCA

[data_pca_scaled_na,index] = rmmissing(data_pca_av);
data_normalize = normalize(data_pca_scaled_na);
[coeff,pcaa,latent] = pca(table2array(data_normalize));

stdev = sqrt(latent);
nb_pca= sum(latent >= 1);
% nb_pca = 6;

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

[Y,Y_pred,Ynan] = OrganizedSequenceVectors(PCs,nb_pca,M,predi_n0,predi_N,v);



