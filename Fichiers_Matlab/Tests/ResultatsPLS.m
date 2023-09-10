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

%% Cross-validation

[All_WSPD_RMSEP,All_WSPD_Q] = ResultatsPLSR3(predTotal,variables,target.WSPD,pred1_n0,pred1_N);
[All_ATMP_RMSEP,All_ATMP_Q] = ResultatsPLSR3(predTotal,variables,target.ATMP,pred1_n0,pred1_N);
[All_PRES_RMSEP,All_PRES_Q] = ResultatsPLSR3(predTotal,variables,target.PRES,pred1_n0,pred1_N);

[WSPD_RMSEP,WSPD_Q] = ResultatsPLSR3(predTotal,variables(1:2),target.WSPD,pred1_n0,pred1_N);
[ATMP_RMSEP,ATMP_Q] = ResultatsPLSR3(predTotal,variables(3),target.ATMP,pred1_n0,pred1_N);
[PRES_RMSEP,PRES_Q] = ResultatsPLSR3(predTotal,variables(4),target.PRES,pred1_n0,pred1_N);

% Affichage des courbes de RMSEP

subplot(1,2,1);
indices = 1:8;
semilogy(indices,WSPD_RMSEP,'r-s',indices,ATMP_RMSEP,'g-o',indices,PRES_RMSEP,'k-o');
xlabel('# Latent Variables');
ylabel('RMSEP');
ylim([0.001 1]);

subplot(1,2,2);
indices = 1:8;
semilogy(indices,All_WSPD_RMSEP,'r-s',indices,All_ATMP_RMSEP,'g-o',indices,All_PRES_RMSEP,'k-o');
xlabel('# Latent Variables');
ylabel('RMSEP');
ylim([0.001 1]);


% Affichage des courbes de Q
figure;

subplot(1,2,1);
nbColonnes = 7;

indices = 1:nbColonnes;
donnees = [WSPD_Q(2:8); ATMP_Q(2:8); PRES_Q(2:8)];

bar(indices,donnees,'grouped');
legende = cell(3,1);
legende{1} = 'WSPD/GST';
legende{2} = 'ATMP';
legende{3} = 'PRES';
legend(legende);

xlabel('# Latent Variables');
ylabel('Q²');

hold on
y1 = ones(1,7)*0.0975;
plot(indices,y1,'--');


subplot(1,2,2);
nbVariables = 3;
nbColonnes = 7;

indices = 1:nbColonnes;
donnees = [All_WSPD_Q(2:8); All_ATMP_Q(2:8); All_PRES_Q(2:8)];

bar(indices,donnees,'grouped');
legende = cell(3,1);
legende{1} = 'WSPD/GST';
legende{2} = 'ATMP';
legende{3} = 'PRES';
legend(legende);

xlabel('# Latent Variables');
ylabel('Q²');

hold on
y1 = ones(1,7)*0.0975;
plot(indices,y1,'--');

% Nombre de variables latentes à choisir pour chaque cas

All_WSPD_nb_LV = sum(All_WSPD_Q > 0.0975);
All_ATMP_nb_LV = sum(All_ATMP_Q > 0.0975);
All_PRES_nb_LV = sum(All_PRES_Q > 0.0975);
WSPD_nb_LV = sum(WSPD_Q > 0.0975);
ATMP_nb_LV = sum(ATMP_Q > 0.0975);
PRES_nb_LV = sum(PRES_Q > 0.0975);

%% PLSR

[All_WSPD_bias,All_WSPD_rmse,All_WSPD_sde] = ResultatsPLSR(predTotal,variables,target.WSPD,pred1_n0,pred1_N,3);
[ATMP_All_bias,ATMP_All_rmse,ATMP_All_sde] = ResultatsPLSR(predTotal,variables,target.ATMP,pred1_n0,pred1_N,4);
[PRES_All_bias,PRES_All_rmse,PRES_All_sde] = ResultatsPLSR(predTotal,variables,target.PRES,pred1_n0,pred1_N,6);

% Cas avec les variables WSPD/GST comme prédicteur
[WSPD_bias,WSPD_rmse,WSPD_sde] = ResultatsPLSR(predTotal,variables(1:2),target.WSPD,pred1_n0,pred1_N,3);

% Cas avec la variable ATMP comme prédicteur
[ATMP_bias,ATMP_rmse,ATMP_sde] = ResultatsPLSR(predTotal,variables(3),target.ATMP,pred1_n0,pred1_N,4);
 
% % Cas avec la variable PRES comme prédicteur
[PRES_bias,PRES_rmse,PRES_sde] = ResultatsPLSR(predTotal,variables(4),target.PRES,pred1_n0,pred1_N,4);

%% PLSAnEn

v.aim = "WSPD";
All_WSPD_mesures = PLSAnEn(predTotal,variables,target,v,M,Na,pred1_n0,pred1_N,ncores,3);
v.aim = "ATMP";
All_ATMP_mesures = PLSAnEn(predTotal,variables,target,v,M,Na,pred1_n0,pred1_N,ncores,4);
v.aim = "PRES";
All_PRES_mesures = PLSAnEn(predTotal,variables,target,v,M,Na,pred1_n0,pred1_N,ncores,6);

% v.aim = "WSPD";
% WSPD_mesures = PLSAnEn(predTotal,variables(1:2),target,v,M,Na,pred1_n0,pred1_N,ncores,2);
% v.aim = "ATMP";
% ATMP_mesures = PLSAnEn(predTotal,variables(3),target,v,M,Na,pred1_n0,pred1_N,ncores,4);
% v.aim = "PRES";
% PRES_mesures = PLSAnEn(predTotal,variables(4),target,v,M,Na,pred1_n0,pred1_N,ncores,4);

%% PLSClustAnEn

v.aim = "WSPD";
All_WSPD_mesures2 = PLSClustAnEn(predTotal,variables,target,v,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores,3);
v.aim = "ATMP";
All_ATMP_mesures2 = PLSClustAnEn(predTotal,variables,target,v,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores,3);
v.aim = "PRES";
All_PRES_mesures2 = PLSClustAnEn(predTotal,variables,target,v,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores,3);

v.aim = "WSPD";
WSPD_mesures2 = PLSClustAnEn(predTotal,variables(1:2),target,v,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores,3);
v.aim = "ATMP";
ATMP_mesures2 = PLSClustAnEn(predTotal,variables(3),target,v,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores,3);
v.aim = "PRES";
PRES_mesures2= PLSClustAnEn(predTotal,variables(4),target,v,M,Na,nb_iterations,nb_centres,pred1_n0,pred1_N,ncores,3);

