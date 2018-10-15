%% VIX calculation - manual: returns 13.5954. However, main() returns 6.4965.
% date==729036, exdate1, exdate2 = [729044, 729072]
% uses the same input.
clear; clc;

CT = '15:00:00';  % fix the Current Time.

T_VarIX_1st = [729036,729044,0.0163813978149138,0.0211757990867580,6,8,1];
T_VarIX_1st = array2table(T_VarIX_1st);
T_VarIX_1st.Properties.VariableNames = {'date', 'exdate', 'VarIX', 'TTM', 'DTM_BUS', 'DTM_CAL', 'isSTD'};

T_VarIX_2nd = [729036,729072,0.0186005091269558,0.0978881278538813,26,36,1];
T_VarIX_2nd = array2table(T_VarIX_2nd);
T_VarIX_2nd.Properties.VariableNames = {'date', 'exdate', 'VarIX', 'TTM', 'DTM_BUS', 'DTM_CAL', 'isSTD'};

%% [NT1, NT2, N30, N365] = [11130, 51450, 43200, 525600]
NT1 = TTM4VIX(CT, T_VarIX_1st.DTM_CAL, T_VarIX_1st.isSTD) * 525600;
NT2 = TTM4VIX(CT, T_VarIX_2nd.DTM_CAL, T_VarIX_2nd.isSTD) * 525600;
N30 = 30*1440;      % #(minutes in 30D)
N365 = 365*1440;    % #(minutes in 365D)

%% Must change this into interp1(), to do extrap as well.
isExdateEqual = bsxfun(@eq, NT1, NT2);  
if ~isExdateEqual   % if NT1 ~= NT2
    VIX = 100 * sqrt( ( T_VarIX_1st.TTM .* T_VarIX_1st.VarIX .* (NT2-N30)./(NT2-NT1) + ...
        T_VarIX_2nd.TTM .* T_VarIX_2nd.VarIX .* (N30-NT1)./(NT2-NT1)  ) .* ...
        N365./N30 );
else % NT1 == NT2
    VIX = 100 * sqrt(  T_VarIX_1st.TTM .* T_VarIX_1st.VarIX  .* N365./N30 );
end

%%
VIX2 = VIX_30Davg(CT, T_VarIX_1st, T_VarIX_2nd);
