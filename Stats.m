%% Simple stats of 1st-/2nd-month maturing options --> goto SAS
%% Problem: MATLAB Tables only admit "NaN", which causes trouble in SAS.
%% Solution: Manipulate PROC IMPORT in SAS (not here).
%% Extract near-/next-term only, the 2 closest to 30D.
clear;clc;
isDorm = false;
if isDorm == true
    drive='F:';
else
    drive='D:';
end
homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\data\\codes\\functions', homeDirectory));
OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);

load(sprintf('%s\\rawData_VIX', genData_path));

% Below takes: 60s (LAB PC)
tic;
CallData.date = datestr(CallData.date); CallData.exdate = datestr(CallData.exdate);
CallData_1st.date = datestr(CallData_1st.date); CallData_1st.exdate = datestr(CallData_1st.exdate);
CallData_2nd.date = datestr(CallData_2nd.date); CallData_2nd.exdate = datestr(CallData_2nd.exdate);

PutData.date = datestr(PutData.date); PutData.exdate = datestr(PutData.exdate);
PutData_1st.date = datestr(PutData_1st.date); PutData_1st.exdate = datestr(PutData_1st.exdate);
PutData_2nd.date = datestr(PutData_2nd.date); PutData_2nd.exdate = datestr(PutData_2nd.exdate);
toc;

CallData.symbol = []; PutData.symbol = []; 

%% Select 1st month only
[idx_C, ~] = ismember([CallData.date, CallData.exdate, CallData.Kc], ...
    [CallData_1st.date, CallData_1st.exdate, CallData_1st.Kc], 'rows');

CallData_1st_Full = CallData(idx_C, :);

[idx_P, ~] = ismember([PutData.date, PutData.exdate, PutData.Kp], ...
    [PutData_1st.date, PutData_1st.exdate, PutData_1st.Kp], 'rows');

PutData_1st_Full = PutData(idx_P, :);

%% Select 2nd month only
[idx_C, ~] = ismember([CallData.date, CallData.exdate, CallData.Kc], ...
    [CallData_2nd.date, CallData_2nd.exdate, CallData_2nd.Kc], 'rows');

CallData_2nd_Full = CallData(idx_C, :);

[idx_P, ~] = ismember([PutData.date, PutData.exdate, PutData.Kp], ...
    [PutData_2nd.date, PutData_2nd.exdate, PutData_2nd.Kp], 'rows');

PutData_2nd_Full = PutData(idx_P, :);

%% re-calculate moneyness: from spot moneyness to forward moneyness
%% This is different from VIX calculation, but will be similar enough
CallData_1st_Full.moneyness = CallData_1st_Full.S .* exp(CallData_1st_Full.r .* CallData_1st_Full.TTM) ./ CallData_1st_Full.Kc;
CallData_2nd_Full.moneyness = CallData_2nd_Full.S .* exp(CallData_2nd_Full.r .* CallData_2nd_Full.TTM) ./ CallData_2nd_Full.Kc;

PutData_1st_Full.moneyness = PutData_1st_Full.S .* exp(PutData_1st_Full.r .* PutData_1st_Full.TTM) ./ PutData_1st_Full.Kp;
PutData_2nd_Full.moneyness = PutData_2nd_Full.S .* exp(PutData_2nd_Full.r .* PutData_2nd_Full.TTM) ./ PutData_2nd_Full.Kp;

%% Exclude ITM
% moneyness: <=1 for call, >=1 for put
CallData_1st_OTM = CallData_1st_Full( CallData_1st_Full.moneyness <= 1, :);
CallData_2nd_OTM = CallData_2nd_Full( CallData_2nd_Full.moneyness <= 1, :);

PutData_1st_OTM = PutData_1st_Full( PutData_1st_Full.moneyness >= 1, :);
PutData_2nd_OTM = PutData_2nd_Full( PutData_2nd_Full.moneyness >= 1, :);

%% Merge T_CallData, T_PutData: C, P distinguishment is not needed anymore
CallData_1st_OTM.Properties.VariableNames{'Kc'} = 'K';
CallData_1st_OTM.Properties.VariableNames{'C'} = 'price';
CallData_2nd_OTM.Properties.VariableNames{'Kc'} = 'K';
CallData_2nd_OTM.Properties.VariableNames{'C'} = 'price';

