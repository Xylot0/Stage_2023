function Q = ResultatsPLSR3(name_pred,variables,aim,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S,ncores,prediction_t0)

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

Q = zeros(1,size(X_train,2));

CV = plscv(X_train,y_train,size(X_train,2),10,'center');
RESS = CV.RESS;
for p = 1:size(X_train,2)
    PLS = pls(X_train,y_train,p,'center');
    PRESS(p) = PLS.SSE;
    
    if p == 1
        Q(p) = 1 - PRESS(1)/(size(X_train,2)*(size(X_train,1)-1));
    else
        Q(p) = 1 - PRESS(p)/RESS(p-1);
    end
    
end

end