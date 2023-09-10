clear all;
tic

Parameters;
disp("Debut");

if method == "monache"
    if with_pca
        LoadAndOrganizeDataWithPCAV2;
        t = target_N - target_n0 + 1;
        res = zeros(length(variables),t);
        
        parfor (i=1:t,ncores)
            res(:,i) = MonachePCA(i,M,Y,Y_pred,Ynan,nb_pca,Na,target,variables);
        end
        
        for i=1:length(variables)
            disp("Data quantity predicted : " + sum(~isnan(res(i,:))));
            
            E = res(i,:)' - target.(variables(i))(target_n0:target_n0+t-1);
            bias = 1/length(E) * sum(E,'omitnan');
            rmse = sqrt(mean(E.^2,'omitnan'));
            sde = sqrt(rmse^2 - bias^2);
            
            disp("Biais : " + bias);
            disp("RMSE : " + rmse);
            disp("SDE : " + sde);
        end
    elseif with_pls
        LoadAndOrganizeDataWithPLSV2;
        t = target_N - target_n0 + 1;
        res = zeros(length(variables),t);

        parfor (i=1:t,ncores)
            res(:,i) = MonachePCA(i,M,Y,Y_pred,Ynan,nb_LV,Na,target,variables);
        end

        for i=1:length(variables)
            disp("Data quantity predicted : " + sum(~isnan(res(i,:))));

            E = res(i,:)' - target.(variables(i))(target_n0:target_n0+t-1);
            bias = 1/length(E) * sum(E,'omitnan');
            rmse = sqrt(mean(E.^2,'omitnan'));
            sde = sqrt(rmse^2 - bias^2);

            disp("Biais : " + bias);
            disp("RMSE : " + rmse);
            disp("SDE : " + sde);
        end
    end
elseif method == "cluster"
    if with_pca
        LoadAndOrganizeDataWithPCAV2;
        t = target_N - target_n0 + 1;
        res = zeros(length(variables),t);

        Ynan = sum(isnan(Y),2) == 0;
        Y_purged = Y(Ynan,:);
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

        for i=1:length(variables)
            disp("Data quantity predicted : " + sum(~isnan(res(i,:))));

            E = res(i,:)' - target.(variables(i))(target_n0:target_n0+t-1);
            bias = 1/length(E) * sum(E,'omitnan');
            rmse = sqrt(mean(E.^2,'omitnan'));
            sde = sqrt(rmse^2 - bias^2);

            disp("Biais : " + bias);
            disp("RMSE : " + rmse);
            disp("SDE : " + sde);
        end
    elseif with_pls
        LoadAndOrganizeDataWithPLSV2;
        t = target_N - target_n0 + 1;
        res = zeros(length(variables),t);

        Ynan = sum(isnan(Y),2) == 0;
        Y_purged = Y(Ynan,:);
        for j = 1:length(variables)
            target_pres = target.(variables(j))(1:target_n0-1,:);
            analogs_final(:,j) = target_pres(Ynan);
        end

        [clusterAn,centres] = kmeans(Y_purged,nb_centres,'MaxIter',nb_iterations);

        parfor (i=1:t,ncores)
            res(:,i) = ClustAnEn(i,M,Y,Y_pred,Ynan,nb_LV,Na,variables,analogs_final,centres,clusterAn,Y_purged);
        end

        for i=1:length(variables)
            disp("Data quantity predicted : " + sum(~isnan(res(i,:))));

            E = res(i,:)' - target.(variables(i))(target_n0:target_n0+t-1);
            bias = 1/length(E) * sum(E,'omitnan');
            rmse = sqrt(mean(E.^2,'omitnan'));
            sde = sqrt(rmse^2 - bias^2);

            disp("Biais : " + bias);
            disp("RMSE : " + rmse);
            disp("SDE : " + sde);
        end
    end
end
        
toc
    
    
    
    