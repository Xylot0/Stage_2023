function [tablee,validHours,name1] = LoadStation(name,variables,interp,start_of_date,end_of_date,time_interval,startH,startM,startS,endH,endM,endS)

T = table;
for i=1:length(name)
    tableint = readtable(name(i),'VariableNamingRule','preserve');
    T = vertcat(T,tableint);
end

% Ajouter les colonnes correspondant à l'instant de la mesure
data_t = datetime(T{:,1},T{:,2},T{:,3},T{:,4},T{:,5},0);
tablee = table(data_t);
name1 = {};

for i=1:length(variables)
    indice = find(strcmp(T.Properties.VariableNames,variables(i)));
    var = table2array(T(:,indice));
    if sum(contains(["WSPD","GST","WVHT","DPD","APD","WTMP","VIS","TIDE"],variables(i))) > 0
        var(var == 99) = nan;
    end
    if sum(contains(["WDIR","MWD","ATMP","DEWP"],variables(i))) > 0
        var(var == 999) = nan;
    end
    if sum(contains("PRES", variables(i))) > 0
        var(var == 9999) = nan;
    end
    varModifiee = array2table(var);
    name1{i} = char(variables(i) + extractBetween(name(1),13,15));
    varModifiee.Properties.VariableNames = {char(variables(i))};
    tablee = horzcat(tablee,varModifiee);
end

if interp
    for i=1:length(variables)
        [tablee,validHours] = InterpolateData(tablee,start_of_date,end_of_date,variables(i),time_interval,startH,startM,startS,endH,endM,endS);

    end
end
end