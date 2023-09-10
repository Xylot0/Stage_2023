function [bias,rmse,sde,stdev,predictions] = ResultatsPCR(predTotal,variables,target,predi_n0,predi_N)

nb_variables = length(variables);
k = 1;

for j = 1:length(predTotal)
    for i=1:nb_variables
        if contains(variables(i),predTotal{j}.Properties.VariableNames) 
            data_pcaa(:,k) = predTotal{j}.(variables(i));
            k = k+1;
        end
    end
end

X = data_pcaa;
X_train = X(1:predi_n0-1,:);
X_pred = X(predi_n0:predi_N,:);
y = target;
y_train = y(1:predi_n0-1,:);
y_pred = y(predi_n0:predi_N,:);

disp('Debut');
% Cas avec toutes les variables en même temps
model = DoPCR(X_train,y_train);

X_pred_centered = X_pred - model.mean_X;

z_tilde = X_pred_centered * model.coeff;

y_tilde =  z_tilde * model.c;

predictions = y_tilde + model.mean_y;


E = y_pred - predictions;
bias = (1/length(E)) * sum(E, 'omitnan');
rmse = sqrt(mean(E.^2, 'omitnan'));
sde = sqrt(rmse^2 - bias^2);

% Affichage des résultats
disp('BIAS :');
disp(bias);
disp('RMS :');
disp(rmse);
disp('SDE :');
disp(sde);

end