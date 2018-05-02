%% main(), main_bid(), main_ask() --> main2()
clear;clc;
isDorm = false;
if isDorm == true
    drive='F:';
else
    drive='D:';
end

homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\main_functions', homeDirectory));

OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);

load(sprintf('%s\\raw_tfz_dly_ts2.mat', OptionsData_genData_path), 'table_');
T_tfz_dly_ts2 = table_;
T_tfz_dly_ts2 = sortrows(T_tfz_dly_ts2, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.

load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path));



%%
load('VIX_gen'); VIX_mid = VIX.VIX * 0.01;
load('VIX_bid_gen'); VIX_bid = VIX.VIX * 0.01;
load('VIX_ask_gen'); VIX_ask = VIX.VIX * 0.01;

VIX = table(VarIX_1st.date, datestr(VarIX_1st.date), VIX_bid, VIX_mid, VIX_ask, ...
    'VariableNames', {'date', 'datestr', 'VIX_bid', 'VIX_mid', 'VIX_ask'});
VIX.VIXSpread = VIX_ask - VIX_bid;
[~, VIX.dayname] = weekday(VIX.date);

%% Plotting VIXSpread and others

% figure;
% plot(VIX.date, VIX.VIXSpread);
% legend('VIX Spread');
% xlim([VIX.date(1)-200, VIX.date(end)+200]);
% ylim auto;
% datetick('x', 12, 'keepticks', 'keeplimits');
% 
% figure;
% plot(VIX.date, VIX.VIX_bid, VIX.date, VIX.VIX_mid, VIX.date, VIX.VIX_ask);
% legend('VIX bid', 'VIX mid', 'VIX ask');
% xlim([VIX.date(1)-200, VIX.date(end)+200]);
% ylim auto;
% datetick('x', 12, 'keepticks', 'keeplimits');

%% 
a = sortrows(VIX, 6);   % 6-th col.: VIXSpread