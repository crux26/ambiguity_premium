function T_VIX = VIX_30Davg(CT, T_VarIX_1st, T_VarIX_2nd)

NT1 = TTM4VIX(CT, T_VarIX_1st.DTM_CAL, T_VarIX_1st.isSTD);
NT2 = TTM4VIX(CT, T_VarIX_2nd.DTM_CAL, T_VarIX_2nd.isSTD);
N30 = 30*1440;      % #(minutes in 30D)
N365 = 365*1440;    % #(minutes in 365D)

isExdateEqual = bsxfun(@eq, NT1, NT2);  
if ~isExdateEqual   % if NT1 ~= NT2
    VIX = 100 * sqrt( ( T_VarIX_1st.TTM .* T_VarIX_1st.VarIX .* (NT2-N30)./(NT2-NT1) + ...
        T_VarIX_2nd.TTM .* T_VarIX_2nd.VarIX .* (N30-NT1)./(NT2-NT1)  ) .* ...
        N365./N30 );
else
    VIX = 100 * sqrt(  T_VarIX_1st.TTM .* T_VarIX_1st.VarIX  .* N365./N30 );
end

%
date_ = T_VarIX_1st.date;
exdate_1st = T_VarIX_1st.exdate;
exdate_2nd = T_VarIX_2nd.exdate;
TTM_avg = 0.5 * (T_VarIX_1st.TTM + T_VarIX_2nd.TTM) ;
DTM_BUS_avg = 0.5 * (T_VarIX_1st.DTM_BUS + T_VarIX_2nd.DTM_BUS);
DTM_CAL_avg = 0.5 * (T_VarIX_1st.DTM_CAL + T_VarIX_2nd.DTM_CAL);

T_VIX = table(date_, exdate_1st, exdate_2nd, VIX, TTM_avg, DTM_BUS_avg, DTM_CAL_avg, isExdateEqual, ...
    'VariableNames', {'date', 'exdate_1st', 'exdate_2nd', 'VIX', 'TTM_avg' ,'DTM_BUS_avg', 'DTM_CAL_avg', 'isExdateEqual'});