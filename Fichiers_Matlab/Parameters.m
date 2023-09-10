%% Parameters

M = 5; % Size of vector
Na = 150; % Number of analogues
ncores = 16;
nb_centres = 366;
nb_iterations = 400;

prediction_t0 = datetime('2021-01-01 10:00:00');
start_of_date = datetime('2016-01-01 00:00:00');
start_H = 10;
start_M = 0;
start_S = 0;

end_of_date = datetime('2021-12-31 23:30:00');
end_H = 16;
end_M = 0;
end_S = 0;

time_interval = 6;

interp = true;

% v.un = "WSPD";
% v.deux = "GST";
% v.trois = "ATMP";
% v.quatre = "PRES";

% variables = ["WSPD","GST","ATMP","PRES"];
% variables = ["WSPD","GST"];
variables = ["ATMP"];
% variables = ["PRES"];
aim = "ATMP";
nb_LV = 4;
nb_var = length(variables);
nb_stations = 12;

% Method
method = "PCR";
with_pca = false;
with_pls = true;

%% Weather station data 

% WSPD and GST
name_target_2016 = "../stations/ppxc1h2016.txt";
name_target_2017 = "../stations/ppxc1h2017.txt";
name_target_2018 = "../stations/ppxc1h2018.txt";
name_target_2019 = "../stations/ppxc1h2019.txt";
name_target_2020 = "../stations/ppxc1h2020.txt";
name_target_2021 = "../stations/ppxc1h2021.txt";

name_target = [name_target_2016, name_target_2017, name_target_2018, name_target_2019, name_target_2020, name_target_2021];

name_pred1_2016 = "../stations/aamc1h2016.txt";
name_pred1_2017 = "../stations/aamc1h2017.txt";
name_pred1_2018 = "../stations/aamc1h2018.txt";
name_pred1_2019 = "../stations/aamc1h2019.txt";
name_pred1_2020 = "../stations/aamc1h2020.txt";
name_pred1_2021 = "../stations/aamc1h2021.txt";

name_pred1 = [name_pred1_2016, name_pred1_2017, name_pred1_2018, name_pred1_2019, name_pred1_2020, name_pred1_2021];

name_pred2_2016 = "../stations/dpxc1h2016.txt";
name_pred2_2017 = "../stations/dpxc1h2017.txt";
name_pred2_2018 = "../stations/dpxc1h2018.txt";
name_pred2_2019 = "../stations/dpxc1h2019.txt";
name_pred2_2020 = "../stations/dpxc1h2020.txt";
name_pred2_2021 = "../stations/dpxc1h2021.txt";

name_pred2 = [name_pred2_2016, name_pred2_2017, name_pred2_2018, name_pred2_2019, name_pred2_2020, name_pred2_2021];

name_pred3_2016 = "../stations/ftpc1h2016.txt";
name_pred3_2017 = "../stations/ftpc1h2017.txt";
name_pred3_2018 = "../stations/ftpc1h2018.txt";
name_pred3_2019 = "../stations/ftpc1h2019.txt";
name_pred3_2020 = "../stations/ftpc1h2020.txt";
name_pred3_2021 = "../stations/ftpc1h2021.txt";

name_pred3 = [name_pred3_2016, name_pred3_2017, name_pred3_2018, name_pred3_2019, name_pred3_2020, name_pred3_2021];

name_pred4_2016 = "../stations/lndc1h2016.txt";
name_pred4_2017 = "../stations/lndc1h2017.txt";
name_pred4_2018 = "../stations/lndc1h2018.txt";
name_pred4_2019 = "../stations/lndc1h2019.txt";
name_pred4_2020 = "../stations/lndc1h2020.txt";
name_pred4_2021 = "../stations/lndc1h2021.txt";

name_pred4 = [name_pred4_2016, name_pred4_2017, name_pred4_2018, name_pred4_2019, name_pred4_2020, name_pred4_2021];

name_pred5_2016 = "../stations/obxc1h2016.txt";
name_pred5_2017 = "../stations/obxc1h2017.txt";
name_pred5_2018 = "../stations/obxc1h2018.txt";
name_pred5_2019 = "../stations/obxc1h2019.txt";
name_pred5_2020 = "../stations/obxc1h2020.txt";
name_pred5_2021 = "../stations/obxc1h2021.txt";

