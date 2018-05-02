%% Goal: bid-VIX, ask-VIX construction
%% VIX: near- (1st) and next-term (2nd) call/put options where 23D < TTM < 37D
% including "standard" 3rd Friday expiration and "weekly" SPX options that expire every Friday,
% except the 3rd Friday of each month

%% "Today": second Tue, Oct <-- assume Oct 8, 2013
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

%% To obtain VIX_ask, replacing VIX (VIX_mid).
CallData.Bid = CallData.Ask;
PutData.Bid = PutData.Ask;

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

%% Use only the intersection of CallData & PutData.
[date_, ~] = unique([CallData.date, CallData.exdate], 'rows');
[date__, ~] = unique([PutData.date, PutData.exdate], 'rows');

date_intersect = intersect(date_,date__, 'rows');
idx_C = ismember([CallData.date, CallData.exdate], date_intersect, 'rows');
CallData = CallData(idx_C, :);
idx_P = ismember([PutData.date, PutData.exdate], date_intersect, 'rows');
PutData = PutData(idx_P, :);

%% Use only the intersection of CallData & PutData & tfz_dly_ts2.
[date_, ~] = unique(CallData.date);
[date__, ~] = unique(PutData.date);
[date___, ~] = unique(T_tfz_dly_ts2.CALDT);

date_intersect = intersect(intersect(date_, date__), date___);
idx_C = ismember(CallData.date, date_intersect);
idx_P = ismember(PutData.date, date_intersect);
idx_tfz = ismember(T_tfz_dly_ts2.CALDT, date_intersect);
CallData = CallData(idx_C,:); PutData = PutData(idx_P, :); T_tfz_dly_ts2 = T_tfz_dly_ts2(idx_tfz,:);

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

CT = '15:00:00';  % fix the Current Time.

% Below takes: 184.8s or 3.07m (LAB PC)
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
        fprintf('%2f-th row is problematic', jj);
        warning('Problem with the function or data. Check again.');
        break;
    end
end
toc;

save('tmp_result.mat');

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

%%
VarIX_1st = []; VarIX_2nd = [];

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
        fprintf('%2f-th row is problematic', jj);
        warning('Problem with the function or data. Check again.');
        break;

    end
end
toc;

VIX = VIX_30Davg(CT, VarIX_1st, VarIX_2nd);

save(sprintf('%s\\VIX_ask_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');

%%
rmpath(sprintf('%s\\main_functions', homeDirectory));