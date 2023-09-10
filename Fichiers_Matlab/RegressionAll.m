tic

clear all;

Parameters;

disp("Debut");

mesures_tot = [];

for f = 1:length(variables)
    
    var = variables(f);
    nb_variables = length(var);

    [pred1,validHours,name1] = LoadStation(name_pred1,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);

    predi_n0 = find(pred1.data_t == prediction_t0);
    predi_N = length(pred1.data_t);

    [target,~,name13] = LoadStation(name_target,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);

    target_n0 = predi_n0;
    target_N = predi_N;

    [pred2,~,name2] = LoadStation(name_pred2,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred3,~,name3] = LoadStation(name_pred3,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred4,~,name4] = LoadStation(name_pred4,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred5,~,name5] = LoadStation(name_pred5,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred6,~,name6] = LoadStation(name_pred6,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred7,~,name7] = LoadStation(name_pred7,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred8,~,name8] = LoadStation(name_pred8,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred9,~,name9] = LoadStation(name_pred9,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred10,~,name10] = LoadStation(name_pred10,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred11,~,name11] = LoadStation(name_pred11,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
    [pred12,~,name12] = LoadStation(name_pred12,var,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);

    data_pca = pred1(:,var);

    data_pca(:,nb_variables+1:2*nb_variables) = pred2(:,var);
    data_pca(:,2*nb_variables+1:3*nb_variables) = pred3(:,var);
    data_pca(:,3*nb_variables+1:4*nb_variables) = pred4(:,var);
    data_pca(:,4*nb_variables+1:5*nb_variables) = pred5(:,var);
    data_pca(:,5*nb_variables+1:6*nb_variables) = pred6(:,var);
    data_pca(:,6*nb_variables+1:7*nb_variables) = pred7(:,var);
    data_pca(:,7*nb_variables+1:8*nb_variables) = pred8(:,var);
    data_pca(:,8*nb_variables+1:9*nb_variables) = pred9(:,var);
    data_pca(:,9*nb_variables+1:10*nb_variables) = pred10(:,var);
    data_pca(:,10*nb_variables+1:11*nb_variables) = pred11(:,var);
    data_pca(:,11*nb_variables+1:12*nb_variables) = pred12(:,var);
    data_pca(:,12*nb_variables+1:13*nb_variables) = target(:,var);

    for i = 1:length(var)
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
        
        data_pred_train = [table2array(data_pca_av(:,1:k-1)) table2array(data_pca_av(:,k+1:end)) table2array(data_pca_av(:,k))];
        
        data_period_training = data_pred_train(1:predi_n0-1,:);
        data_period_prediction = data_pred_train(predi_n0:predi_N,1:end-1);
        observ_data_prediction = data_pred_train(predi_n0:predi_N,end);
        
        if method == "PLSR"                           
            
            X_training = data_period_training(:,1:end-1);
            y_training = data_period_training(:,end);

            nan_indices = any(isnan([X_training, y_training]), 2);
            X_training(nan_indices,:) = [];
            y_training(nan_indices,:) = [];

            ncomp = size(X_training,2);

            PLS = pls(X_training,y_training,ncomp);

            X_pred = data_period_prediction;
            X_test = [X_pred ones(size(X_pred,1), 1)];
            prevAle = X_test*PLS.regcoef_original_all(:,3);
            
        elseif method == "PCR"
 
            X_train = data_period_training(:,1:end-1);
            [coeff,scores,~,~,~,mu] = pca(X_train);
            
            X_pcr = X_train * coeff;
            beta = regress(data_period_training(:,end), [ones(size(X_pcr, 1), 1) X_pcr]);
            
            X_test = data_period_prediction;
            X_test_pcr = X_test * coeff;
                                 
            prevAle = [ones(size(X_test_pcr,1),1) X_test_pcr] * beta;
        end
        
        E = observ_data_prediction - prevAle;
        bias = 1/length(E) * sum(E,'omitnan');
        rmse = sqrt(mean(E.^2,'omitnan'));
        sde = sqrt(rmse^2 - bias^2);
        porcentage_na = round((sum(isnan(prevAle))) / sum(~isnan(prevAle))*100,3);
        
        mesures.(data_pca_av.Properties.VariableNames{k}) = [bias; rmse; sde; porcentage_na];
            
        disp("Biais : " + bias);
        disp("RMSE : " + rmse);
        disp("SDE : " + sde);
    end
    
    mesures_tot = [mesures_tot, mesures];
    
end
            
toc        
        