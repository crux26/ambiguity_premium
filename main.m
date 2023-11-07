%% main(), main_bid(), main_ask() --> main2() --> Goto SAS.
%% main() == main_mid()
%% Goal: bid-VIX, ask-VIX construction
%% VIX: near- (1st) and next-term (2nd) call/put options where 23D < TTM < 37D
% including "standard" 3rd Friday expiration and "weekly" SPX options that expire every Friday,
% except the 3rd Friday of each month

%% shorter TTM has more moneynesses: reason why size(T.CallData_1st, 1) > size(T.CallData_2nd, 1)

%% "Today": second Tue, Oct <-- assume Oct 8, 2013
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

load(sprintf('%s\\raw_tfz_dly_ts2.mat', OptionsData_genData_path), 'T_');
T_tfz_dly_ts2 = T_;
T_tfz_dly_ts2 = sortrows(T_tfz_dly_ts2, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.

% Refer to white paper: it seems not to adjust irregular prices at tails.
% load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path));
load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D.mat', genData_path));

%% Delete if isnan(tb_m3)
% Below takes: 0.29s (LAB PC)
tic;
idx_notNaN_C = find(~isnan(CallData.r));
CallData = CallData(idx_notNaN_C, :);
toc;

% Below takes: 0.29s (LAB PC)
tic;
idx_notNaN_P = find(~isnan(PutData.r));
PutData = PutData(idx_notNaN_P, :);
toc;

%% problematic dates
date_mid = [729202, 729953, 730758, 730926, 731171, 731444, 731598, 732053, 732235, 733276, 733367, 733549];
date_ask = [729453, 729998, 730758, 731171, 735945];
date_bid = [729202, 730758, 731171, 733600];
date_problematic = union(union(date_mid, date_ask), date_bid);

idx_date_C = ismember(CallData.date, date_problematic);
CallData = CallData(~idx_date_C, :);
idx_date_P = ismember(PutData.date, date_problematic);
PutData = PutData(~idx_date_P, :);

clear date_mid date_ask date_bid date_problematic;

%% Use only the intersection of CallData & PutData.
[date_, ~] = unique([CallData.date, CallData.exdate], 'rows');
[date__, ~] = unique([PutData.date, PutData.exdate], 'rows');

date_intersect = intersect(date_,date__, 'rows');
idx_C = ismember([CallData.date, CallData.exdate], date_intersect, 'rows');
CallData = CallData(idx_C, :);
idx_P = ismember([PutData.date, PutData.exdate], date_intersect, 'rows');
PutData = PutData(idx_P, :);

%% Use only the intersection of CallData & PutData & tfz_dly_ts2.
% This removes some entries of T_CallData, T_PutData. 
% --> Reason why size(OpData_dly_2nd_BSIV_near30D_Trim, 1) ~= size(tmp_result, 1)
[date_, ~] = unique(CallData.date);
[date__, ~] = unique(PutData.date);
[date___, ~] = unique(T_tfz_dly_ts2.CALDT);

date_intersect = intersect(intersect(date_, date__), date___);
idx_C = ismember(CallData.date, date_intersect);
idx_P = ismember(PutData.date, date_intersect);
idx_tfz = ismember(T_tfz_dly_ts2.CALDT, date_intersect);
CallData = CallData(idx_C,:); PutData = PutData(idx_P, :); T_tfz_dly_ts2 = T_tfz_dly_ts2(idx_tfz, :);

%%
[date_, idx_date_] = unique(CallData.date);
[date__, idx_date__] = unique(PutData.date);
if date_ ~= date__
    error('#dates(Call) ~= #dates(Put). Check the data.');
end

%%
S = CallData.S(idx_date_);
DaysPerYear = 252;
r = CallData.r(idx_date_) * DaysPerYear;
q = CallData.q(idx_date_);

if length(S) ~= length(idx_date_)
    error('Something is wrong. Re-check.');
end

idx_date_ = [idx_date_; size(CallData, 1)+1]; % to include the last index.
idx_date__ = [idx_date__; size(PutData, 1)+1]; % unique() doesn't return the last index.

idx_date_next = idx_date_(2:end)-1; idx_date__next = idx_date__(2:end)-1;
idx_date_ = idx_date_(1:end-1); idx_date__ = idx_date__(1:end-1);

%%
r_1st = zeros(length(date_), 1);
r_2nd = zeros(length(date_), 1);