name_pred5 = [name_pred5_2016, name_pred5_2017, name_pred5_2018, name_pred5_2019, name_pred5_2020, name_pred5_2021];

name_pred6_2016 = "../stations/omhc1h2016.txt";
name_pred6_2017 = "../stations/omhc1h2017.txt";
name_pred6_2018 = "../stations/omhc1h2018.txt";
name_pred6_2019 = "../stations/omhc1h2019.txt";
name_pred6_2020 = "../stations/omhc1h2020.txt";
name_pred6_2021 = "../stations/omhc1h2021.txt";

name_pred6 = [name_pred6_2016, name_pred6_2017, name_pred6_2018, name_pred6_2019, name_pred6_2020, name_pred6_2021];

name_pred7_2016 = "../stations/pcoc1h2016.txt";
name_pred7_2017 = "../stations/pcoc1h2017.txt";
name_pred7_2018 = "../stations/pcoc1h2018.txt";
name_pred7_2019 = "../stations/pcoc1h2019.txt";
name_pred7_2020 = "../stations/pcoc1h2020.txt";
name_pred7_2021 = "../stations/pcoc1h2021.txt";

name_pred7 = [name_pred7_2016, name_pred7_2017, name_pred7_2018, name_pred7_2019, name_pred7_2020, name_pred7_2021];

name_pred8_2016 = "../stations/psbc1h2016.txt";
name_pred8_2017 = "../stations/psbc1h2017.txt";
name_pred8_2018 = "../stations/psbc1h2018.txt";
name_pred8_2019 = "../stations/psbc1h2019.txt";
name_pred8_2020 = "../stations/psbc1h2020.txt";
name_pred8_2021 = "../stations/psbc1h2021.txt";

name_pred8 = [name_pred8_2016, name_pred8_2017, name_pred8_2018, name_pred8_2019, name_pred8_2020, name_pred8_2021];

name_pred9_2016 = "../stations/pxoc1h2016.txt";
name_pred9_2017 = "../stations/pxoc1h2017.txt";
name_pred9_2018 = "../stations/pxoc1h2018.txt";
name_pred9_2019 = "../stations/pxoc1h2019.txt";
name_pred9_2020 = "../stations/pxoc1h2020.txt";
name_pred9_2021 = "../stations/pxoc1h2021.txt";

name_pred9 = [name_pred9_2016, name_pred9_2017, name_pred9_2018, name_pred9_2019, name_pred9_2020, name_pred9_2021];

name_pred10_2016 = "../stations/pxsc1h2016.txt";
name_pred10_2017 = "../stations/pxsc1h2017.txt";
name_pred10_2018 = "../stations/pxsc1h2018.txt";
name_pred10_2019 = "../stations/pxsc1h2019.txt";
name_pred10_2020 = "../stations/pxsc1h2020.txt";
name_pred10_2021 = "../stations/pxsc1h2021.txt";

name_pred10 = [name_pred10_2016, name_pred10_2017, name_pred10_2018, name_pred10_2019, name_pred10_2020, name_pred10_2021];

name_pred11_2016 = "../stations/rcmc1h2016.txt";
name_pred11_2017 = "../stations/rcmc1h2017.txt";
name_pred11_2018 = "../stations/rcmc1h2018.txt";
name_pred11_2019 = "../stations/rcmc1h2019.txt";
name_pred11_2020 = "../stations/rcmc1h2020.txt";
name_pred11_2021 = "../stations/rcmc1h2021.txt";

name_pred11 = [name_pred11_2016, name_pred11_2017, name_pred11_2018, name_pred11_2019, name_pred11_2020, name_pred11_2021];

name_pred12_2016 = "../stations/rtyc1h2016.txt";
name_pred12_2017 = "../stations/rtyc1h2017.txt";
name_pred12_2018 = "../stations/rtyc1h2018.txt";
name_pred12_2019 = "../stations/rtyc1h2019.txt";
name_pred12_2020 = "../stations/rtyc1h2020.txt";
name_pred12_2021 = "../stations/rtyc1h2021.txt";

name_pred12 = [name_pred12_2016, name_pred12_2017, name_pred12_2018, name_pred12_2019, name_pred12_2020, name_pred12_2021];

name_pred = {name_pred1,name_pred2,name_pred3,name_pred4,name_pred5,name_pred6,name_pred7,name_pred8,name_pred9,name_pred10,name_pred11,name_pred12,name_target};


