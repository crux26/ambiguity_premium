%% VIX_mid, VIX_bid, VIX_ask, respectively.
clear;clc;
isDorm = false;
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
load('E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.mat', 'VIX'); CBOE_VIX = VIX;

%% Any further procedures will de done in SAS.
%% Will substitute scaled VIX_2nd to VIX before SPX Weeklys inclusion date.
%% -> Scaled VIX_2nd returns larger error. Will just use the VIX_2nd level.
date_SPXW_beg = datenum('31may2012');

% writetable(VIX, sprintf('%s\\VIX_mid.csv', genData_path)); clear VIX VarIX_1st VarIX_2nd;

load(sprintf('%s\\VIX_bid_gen', genData_path));
date_intersection = intersect(CBOE_VIX.date, VIX.date);
VIX = VIX(ismember(VIX.date, date_intersection), :);
VarIX_1st = VarIX_1st(ismember(VarIX_1st.date, date_intersection), :);
VarIX_2nd = VarIX_2nd(ismember(VarIX_2nd.date, date_intersection), :);
VIX.VIX_1st = sqrt(VarIX_1st.VarIX) * 100; VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX) * 100;
idx = find((VIX.date) < date_SPXW_beg);
VIX.VIX(idx) = VIX.VIX_2nd(idx);
VIX_bid = VIX;

load(sprintf('%s\\VIX_ask_gen', genData_path));
date_intersection = intersect(CBOE_VIX.date, VIX.date);
VIX = VIX(ismember(VIX.date, date_intersection), :);
VarIX_1st = VarIX_1st(ismember(VarIX_1st.date, date_intersection), :);
VarIX_2nd = VarIX_2nd(ismember(VarIX_2nd.date, date_intersection), :);
VIX.VIX_1st = sqrt(VarIX_1st.VarIX) * 100; VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX) * 100;
idx = find((VIX.date) < date_SPXW_beg);
VIX.VIX(idx) = VIX.VIX_2nd(idx);
VIX_ask = VIX;

load(sprintf('%s\\VIX_gen', genData_path));
date_intersection = intersect(CBOE_VIX.date, VIX.date);
VIX = VIX(ismember(VIX.date, date_intersection), :);
VarIX_1st = VarIX_1st(ismember(VarIX_1st.date, date_intersection), :);
VarIX_2nd = VarIX_2nd(ismember(VarIX_2nd.date, date_intersection), :);
VIX.VIX_1st = sqrt(VarIX_1st.VarIX) * 100; VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX) * 100;
idx = find(datenum(VIX.date) < date_SPXW_beg);
VIX.VIX(idx) = VIX.VIX_2nd(idx);

CBOE_VIX = CBOE_VIX(ismember(CBOE_VIX.date, date_intersection), :);
%%
% [date_, ~] = unique(CBOE_VIX.date, 'rows');
% [date__, ~] = unique(VIX.date, 'rows');
% 
% date_intersect = intersect(date_, date__);
% idx_ = ismember(date_, date_intersect);
% idx__ = ismember(date__, date_intersect);
% 
% CBOE_VIX = CBOE_VIX(idx_, :);
% VIX = VIX(idx__, :);
% VIX_ask = VIX_ask(idx__, :);
% VIX_bid = VIX_bid(idx__, :);