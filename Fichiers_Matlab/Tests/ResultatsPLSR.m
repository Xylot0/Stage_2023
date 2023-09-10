function [bias,rmse,sde,predictions] = ResultatsPLSR(predTotal,variables,target,predi_n0,predi_N,nb_LV)

% Formation des données de départ
nb_variables = length(variables);
k = 1;
Q = zeros(1,8);

for i=1:nb_variables
    for j = 1:length(predTotal)
        if contains(variables(i),predTotal{j}.Properties.VariableNames) 
            data_pcaa(:,k) = predTotal{j}.(variables(i));
            k = k+1;
        end
    end
end

if size(target,2) > 1
    tar = table2array(target);
else
    tar = target;
end
data_pcaa = [data_pcaa, tar];

disp('Debut')

X = data_pcaa;
data_period_training = X(1:predi_n0,:);
data_period_prediction = X(predi_n0+1:predi_N,1:end-1);

observ_data_prediction = X(predi_n0+1:predi_N,end);

    % PLS  
    model = DoPLSR(data_period_training,nb_LV);

    % Régression
    X_pred_centered = data_period_prediction - model.mean_X;

    y_fit = [ones(size(X_pred_centered,1),1) X_pred_centered];
    y_tilde =  y_fit * model.c;
    predictions = y_tilde + model.mean_y;
    E = observ_data_prediction - predictions;
    
    
    % Résultats
    bias = (1/length(E)) * sum(E, 'omitnan');
    rmse = sqrt(mean(E.^2, 'omitnan'));
    sde = sqrt(rmse^2 - bias^2);

end
