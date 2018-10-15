%% Before the introduction of SPX Weeklys on 2014, using scaled VarIX_2nd only for VIX returns far much better result.
%% So will just use that value.
%% main(), main_bid(), main_ask() --> main2(): Goto SAS.

%% Details for SPXW
% Though VIX white paper says an inclusion of SPXW is 2014, it is not.

% SPXW Friday Weeklys (EOW) started at 28OCT2005.
% SPXW Monday, Wednesday introduced on 23FEB2016, 15AUG2016, respectively.

% SPXW PM-settled (on 3rd Fri) intorduced on 10OCT2011.
% SPXPM has secid=150513 before 01May2017, and changed from SPXPM to SPXW.

% SPX EOM introduced on 07JUL2014.

% On 31May2012, SPXW Friday Weeklys issued up to 5 consecutive weeks.

% Checked that my VIX tracks CBOE VIX close enough after 30MAY2012 (exclusive).
% Hence, will use that date for cutoff.

%% VIX_mid, VIX_bid, VIX_ask, respectively.
clear;clc;
isDorm = 1;
if isDorm == true
    drive='E:';
else
    drive='E:';
end

homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\main_functions', homeDirectory));

% OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);
% 
% load(sprintf('%s\\raw_tfz_dly_ts2.mat', OptionsData_genData_path), 'table_');
% T_tfz_dly_ts2 = table_;
% T_tfz_dly_ts2 = sortrows(T_tfz_dly_ts2, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.
% 
% load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path));
load('E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.mat', 'VIX'); CBOE_VIX = VIX;
clear VIX;
%% Any further procedures will de done in SAS.
%% Will substitute scaled VIX_2nd to VIX before SPX Weeklys inclusion date.
%% -> Scaled VIX_2nd returns larger error. Will just use the VIX_2nd level.
% date_SPXW_beg = datenum('31may2012');

%% VIX_mid
load(sprintf('%s\\VIX_gen', genData_path), 'VIX', 'VarIX_1st', 'VarIX_2nd');
date_intersection = intersect(CBOE_VIX.date, VIX.date);
VIX = VIX(ismember(VIX.date, date_intersection), :);
VIX.date = datestr(VIX.date);
VIX.exdate_1st = datestr(VIX.exdate_1st); VIX.exdate_2nd = datestr(VIX.exdate_2nd);

% VarIX_1st = VarIX_1st(ismember(VarIX_1st.date, date_intersection), :);
% VarIX_2nd = VarIX_2nd(ismember(VarIX_2nd.date, date_intersection), :);
% VIX.VIX_1st = sqrt(VarIX_1st.VarIX) * 100; VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX) * 100;
% idx = find(datenum(VIX.date) < date_SPXW_beg);
% VIX.VIX(idx) = VIX.VIX_2nd(idx);

writetable(VIX, sprintf('%s\\VIX_mid.csv', genData_path));
clear VIX VarIX_1st VarIX_2nd;

%% VIX_bid
load(sprintf('%s\\VIX_bid_gen', genData_path), 'VIX', 'VarIX_1st', 'VarIX_2nd');
date_intersection = intersect(CBOE_VIX.date, VIX.date);
VIX = VIX(ismember(VIX.date, date_intersection), :);
VIX.date = datestr(VIX.date);
VIX.exdate_1st = datestr(VIX.exdate_1st); VIX.exdate_2nd = datestr(VIX.exdate_2nd);

% VarIX_1st = VarIX_1st(ismember(VarIX_1st.date, date_intersection), :);
% VarIX_2nd = VarIX_2nd(ismember(VarIX_2nd.date, date_intersection), :);
% VIX.VIX_1st = sqrt(VarIX_1st.VarIX) * 100; VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX) * 100;
% idx = find(datenum(VIX.date) < date_SPXW_beg);
% VIX.VIX(idx) = VIX.VIX_2nd(idx);

writetable(VIX, sprintf('%s\\VIX_bid.csv', genData_path));
clear VIX VarIX_1st VarIX_2nd;

%% VIX_ask
load(sprintf('%s\\VIX_ask_gen', genData_path), 'VIX', 'VarIX_1st', 'VarIX_2nd');
date_intersection = intersect(CBOE_VIX.date, VIX.date);
VIX = VIX(ismember(VIX.date, date_intersection), :);
VIX.date = datestr(VIX.date);
VIX.exdate_1st = datestr(VIX.exdate_1st); VIX.exdate_2nd = datestr(VIX.exdate_2nd);

% VarIX_1st = VarIX_1st(ismember(VarIX_1st.date, date_intersection), :);
% VarIX_2nd = VarIX_2nd(ismember(VarIX_2nd.date, date_intersection), :);
% VIX.VIX_1st = sqrt(VarIX_1st.VarIX) * 100; VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX) * 100;
% idx = find(datenum(VIX.date) < date_SPXW_beg);
% VIX.VIX(idx) = VIX.VIX_2nd(idx);

writetable(VIX, sprintf('%s\\VIX_ask.csv', genData_path));
clear VIX VarIX_1st VarIX_2nd;

%% Below codes are valid (just annotated)
%%
% load(sprintf('%s\\VIX_gen', genData_path)); VIX_mid = VIX.VIX * 0.01;
% load(sprintf('%s\\VIX_bid_gen', genData_path)); VIX_bid = VIX.VIX * 0.01;
% load(sprintf('%s\\VIX_ask_gen', genData_path)); VIX_ask = VIX.VIX * 0.01;
% 
% VIX = table(VarIX_1st.date, datestr(VarIX_1st.date), VIX_bid, VIX_mid, VIX_ask, ...
%     'VariableNames', {'date', 'datestr', 'VIX_bid', 'VIX_mid', 'VIX_ask'});
% VIX.VIXSpread = VIX_ask - VIX_bid;
% [~, VIX.dayname] = weekday(VIX.date);

%% Plotting VIXSpread and others

% figure;
% plot(VIX.date, VIX.VIXSpread);
% grid on;
% legend('VIX Spread');
% xlim([VIX.date(1)-200, VIX.date(end)+200]);
% ylim auto;
% datetick('x', 12, 'keepticks', 'keeplimits');
% 
% figure;
% plot(VIX.date, VIX.VIX_bid, VIX.date, VIX.VIX_mid, VIX.date, VIX.VIX_ask); 
% grid on;
% legend('VIX bid', 'VIX mid', 'VIX ask');
% xlim([VIX.date(1)-200, VIX.date(end)+200]);
% ylim auto;
% datetick('x', 12, 'keepticks', 'keeplimits');

%% 
% a = sortrows(VIX, 6);   % 6-th col.: VIXSpread
