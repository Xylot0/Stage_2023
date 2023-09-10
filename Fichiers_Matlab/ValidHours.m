function predV = ValidHours(pred,start_H,start_M,start_S,end_H,end_M,end_S)

    % Déterminer les mesures valides
    [h_1,m_1,s_1] = hms(pred.data_t);
    SupStart = (h_1 > start_H) | ( (h_1 == start_H) & (m_1 > start_M)) | ((h_1 == start_H) & (m_1 == start_M) & (s_1 >= start_S));
    InfEnd = (h_1 < end_H) | ( (h_1 == end_H) & (m_1 < end_M)) | ((h_1 == end_H) & (m_1 == end_M) & (s_1 <= end_S));
    validHours =   SupStart & InfEnd;
    predV = pred(validHours,:);

end