function [mesures,prevData] = PCAnEn(predTotal,variables,target,M,Na,predi_n0,predi_N,ncores)
    
    [PCs,nb_pca,~,var] = DoPCA(predTotal,variables);
    
    [Y_analogs,Y_preds,Ynan] = OrganizedSequenceVectors(PCs,nb_pca,M,predi_n0,predi_N,var);   

    t = predi_N - predi_n0+1;
    prevData = zeros(length(variables),t);
    parfor (i=1:t,ncores)
        if mod(i,1000) == 0
            disp('Etape ' + i)
        end
        prevData(:,i) = MonachePCA(i,M,Y_analogs,Y_preds,Ynan,nb_pca,Na,target,variables);
    end

    %% Résultats

    mesures = [];
    for i = 1:length(variables)
        if length(variables) > 1
            E = target.(variables(i))(predi_n0:predi_N) - prevData(i,:)';
            bias = (1/length(E)) * sum(E,'omitnan');
            rmse = sqrt(mean(E.^2,'omitnan'));
            sde = sqrt(rmse^2 - bias^2);
            mesures = [mesures; bias rmse sde];
        else 
            E = target.(variables)(predi_n0:predi_N) - prevData(1,:)';
            bias = (1/length(E)) * sum(E,'omitnan');
            rmse = sqrt(mean(E.^2,'omitnan'));
            sde = sqrt(rmse^2 - bias^2);
            mesures = [mesures; bias rmse sde];
        end
    end
        



end