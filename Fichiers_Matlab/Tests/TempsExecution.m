clear all;
Parameters;

for indTarget = 1:13
    if indTarget ~= 6 && indTarget ~= 5 && indTarget ~= 10
    disp("Station " + indTarget);
% Loading
[target,~,~] = LoadStation(name_pred{indTarget},variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
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

for nbLV = 1:6
    disp("Pour " + nbLV + " LV");
%% PCA/PLS
tic
if with_pca

    [data_pca_scaled_na,index] = rmmissing(data_pca_av);
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

    data = table2array(data_pca_av);
    X = data;
    y = target.(aim);
    X_training = X;
    y_training = y;
    
    nan_indices = any(isnan([X_training, y_training]), 2);
    X_training1 = X_training(~nan_indices,:);
    y_train1 = y_training(~nan_indices,:);

    ncomp = size(X_training,2);

    PLS = pls(X_training1,y_train1,ncomp,'autoscaling');   

    LVS = X_training1 * PLS.X_loadings;

    %% Composantes principales
    data_pca1_6 = nan(size(data_pca_av(:,1),1),nbLV);

    PCs = table;
    v = ["PC1","PC2","PC3","PC4","PC5","PC6"]; 

    pca1 = LVS(:,1);
    data_pca1_6(~nan_indices,1) = pca1;
    PCs.(v(1)) = data_pca1_6(:,1);

    if nbLV >= 2
        pca2 = LVS(:,2);
        data_pca1_6(~nan_indices,2) = pca2;
        PCs.(v(2)) = data_pca1_6(:,2);
    end

    if nbLV >= 3
        pca3 = LVS(:,3);
        data_pca1_6(~nan_indices,3) = pca3;
        PCs.(v(3)) = data_pca1_6(:,3);
    end

    if nbLV >= 4
        pca4 = LVS(:,4);
        data_pca1_6(~nan_indices,4) = pca4;
        PCs.(v(4)) = data_pca1_6(:,4);
    end

    if nbLV >= 5
        pca5 = LVS(:,5);
        data_pca1_6(~nan_indices,5) = pca5;
        PCs.(v(5)) = data_pca1_6(:,5);
    end

    if nbLV >= 6
        pca6 = LVS(:,6);
        data_pca1_6(~nan_indices,6) = pca6;
        PCs.(v(6)) = data_pca1_6(:,6);
    end

    nb_pca = nbLV;
end

[Y,Y_pred,Ynan] = OrganizedSequenceVectors(PCs,nb_pca,M,predi_n0,predi_N,v);

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
    res = X_test*PLS.regcoef_original_all(:,nbLV);
end
if method == "PCR"
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
end

%% Prediction
if method == "monache"
    t = target_N - target_n0 + 1;
    res = zeros(length(variables),t);

    parfor (i=1:t,ncores)
        res(:,i) = MonachePCA(i,M,Y,Y_pred,Ynan,nb_pca,Na,target,variables);
    end
end
if method == "cluster"
    t = target_N - target_n0 + 1;
    res = zeros(length(variables),t);

    Ynan = sum(isnan(Y),2) == 0;
    Y_purged = Y(Ynan,:);
    analogs_final = [];
    if length(variables) > 1
        for j = 1:length(variables)
            target_pres = target.(variables(j))(1:predi_n0-1,:);
            analogs_final(:,j) = target_pres(Ynan);
        end
    else
        target_pres = target.(variables)(1:predi_n0-1,:);
        analogs_final = target_pres(Ynan);
    end

    [clusterAn,centres] = kmeans(Y_purged,nb_centres,'MaxIter',nb_iterations);

    parfor (i=1:t,ncores)
        res(:,i) = ClustAnEn(i,M,Y,Y_pred,Ynan,nb_pca,Na,variables,analogs_final,centres,clusterAn,Y_purged);
    end
end

E = res(1,:)' - target.(aim)(predi_n0:end);
bias = 1/length(E) * sum(E,'omitnan');
rmse = sqrt(mean(E.^2,'omitnan'));
sde = sqrt(rmse^2 - bias^2);

disp("Biais : " + bias);
disp("RMSE : " + rmse);
disp("SDE : " + sde);

toc
end
    end
end


