Parameters;

%% Fichier de la station AAM

pred1 = LoadStation(name_pred1,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred1 = CheckAvailability(pred1,variables);

pred1_n0 = find(pred1.data_t == prediction_t0);
pred1_N = length(pred1.data_t);

%% Fichier target (PPX)

target = LoadStation(name_target,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S); 

%% Fichier de la station DPX

pred2 = LoadStation(name_pred2,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred2 = CheckAvailability(pred2,variables);

%% Fichier de la station FTP

pred3 = LoadStation(name_pred3,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred3 = CheckAvailability(pred3,variables);

%% Fichier de la station LND

pred4 = LoadStation(name_pred4,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred4 = CheckAvailability(pred4,variables);

%% Fichier de la station OBX

pred5 = LoadStation(name_pred5,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred5 = CheckAvailability(pred5,variables);

%% Fichier de la station OMH

pred6 = LoadStation(name_pred6,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred6 = CheckAvailability(pred6,variables);

%% Fichier de la station PCO

pred7 = LoadStation(name_pred7,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred7 = CheckAvailability(pred7,variables);

%% Fichier de la station PSB

pred8 = LoadStation(name_pred8,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred8 = CheckAvailability(pred8,variables);

%% Fichier de la station PXO

pred9 = LoadStation(name_pred9,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred9 = CheckAvailability(pred9,variables);

%% Fichier de la station PXS

pred10 = LoadStation(name_pred10,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred10 = CheckAvailability(pred10,variables);

%% Fichier de la station RCM

pred11 = LoadStation(name_pred11,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred11 = CheckAvailability(pred11,variables);

%% Fichier de la station RTY

pred12 = LoadStation(name_pred12,variables,interp,start_of_date,end_of_date,time_interval,start_H,start_M,start_S,end_H,end_M,end_S);
pred12 = CheckAvailability(pred12,variables);

%% Reduction of time

old_n0 = pred1_n0;
old_N = pred1_N;

predTotal = {pred1,pred2,pred3,pred4,pred5,pred6,pred7,pred8,pred9,pred10,pred11,pred12};

%% PCA

[All_WSPD_bias,All_WSPD_rmse,All_WSPD_sde,All_WSPD_stdev,All_WSPD_nb_pca] = ResultatsPCR(predTotal,variables,target.WSPD,pred1_n0,pred1_N);
[All_ATMP_bias,All_ATMP_rmse,All_ATMP_sde,All_ATMP_stdev,All_ATMP_nb_pca] = ResultatsPCR(predTotal,variables,target.ATMP,pred1_n0,pred1_N);
[All_PRES_bias,All_PRES_rmse,All_PRES_sde,All_PRES_stdev,All_PRES_nb_pca] = ResultatsPCR(predTotal,variables,target.PRES,pred1_n0,pred1_N);

% Cas avec les variables WSPD/GST
[WSPD_bias,WSPD_rmse,WSPD_sde,WSPD_stdev,WSPD_nb_pca] = ResultatsPCR(predTotal,variables(1:2),target.WSPD,pred1_n0,pred1_N);

% Cas avec la variable ATMP
[ATMP_bias,ATMP_rmse,ATMP_sde,ATMP_stdev,ATMP_nb_pca] = ResultatsPCR(predTotal,variables(3),target.ATMP,pred1_n0,pred1_N);

% Cas avec la variable PRES
[PRES_bias,PRES_rmse,PRES_sde,PRES_stdev,PRES_nb_pca] = ResultatsPCR(predTotal,variables(4),target.PRES,pred1_n0,pred1_N);

%% PCAnEn

[All_mesures,All_nb_pca] = PCAnEn(predTotal,variables,target,M,Na,pred1_n0,pred1_N,ncores);

[WSPD_mesures,WSPD_nb_pca] = PCAnEn(predTotal,variables(1:2),target,M,Na,pred1_n0,pred1_N,ncores);

[ATMP_mesures,ATMP_nb_pca] = PCAnEn(predTotal,variables(3),target,M,Na,pred1_n0,pred1_N,ncores);

[PRES_mesures,PRES_nb_pca] = PCAnEn(predTotal,variables(4),target,M,Na,pred1_n0,pred1_N,ncores);

%% PCClustAnEn

[All_mesures2,All_nb_pca2] = PCClustAnEn(predTotal,variables,target,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores);

[WSPD_mesures2,WSPD_nb_pca2] = PCClustAnEn(predTotal,variables(1:2),target,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores);

[ATMP_mesures2,ATMP_nb_pca2] = PCClustAnEn(predTotal,variables(3),target,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores);

[PRES_mesures2,PRES_nb_pca2] = PCClustAnEn(predTotal,variables(4),target,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores);

%% Affichage

nbVariables = 4;
nbColonnes = 10;

indices = 1:nbColonnes;
donnees = [All_WSPD_stdev(1:10) WSPD_stdev(1:10) ATMP_stdev(1:10) [PRES_stdev(1:8);0;0]];

bar(indices,donnees,'grouped');
legende = cell(4,1);
legende{1} = 'All';
legende{2} = 'WSPD/GST';
legende{3} = 'ATMP';
legende{4} = 'PRES';
legend(legende);

xlabel('# Principal Components');
ylabel('Standard Deviation');

hold on
y1 = ones(1,10);
plot(indices,y1,'--');

