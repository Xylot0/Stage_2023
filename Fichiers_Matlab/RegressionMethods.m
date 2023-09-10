clear all;
tic

Parameters;

%% Loading
indTarget = 13;
[target,~,name_target] = LoadStation(name_pred{indTarget},variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
data_pca = table;
parfor (i=1:length(name_pred),ncores)
    if i ~= indTarget
        [pred,~,name] = LoadStation(name_pred{i},variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
        cellname = [];
        for j = 1:length(variables)
            cellname = name{j};
            tempTable = table(table2array(pred(:,variables(j))),'VariableNames',{cellname});
            data_pca = horzcat(data_pca,tempTable);
        end
    end
end

predi_n0 = find(target.data_t == prediction_t0);
predi_N = length(target.data_t);

target_n0 = predi_n0;
target_N = predi_N;

data_pca_av = CheckAvailabilityV2(data_pca,0.85);
disp("Debut");

if method == "PLSR"
    
    X = table2array(data_pca_av);
    y = target.(aim);

    X_training = X(1:predi_n0-1,:);
    y_training = y(1:predi_n0-1,:);

    X_pred = X(predi_n0:end,:);
    y_pred = y(predi_n0:end,:);
    
    nan_indices = any(isnan([X_training, y_training]), 2);
    X_training(nan_indices,:) = [];
    y_training(nan_indices,:) = [];
     
    ncomp = size(X_training,2);

    PLS = pls(X_training,y_training,ncomp,'autoscaling');
    
    X_test = [X_pred ones(size(X_pred,1), 1)];
    res = X_test*PLS.regcoef_original_all(:,4);
              
%     for i=1:length(variables)
        disp("Data quantity predicted : " + sum(~isnan(res(:,1))));

        E = res(:,1) - target.(variables(1))(predi_n0:end);
        bias = 1/length(E) * sum(E,'omitnan');
        rmse = sqrt(mean(E.^2,'omitnan'));
        sde = sqrt(rmse^2 - bias^2);

        disp("Biais : " + bias);
        disp("RMSE : " + rmse);
        disp("SDE : " + sde);
%     end
    
elseif method == "PCR"
    
    X = table2array(data_pca_av);
    y = target.(aim);

    X_training = X(1:predi_n0-1,:);
    y_training = y(1:predi_n0-1,:);

    X_pred = X(predi_n0:end,:);
    y_pred = y(predi_n0:end,:);
    
    [coeff,scores,~,~,~,mu] = pca(normalize(X_training));

    X_pcr = X_training * coeff;
    beta = regress(y_training, [ones(size(X_pcr, 1), 1) X_pcr(:,1:6)]);

    X_test = X_pred;
    X_test_pcr = X_test * coeff;

    res = [ones(size(X_test_pcr,1),1) X_test_pcr(:,1:6)] * beta;
    
    disp("Data quantity predicted : " + sum(~isnan(res(:,1))));

    E = res(:,1) - target.(aim)(predi_n0:end);
    bias = 1/length(E) * sum(E,'omitnan');
    rmse = sqrt(mean(E.^2,'omitnan'));
    sde = sqrt(rmse^2 - bias^2);

    disp("Biais : " + bias);
    disp("RMSE : " + rmse);
    disp("SDE : " + sde);
    
end
   
toc

  
    
    