function mesures = PLSClustAnEn(predTotal,variables,target,v,M,Na,nb_iterations,nb_centres,predi_n0,predi_N,ncores,nb_LV)

   nb_variables = length(variables);
    k = 1;

 
    for j = 1:length(predTotal)
        for i = 1:length(variables)
            if contains(variables(i),predTotal{j}.Properties.VariableNames) 
                data_pca(:,k) = predTotal{j}(:,variables(i));
                k = k+1;
            end
        end
    end
    
    tar = target(v.aim);
    [LVs,var] = DoPLS(data_pca,tar,nb_LV);
    
    [Y_analogs,Y_pred,Ynan] = OrganizedSequenceVectors(LVs,nb_LV,M,predi_n0,predi_N,var);
    
    t = predi_N - predi_n0+1;
    prevData = zeros(length(variables),t);
    
    Ynan = sum(isnan(Y_analogs),2) == 0;
    Y_purged = Y_analogs(Ynan,:);
    if length(variables) > 1
        for j = 1:length(variables)
            target_pres = target.(variables(j))(1:predi_n0-1,:);
            analogs_final(:,j) = target_pres(Ynan);
        end
    else
        target_pres = target.(v.aim)(1:predi_n0-1,:);
        analogs_final = target_pres(Ynan);
    end
    
    [clusterAn,centres] = kmeans(Y_purged,nb_centres,'MaxIter',nb_iterations);
    
    parfor (i=1:t,ncores)
        prevData(:,i) = ClustAnEn(i,M,Y_analogs,Y_pred,Ynan,nb_LV,Na,target,variables,analogs_final,centres,clusterAn,Y_purged);
    end
    
%% Résultats

    mesures = [];
    
    if length(variables) > 1
        for i = 1:length(variables)
            E = target.(variables(i))(predi_n0:predi_N) - prevData(i,:)';
            bias = (1/length(E)) * sum(E,'omitnan');
            rmse = sqrt(mean(E.^2,'omitnan'));
            sde = sqrt(rmse^2 - bias^2);
            mesures = [mesures; bias rmse sde];
        end
    else 
        E = target.(v.aim)(predi_n0:predi_N) - prevData(1,:)';
        bias = (1/length(E)) * sum(E,'omitnan');
        rmse = sqrt(mean(E.^2,'omitnan'));
        sde = sqrt(rmse^2 - bias^2);
        mesures = [mesures; bias rmse sde];
    end

end