%% Split2NearNext(): for SAS process

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
load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path));
% load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D.mat', genData_path));

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
% This removes some entries of T_CallData, T_PutData. 
% --> Reason why size(OpData_dly_2nd_BSIV_near30D_Trim, 1) ~= size(tmp_result, 1)
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
idx_problematic_1 = [];

% Below takes: 7m (DORM)
tic;
for jj=1:length(date_)  % Note that length(date_)+1==length(ia_date_) now.
    try
        tmpIdx_C = idx_date_(jj):idx_date_next(jj) ;
        tmpIdx_P = idx_date__(jj):idx_date__next(jj) ;
        
        [CallData_1st_, CallData_2nd_, PutData_1st_, PutData_2nd_, today_] = ...
            split2nearNnext(CallData(tmpIdx_C, :), PutData(tmpIdx_P, :));

        TTM_C_1st = yearfrac(unique(CallData_1st_.date), unique(CallData_1st_.exdate));
        TTM_P_1st = yearfrac(unique(PutData_1st_.date), unique(PutData_1st_.exdate));
        
        TTM_C_2nd = yearfrac(unique(CallData_2nd_.date), unique(CallData_2nd_.exdate));
        TTM_P_2nd = yearfrac(unique(PutData_2nd_.date), unique(PutData_2nd_.exdate));
        
        CallData_1st_.TTM = TTM_C_1st*ones(size(CallData_1st_,1), 1); PutData_1st_.TTM = TTM_P_1st*ones(size(PutData_1st_,1), 1);
        CallData_2nd_.TTM = TTM_C_2nd*ones(size(CallData_2nd_,1), 1); PutData_2nd_.TTM = TTM_P_2nd*ones(size(PutData_2nd_,1), 1);
        
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

%% instead of ismem_Call_2nd, ~ismem_Call_1st may be used.
% Using ismem_Call_2nd, 30D is replicated into both _1st and _2nd.
date_Call_1st = unique([CallData_1st.date, CallData_1st.exdate], 'rows');
ismem_Call_1st = ismember([CallData.date, CallData.exdate], date_Call_1st, 'rows');
Call_1st = CallData(ismem_Call_1st, :);

date_Put_1st = unique([PutData_1st.date, PutData_1st.exdate], 'rows');
ismem_Put_1st = ismember([PutData.date, PutData.exdate], date_Put_1st, 'rows');
Put_1st = PutData(ismem_Put_1st, :);

date_Call_2nd = unique([CallData_2nd.date, CallData_2nd.exdate], 'rows');
ismem_Call_2nd = ismember([CallData.date, CallData.exdate], date_Call_2nd, 'rows');
Call_2nd = CallData(ismem_Call_2nd, :);

date_Put_2nd = unique([PutData_2nd.date, PutData_2nd.exdate], 'rows');
ismem_Put_2nd = ismember([PutData.date, PutData.exdate], date_Put_2nd, 'rows');
Put_2nd = PutData(ismem_Put_2nd, :);

%%
clear CallData_1st PutData_1st CallData_2nd PutData_2nd;
CallData_1st = Call_1st; PutData_1st = Put_1st;
CallData_2nd = Call_2nd; PutData_2nd = Put_2nd;

clear Call_1st Put_1st Call_2nd Put_2nd;

%% writetable() for SAS process
CallData_1st.date = datestr(CallData_1st.date); CallData_1st.exdate = datestr(CallData_1st.exdate);
PutData_1st.date = datestr(PutData_1st.date); PutData_1st.exdate = datestr(PutData_1st.exdate);
writetable(CallData_1st, sprintf('%s\\CallData_1st_Full_Trim.csv', genData_path));
writetable(PutData_1st, sprintf('%s\\PutData_1st_Full_Trim.csv', genData_path));

CallData_2nd.date = datestr(CallData_2nd.date); CallData_2nd.exdate = datestr(CallData_2nd.exdate);
PutData_2nd.date = datestr(PutData_2nd.date); PutData_2nd.exdate = datestr(PutData_2nd.exdate);
writetable(CallData_2nd, sprintf('%s\\CallData_2nd_Full_Trim.csv', genData_path));
writetable(PutData_2nd, sprintf('%s\\PutData_2nd_Full_Trim.csv', genData_path));

idx_OTMC_1st = CallData_1st.moneyness < 1;
CallData_1st_OTM = CallData_1st(idx_OTMC_1st, :);

idx_OTMP_1st = PutData_1st.moneyness > 1;
PutData_1st_OTM = PutData_1st(idx_OTMP_1st, :);

idx_OTMC_2nd = CallData_2nd.moneyness < 1;
CallData_2nd_OTM = CallData_2nd(idx_OTMC_2nd, :);

idx_OTMP_2nd = PutData_2nd.moneyness > 1;
PutData_2nd_OTM = PutData_2nd(idx_OTMP_2nd, :);

CallData_1st_OTM.date = datestr(CallData_1st_OTM.date); CallData_1st_OTM.exdate = datestr(CallData_1st_OTM.exdate);
PutData_1st_OTM.date = datestr(PutData_1st_OTM.date); PutData_1st_OTM.exdate = datestr(PutData_1st_OTM.exdate);
writetable(CallData_1st_OTM, sprintf('%s\\CallData_1st_OTM_Trim.csv', genData_path));
writetable(PutData_1st_OTM, sprintf('%s\\PutData_1st_OTM_Trim.csv', genData_path));

CallData_2nd_OTM.date = datestr(CallData_2nd_OTM.date); CallData_2nd_OTM.exdate = datestr(CallData_2nd_OTM.exdate);
PutData_2nd_OTM.date = datestr(PutData_2nd_OTM.date); PutData_2nd_OTM.exdate = datestr(PutData_2nd_OTM.exdate);
writetable(CallData_2nd_OTM, sprintf('%s\\CallData_2nd_OTM_Trim.csv', genData_path));
writetable(PutData_2nd_OTM, sprintf('%s\\PutData_2nd_OTM_Trim.csv', genData_path));