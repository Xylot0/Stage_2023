function [tablee,validHours] = InterpolateData(tablee,start_of_date, end_of_date,v,time_interval,start_H,start_M,start_S,end_H,end_M,end_S)

data_t = (start_of_date:minutes(time_interval):end_of_date)';
table_date = table(data_t);
tablee = outerjoin(table_date,tablee,'Type','left','MergeKeys', true);
[~, index] = unique(tablee.data_t);
tablee = tablee(index,:);
tablee.(v) = fillmissing(tablee.(v),'linear','MaxGap', 4);

% Déterminer les mesures valides
[h_1,m_1,s_1] = hms(tablee.data_t);
SupStart = (h_1 > start_H) | ( (h_1 == start_H) & (m_1 > start_M)) | ((h_1 == start_H) & (m_1 == start_M) & (s_1 >= start_S));
InfEnd = (h_1 < end_H) | ( (h_1 == end_H) & (m_1 < end_M)) | ((h_1 == end_H) & (m_1 == end_M) & (s_1 <= end_S));
validHours =   SupStart & InfEnd;
tablee = tablee(validHours,:);

end