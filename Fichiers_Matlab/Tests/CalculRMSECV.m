clear all;
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
X = table2array(data_pca_av);
y = target.(aim);
X_train = X(1:predi_n0-1,:);
y_train = y(1:predi_n0-1,:);

nan_indices = any(isnan([X_train, y_train]),2);
X_train(nan_indices,:) = [];
y_train(nan_indices,:) = [];

RMSEDCV = [];
tic
for k = 1:size(X_train,2)
    PLSRDCV = plsrdcv(X_train,y_train,k,2,'center',10,1);
    RMSEDCV(:,k) = PLSRDCV.RMSEP;
    fitError(:,k) = PLSRDCV.predError;
end
toc
    
    %% Courbes de RMSEDCV
%     figure;
%     
%     subplot(1,3,1);
%     plot(1:size(X_train,2),RMSEDCV,'r-p',1:size(X_train,2),mean(RMSEDCV,1),'b-p');
%     title("WSPD/GST");
%     xlabel("# Latent Variables");
%     ylabel("RMSECV");
%     
%     subplot(1,3,2);
%     plot(1:size(X_train,2),RMSEDCV,'r-p',1:size(X_train,2),mean(RMSEDCV,1),'b-p');
%     title("ATMP");
%     xlabel("# Latent Variables");
%     ylabel("RMSECV");
    
%     subplot(1,3,3);
%     plot(1:size(X_train,2),RMSEDCV,'r-p',1:size(X_train,2),mean(RMSEDCV,1),'b-p');
%     title("PRES");
%     xlabel("# Latent Variables");
%     ylabel("RMSECV");
    