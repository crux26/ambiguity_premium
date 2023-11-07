function T_VIX = VIX_30Davg(CT, T_VarIX_1st, T_VarIX_2nd)

% 525600: The numberof minutes in a year (60*24*365)
NT1 = TTM4VIX(CT, T_VarIX_1st.DTM_CAL, T_VarIX_1st.isSTD) * 525600;
NT2 = TTM4VIX(CT, T_VarIX_2nd.DTM_CAL, T_VarIX_2nd.isSTD) * 525600;
N30 = 30*1440;      % #(minutes in 30D)
N365 = 365*1440;    % #(minutes in 365D)

%%
VIX = nan(size(T_VarIX_1st, 1), 1);
isExdateEqual = bsxfun(@eq, NT1, NT2);

% ~isEdateEqual: NT1 ~= NT2
% N30 need not be in [NT1, NT2]
VIX(~isExdateEqual) = 100 * sqrt( ( T_VarIX_1st.TTM(~isExdateEqual) .* T_VarIX_1st.VarIX(~isExdateEqual) ...
    .* (NT2(~isExdateEqual)-N30)./(NT2(~isExdateEqual)-NT1(~isExdateEqual)) + ...
    T_VarIX_2nd.TTM(~isExdateEqual) .* T_VarIX_2nd.VarIX(~isExdateEqual) ...
    .* (N30-NT1(~isExdateEqual))./(NT2(~isExdateEqual)-NT1(~isExdateEqual))  ) .* N365./N30 );

% NT1 == NT2
VIX(isExdateEqual) = 100 * sqrt(  T_VarIX_1st.TTM(isExdateEqual) .* T_VarIX_1st.VarIX(isExdateEqual)  .* N365./N30 );

%
date_ = T_VarIX_1st.date;
exdate_1st = T_VarIX_1st.exdate;
exdate_2nd = T_VarIX_2nd.exdate;
TTM_avg = 0.5 * (T_VarIX_1st.TTM + T_VarIX_2nd.TTM) ;
DTM_BUS_avg = 0.5 * (T_VarIX_1st.DTM_BUS + T_VarIX_2nd.DTM_BUS);
DTM_CAL_avg = 0.5 * (T_VarIX_1st.DTM_CAL + T_VarIX_2nd.DTM_CAL);

DTM_BUS_wavg = zeros(size(DTM_BUS_avg));
DTM_CAL_wavg = zeros(size(DTM_CAL_avg));

DTM_BUS_wavg(~isExdateEqual) = T_VarIX_1st.DTM_BUS(~isExdateEqual) .* (NT2(~isExdateEqual)-N30)./(NT2(~isExdateEqual)-NT1(~isExdateEqual)) ...
    + T_VarIX_2nd.DTM_BUS(~isExdateEqual) .* (N30-NT1(~isExdateEqual))./(NT2(~isExdateEqual)-NT1(~isExdateEqual));
DTM_CAL_wavg(~isExdateEqual) = T_VarIX_1st.DTM_CAL(~isExdateEqual) .* (NT2(~isExdateEqual)-N30)./(NT2(~isExdateEqual)-NT1(~isExdateEqual)) ...
    + T_VarIX_2nd.DTM_CAL(~isExdateEqual) .* (N30-NT1(~isExdateEqual))./(NT2(~isExdateEqual)-NT1(~isExdateEqual));

% DTM_BUS, DTM_CAL same for T_1st, T_2nd
DTM_BUS_wavg(isExdateEqual) = T_VarIX_1st.DTM_BUS(isExdateEqual);
DTM_CAL_wavg(isExdateEqual) = T_VarIX_1st.DTM_CAL(isExdateEqual);


T_VIX = table(date_, exdate_1st, exdate_2nd, VIX, TTM_avg,  ...
    DTM_BUS_avg, DTM_CAL_avg, DTM_BUS_wavg, DTM_CAL_wavg, isExdateEqual, ...
    'VariableNames', {'date', 'exdate_1st', 'exdate_2nd', 'VIX', 'TTM_avg', ...
    'DTM_BUS_avg', 'DTM_CAL_avg', 'DTM_BUS_wavg', 'DTM_CAL_wavg', 'isExdateEqual'});
