function [mesures,prevData] = PLSAnEn(predTotal,variables,target,v,M,Na,predi_n0,predi_N,ncores,nb_LV)

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
    
    [Y_analogs,Y_preds,Ynan] = OrganizedSequenceVectors(LVs,nb_LV,M,predi_n0,predi_N,var);   

    t = predi_N - predi_n0 + 1;
    prevData = zeros(length(variables),t);
    parfor (i=1:t,ncores)
        if mod(i,1000) == 0
            disp('Etape ' + i)
        end
        prevData(:,i) = MonachePLS(i,M,Y_analogs,Y_preds,Ynan,nb_LV,Na,target,variables);
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
        E = target.(variables)(predi_n0:predi_N) - prevData';
        bias = (1/length(E)) * sum(E,'omitnan');
        rmse = sqrt(mean(E.^2,'omitnan'));
        sde = sqrt(rmse^2 - bias^2);
        mesures = [bias rmse sde];
    end
        



end