tic

clear all;

Parameters;

disp("Debut");

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
data_pca(:,12*nb_variables+1:13*nb_variables) = target(:,variables);

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
    data_pca.Properties.VariableNames{12*nb_variables+i} = name13{i};
end

data_pca_av = CheckAvailabilityV2(data_pca,0.85);

mesures = table;

for k = 1:size(data_pca_av,2)

    data = table2array(data_pca_av);
    X = [data(:,1:k-1), data(:,k+1:end)];
    y = data(:,k);
    X_training = X(1:predi_n0-1,:);
    y_training = y(1:predi_n0-1,:);
    y_pred = y(predi_n0:predi_N,:);
    
    if with_pca

        [data_pca_scaled_na,index] = rmmissing(X);
        data_normalize = normalize(data_pca_scaled_na);
        [coeff,pcaa,latent] = pca(table2array(data_normalize));

        stdev = sqrt(latent);
        nb_pca= sum(latent >= 1);

        data_pca1_6 = nan(size(data_pca_av(:,1),1),6);
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

    elseif with_pls
        
        nan_indices = any(isnan([X_training, y_training]), 2);
        X_training1 = X_training(~nan_indices,:);
        y_train1 = y_training(~nan_indices,:);

        ncomp = size(X_training,2);

        PLS = pls(X_training1,y_train1,ncomp,'autoscaling');   

        LVS = X_training1 * PLS.X_loadings;

        %% Composantes principales
        data_pca1_6 = nan(size(data_pca_av(:,1),1),nb_LV);

        PCs = table;
        v = ["PC1","PC2","PC3","PC4","PC5","PC6"]; 

        pca1 = LVS(:,1);
        data_pca1_6(~nan_indices,1) = pca1;
        PCs.(v(1)) = data_pca1_6(:,1);

        if nb_LV >= 2
            pca2 = LVS(:,2);
            data_pca1_6(~nan_indices,2) = pca2;
            PCs.(v(2)) = data_pca1_6(:,2);
        end

        if nb_LV >= 3
            pca3 = LVS(:,3);
            data_pca1_6(~nan_indices,3) = pca3;
            PCs.(v(3)) = data_pca1_6(:,3);
        end

        if nb_LV >= 4
            pca4 = LVS(:,4);
            data_pca1_6(~nan_indices,4) = pca4;
            PCs.(v(4)) = data_pca1_6(:,4);
        end

        if nb_LV >= 5
            pca5 = LVS(:,5);
            data_pca1_6(~nan_indices,5) = pca5;
            PCs.(v(5)) = data_pca1_6(:,5);
        end

        if nb_LV >= 6
            pca6 = LVS(:,6);
            data_pca1_6(~nan_indices,6) = pca6;
            PCs.(v(6)) = data_pca1_6(:,6);
        end
        
        nb_pca = nb_LV;
    end
    
    [Y,Y_pred,Ynan] = OrganizedSequenceVectors(PCs,nb_pca,M,predi_n0,predi_N,v);
    
    if method == "cluster"
        t = target_N - target_n0 + 1;
        res = zeros(length(variables),t);

        Ynan = sum(isnan(Y),2) == 0;
        Y_purged = Y(Ynan,:);

        analogs_final = y_training(Ynan);

        [clusterAn,centres] = kmeans(Y_purged,nb_centres,'MaxIter',nb_iterations);

        parfor (i=1:t,ncores)
            res(:,i) = ClustAnEn(i,M,Y,Y_pred,Ynan,nb_pca,Na,variables,analogs_final,centres,clusterAn,Y_purged);
        end

        disp("Data quantity predicted : " + sum(~isnan(res(1,:))));

        E = res(1,:)' - y_pred;
        bias = 1/length(E) * sum(E,'omitnan');
        rmse = sqrt(mean(E.^2,'omitnan'));
        sde = sqrt(rmse^2 - bias^2);
        porcentage_na = round((sum(isnan(res(1,:)))) / sum(~isnan(res(1,:)))*100,3);
        
        mesures.(data_pca_av.Properties.VariableNames{k}) = [bias; rmse; sde; porcentage_na];

        disp("Biais : " + bias);
        disp("RMSE : " + rmse);
        disp("SDE : " + sde);
        
     elseif method == "monache"
        t = target_N - target_n0 + 1;
        res = zeros(length(variables),t);

        parfor (i=1:t,ncores)
            res(:,i) = MonachePCA(i,M,Y,Y_pred,Ynan,nb_pca,Na,target,variables);
        end

        disp("Data quantity predicted : " + sum(~isnan(res(1,:))));

        E = res(1,:)' - y_pred;
        bias = 1/length(E) * sum(E,'omitnan');
        rmse = sqrt(mean(E.^2,'omitnan'));
        sde = sqrt(rmse^2 - bias^2);
        porcentage_na = round((sum(isnan(res))) / sum(~isnan(res))*100,3);
        
        mesures.(data_pca_av.Properties.VariableNames{k}) = [bias; rmse; sde; porcentage_na];
        
        disp("Biais : " + bias);
        disp("RMSE : " + rmse);
        disp("SDE : " + sde);
    end
end
    
toc