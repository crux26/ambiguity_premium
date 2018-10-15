%% import_VIX() -> Cmpr_VIXs()
%% date: '04jan1996';
%% unTrimmed data returns closer result to CBOE VIX.
%% CBOE VIX seems not to adjust for irregular prices at tails. See the white paper.
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

OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);

load(sprintf('%s\\raw_tfz_dly_ts2.mat', OptionsData_genData_path), 'table_');
T_tfz_dly_ts2 = table_;
T_tfz_dly_ts2 = sortrows(T_tfz_dly_ts2, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.

% load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path));

load('E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.mat', 'VIX');
CBOE_VIX = VIX;
load(sprintf('%s\\VIX_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX'); % VIX_mid
VIX.VIX = VIX.VIX*0.01;
% load(sprintf('%s\\VIX_ask_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');
% VIX.VIX = VIX.VIX*0.01;
% load(sprintf('%s\\VIX_bid_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');
% VIX.VIX = VIX.VIX*0.01;

%%
% [date_, ~] = unique([CBOE_VIX.date, CBOE_VIX.exdate], 'rows');
% [date__, ~] = unique([VIX.date, VIX.exdate], 'rows');
[date_, ~] = unique(CBOE_VIX.date, 'rows');
[date__, ~] = unique(VIX.date, 'rows');

date_intersect = intersect(date_, date__);
idx_ = ismember(date_, date_intersect);
idx__ = ismember(date__, date_intersect);

CBOE_VIX = CBOE_VIX(idx_, :);
VIX = VIX(idx__, :);

%% On this date, abs(CBOE_VIX - my_VIX) >> 0
datenum_ = datenum('04jan1996');

%%
% load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path), 'CallData', 'PutData');
load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D.mat', genData_path), 'CallData', 'PutData');

CallData = CallData(CallData.date == datenum_, :);
PutData = PutData(PutData.date == datenum_, :);

%%
CBOE_VIX = CBOE_VIX(CBOE_VIX.date==datenum_, :);
VIX = VIX(VIX.date==datenum_, :);

%%
CT = '15:00:00';  % fix the Current Time.
jj=1;
[CallData_1st_, CallData_2nd_, PutData_1st_, PutData_2nd_, today_] = ...
    split2nearNnext(CallData, PutData);

[TTM_C_1st, TTM_P_1st] = deal(TTM4VIX(CT,  ...
    unique(CallData_1st_.exdate - CallData_1st_.date), unique(CallData_1st_.isSTD)));
[TTM_C_2nd, TTM_P_2nd] = deal(TTM4VIX(CT, ...
    unique(CallData_2nd_.exdate - CallData_2nd_.date), unique(CallData_2nd_.isSTD)));

CallData_1st_.TTM = TTM_C_1st*ones(size(CallData_1st_,1), 1); PutData_1st_.TTM = TTM_P_1st*ones(size(PutData_1st_,1), 1);
CallData_2nd_.TTM = TTM_C_2nd*ones(size(CallData_2nd_,1), 1); PutData_2nd_.TTM = TTM_P_2nd*ones(size(PutData_2nd_,1), 1);

[~, idx_today] = min(abs(today_ - T_tfz_dly_ts2.CALDT));
r_1st(jj) = match_Close2DTM(today_, T_tfz_dly_ts2.CALDT(idx_today), ...
    unique(CallData_1st_.DTM_BUS), T_tfz_dly_ts2.TDDURATN(idx_today), T_tfz_dly_ts2.TDYLD(idx_today));
r_2nd(jj) = match_Close2DTM(today_, T_tfz_dly_ts2.CALDT(idx_today), ...
    unique(CallData_2nd_.DTM_BUS), T_tfz_dly_ts2.TDDURATN(idx_today), T_tfz_dly_ts2.TDYLD(idx_today));

CallData_1st_.r = r_1st(jj)*ones(size(CallData_1st_, 1), 1);
CallData_2nd_.r = r_2nd(jj)*ones(size(CallData_2nd_, 1), 1);

PutData_1st_.r = r_1st(jj)*ones(size(PutData_1st_, 1), 1);
PutData_2nd_.r = r_2nd(jj)*ones(size(PutData_2nd_, 1), 1);

%%
[T_1st] = VIXrawVolCurve(PutData_1st_, CallData_1st_);
VarIX_1st = VIXConstruction(T_1st);

[T_2nd] = VIXrawVolCurve(PutData_2nd_, CallData_2nd_);
VarIX_2nd = VIXConstruction(T_2nd);
VIX_cal = VIX_30Davg(CT, VarIX_1st, VarIX_2nd);
