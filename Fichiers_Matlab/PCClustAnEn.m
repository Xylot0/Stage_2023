function [mesures,nb_pca] = PCClustAnEn(predTotal,variables,target,M,Na,nb_iterations,nb_centres,predi_n0,predi_N,ncores)

    [PCs,nb_pca,~,var] = DoPCA(predTotal,variables);
    
    [Y_analogs,Y_pred,Ynan] = OrganizedSequenceVectors(PCs,nb_pca,M,predi_n0,predi_N,var);
    
    t = predi_N - predi_n0 + 1;
    prevData = zeros(length(variables),t);
    
    Ynan = sum(isnan(Y_analogs),2) == 0;
    Y_purged = Y_analogs(Ynan,:);
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
        prevData(:,i) = ClustAnEn(i,M,Y_analogs,Y_pred,Ynan,nb_pca,Na,variables,analogs_final,centres,clusterAn,Y_purged);
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
        E = target.(variables)(predi_n0:predi_N) - prevData(1,:)';
        bias = (1/length(E)) * sum(E,'omitnan');
        rmse = sqrt(mean(E.^2,'omitnan'));
        sde = sqrt(rmse^2 - bias^2);
        mesures = [mesures; bias rmse sde];
    end

end