PutData_1st_OTM.Properties.VariableNames{'Kp'} = 'K';
PutData_1st_OTM.Properties.VariableNames{'P'} = 'price';
PutData_2nd_OTM.Properties.VariableNames{'Kp'} = 'K';
PutData_2nd_OTM.Properties.VariableNames{'P'} = 'price';

% cpflag: 0 for call, 1 for put
OpData_1st_OTM = [CallData_1st_OTM; PutData_1st_OTM];
OpData_2nd_OTM = [CallData_2nd_OTM; PutData_2nd_OTM];

%------------------------------------------------------------
CallData_1st_Full.Properties.VariableNames{'Kc'} = 'K';
CallData_1st_Full.Properties.VariableNames{'C'} = 'price';
CallData_2nd_Full.Properties.VariableNames{'Kc'} = 'K';
CallData_2nd_Full.Properties.VariableNames{'C'} = 'price';

PutData_1st_Full.Properties.VariableNames{'Kp'} = 'K';
PutData_1st_Full.Properties.VariableNames{'P'} = 'price';
PutData_2nd_Full.Properties.VariableNames{'Kp'} = 'K';
PutData_2nd_Full.Properties.VariableNames{'P'} = 'price';

% cpflag: 0 for call, 1 for put
OpData_1st_Full = [CallData_1st_Full; PutData_1st_Full];
OpData_2nd_Full = [CallData_2nd_Full; PutData_2nd_Full];

%% Export tables
writetable(CallData_1st_Full, sprintf('%s\\CallData_1st_Full.csv', genData_path) );
writetable(CallData_2nd_Full, sprintf('%s\\CallData_2nd_Full.csv', genData_path) );

writetable(PutData_1st_Full, sprintf('%s\\PutData_1st_Full.csv', genData_path) );
writetable(PutData_2nd_Full, sprintf('%s\\PutData_2nd_Full.csv', genData_path) );

writetable(OpData_1st_Full, sprintf('%s\\OpData_1st_Full.csv', genData_path) );
writetable(OpData_2nd_Full, sprintf('%s\\OpData_2nd_Full.csv', genData_path) );

%
writetable(CallData_1st_OTM, sprintf('%s\\CallData_1st_OTM.csv', genData_path) );
writetable(CallData_2nd_OTM, sprintf('%s\\CallData_2nd_OTM.csv', genData_path) );

writetable(PutData_1st_OTM, sprintf('%s\\PutData_1st_OTM.csv', genData_path) );
writetable(PutData_2nd_OTM, sprintf('%s\\PutData_2nd_OTM.csv', genData_path) );

writetable(OpData_1st_OTM, sprintf('%s\\OpData_1st_OTM.csv', genData_path) );
writetable(OpData_2nd_OTM, sprintf('%s\\OpData_2nd_OTM.csv', genData_path) );

%% Just goto SAS for Descriptive Stats

%% Simple stats
% Below takes: 60s (LAB PC)
% tic;
% OpData_1st_OTM.TTM_BUS = daysdif(OpData_1st_OTM.date, OpData_1st_OTM.exdate, 13);
% OpData_2nd_OTM.TTM_BUS = daysdif(OpData_2nd_OTM.date, OpData_2nd_OTM.exdate, 13);
% toc;
% 
% grp1 = {'IV', 'cpflag', 'TTM_BUS'};
% grp2 = ['volume', 'open_interest', grp1];
% grp3 = [grp2, 'IV', 'delta', 'gamma', 'vega', 'theta', 'cpflag', 'TTM_BUS'];
% 
% T1 = OpData_1st_OTM(:, grp1);
% T2 = OpData_1st_OTM(:, grp2);
% T3 = OpData_1st_OTM(:, grp3);
% 
% % range: max - min
% Stats_grp1 = grpstats(T1, {'cpflag', 'TTM_BUS'}, {'min', 'mean', 'max', 'range'});
% writetable(Stats_grp1, 'C:\\Users\\EG.Y\\Desktop\\stats\\Stats_grp1.csv');