CallData_1st = [];
PutData_1st = [];
CallData_2nd = [];
PutData_2nd = [];
idx_problematic_1 = [];

CT = '15:00:00';  % fix the Current Time.

% Below takes: 7m (DORM)
tic;
for jj=1:length(date_)  % Note that length(date_)+1==length(ia_date_) now.
    try
        tmpIdx_C = idx_date_(jj):idx_date_next(jj) ;
        tmpIdx_P = idx_date__(jj):idx_date__next(jj) ;
        
        [CallData_1st_, CallData_2nd_, PutData_1st_, PutData_2nd_, today_] = ...
            split2nearNnext(CallData(tmpIdx_C, :), PutData(tmpIdx_P, :));

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
        
        CallData_1st = [CallData_1st; CallData_1st_];
        CallData_2nd = [CallData_2nd; CallData_2nd_];
        PutData_1st = [PutData_1st; PutData_1st_];
        PutData_2nd = [PutData_2nd; PutData_2nd_];

    catch
%         fprintf('1st loop: %2f-th row is problematic', jj);
%         warning('Problem with the function or data. Check again.');
%         break;
        idx_problematic_1 = [idx_problematic_1; jj];
    end
end
toc;

save(sprintf('%s\\rawData_VIX.mat', genData_path));

%%

[date_1st_, idx_date_1st_] = unique(CallData_1st.date);
[date_1st__, idx_date_1st__] = unique(PutData_1st.date);

idx_date_1st_ = [idx_date_1st_; size(CallData_1st, 1)+1]; % to include the last index.
idx_date_1st__ = [idx_date_1st__; size(PutData_1st, 1)+1]; % unique() doesn't return the last index.

idx_date_1st_next = idx_date_1st_(2:end)-1; idx_date_1st__next = idx_date_1st__(2:end)-1;
idx_date_1st_ = idx_date_1st_(1:end-1); idx_date_1st__ = idx_date_1st__(1:end-1);

%
[date_2nd_, idx_date_2nd_] = unique(CallData_2nd.date);
[date_2nd__, idx_date_2nd__] = unique(PutData_2nd.date);

idx_date_2nd_ = [idx_date_2nd_; size(CallData_2nd, 1)+1]; % to include the last index.
idx_date_2nd__ = [idx_date_2nd__; size(PutData_2nd, 1)+1]; % unique() doesn't return the last index.

idx_date_2nd_next = idx_date_2nd_(2:end)-1; idx_date_2nd__next = idx_date_2nd__(2:end)-1;
idx_date_2nd_ = idx_date_2nd_(1:end-1); idx_date_2nd__ = idx_date_2nd__(1:end-1);

%% idx_problematic_2: [1185, 1459]
VarIX_1st = []; VarIX_2nd = [];
idx_problematic_2 = [];

% Below takes: 23.7s (LAB PC)
tic;
for jj=1:length(date_)
    try
        tmpIdx_C_1st = idx_date_1st_(jj):idx_date_1st_next(jj);
        tmpIdx_P_1st = idx_date_1st__(jj):idx_date_1st__next(jj);
        
        [T_1st_] = VIXrawVolCurve(PutData_1st(tmpIdx_P_1st, :), CallData_1st(tmpIdx_C_1st, :));

        VarIX_1st_ = VIXConstruction(T_1st_);
        VarIX_1st = [VarIX_1st; VarIX_1st_];
        
        tmpIdx_C_2nd = idx_date_2nd_(jj):idx_date_2nd_next(jj);
        tmpIdx_P_2nd = idx_date_2nd__(jj):idx_date_2nd__next(jj);
        
        [T_2nd_] = VIXrawVolCurve(PutData_2nd(tmpIdx_P_2nd, :), CallData_2nd(tmpIdx_C_2nd, :));
        
        VarIX_2nd_ = VIXConstruction(T_2nd_);
        VarIX_2nd = [VarIX_2nd; VarIX_2nd_];

    catch
%         fprintf('2nd loop: %2f-th row is problematic', jj);
%         warning('Problem with the function or data. Check again.');
%         break;
        idx_problematic_2 = [idx_problematic_2; jj];
    end
end
toc;

%%
VIX = VIX_30Davg(CT, VarIX_1st, VarIX_2nd);

save(sprintf('%s\\VIX_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');

%%
rmpath(sprintf('%s\\main_functions', homeDirectory));
