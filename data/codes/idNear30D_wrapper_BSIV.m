%% Extract near-/next-term only, the 2 closest to 30D.
clear;clc;
isDorm = false;
if isDorm == true
    drive='E:';
else
    drive='E:';
end
homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\data\\codes\\functions', homeDirectory));

OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);

% Below takes: 3.4s (DORM)
tic;
load(sprintf('%s\\rawOpData_dly_2nd_BSIV.mat', OptionsData_genData_path));
toc;

%% 
CallData = table(CallData(:,1), CallData(:,2), CallData(:,3), CallData(:,4), CallData(:,5), ...
    CallData(:,6), CallData(:,7), CallData(:,8), CallData(:,9), CallData(:,10), CallData(:,11), CallData(:,12), ...
    CallData(:,13), CallData(:,14), CallData(:,15), CallData(:,16), CallData(:,17), CallData(:,18), CallData(:,19), ...
    CallData(:,20), CallData(:,21), CallData(:,22), ...
    TTM_C, CallBidAsk(:,1), CallBidAsk(:,2), symbol_C, CallIV, CallVolDev, ...
    'VariableNames', ...
    {'date', 'exdate', 'Kc', 'volume', 'open_interest', ...
    'IV', 'delta', 'gamma', 'vega', 'theta',  'S', 'sprtrn', ...
    'r', 'q', 'spxset', 'spxset_expiry', 'moneyness', 'C', 'opret', ...
    'cpflag', 'min_datedif', 'min_datedif_2nd', ...
    'TTM', 'Bid', 'Ask', 'symbol', 'BSIV', 'BSIV_dev'});
    
PutData = table(PutData(:,1), PutData(:,2), PutData(:,3), PutData(:,4), PutData(:,5), ...
    PutData(:,6), PutData(:,7), PutData(:,8), PutData(:,9), PutData(:,10), PutData(:,11), PutData(:,12), ...
    PutData(:,13), PutData(:,14), PutData(:,15), PutData(:,16), PutData(:,17), PutData(:,18), PutData(:,19), ...
    PutData(:,20), PutData(:,21), PutData(:,22), ...
    TTM_P, PutBidAsk(:,1), PutBidAsk(:,2), symbol_P, PutIV, PutVolDev, ...
    'VariableNames', ...
    {'date', 'exdate', 'Kp', 'volume', 'open_interest', ...
    'IV', 'delta', 'gamma', 'vega', 'theta', 'S', 'sprtrn', ...
    'r', 'q', 'spxset', 'spxset_expiry', 'moneyness', 'P', 'opret', ...
    'cpflag', 'min_datedif', 'min_datedif_2nd', ...
    'TTM', 'Bid', 'Ask', 'symbol', 'BSIV', 'BSIV_dev'});

clear CallBidAsk CallIV CallVolDev symbol_C TTM_C PutBidAsk PutIV PutVolDev symbol_P TTM_P;

%% VIX old white paper: discard DTM_CAL < 7D
DTM_C = daysdif(CallData.date, CallData.exdate);
DTM_P = daysdif(PutData.date, PutData.exdate);
CallData = CallData(DTM_C >= 7, :);
PutData = PutData(DTM_P >= 7, :);

%%
[date_, idx_date_] = unique(CallData(:,1));
[date__, idx_date__] = unique(PutData(:,1));
if ~isequal(date_, date__)
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

idx_date_ = [idx_date_; size(CallData, 1) + 1]; % to include the last index.
idx_date__ = [idx_date__; size(PutData, 1) + 1]; % unique() doesn't return the last index.

idx_date_next = idx_date_(2:end)-1;
idx_date__next = idx_date__(2:end)-1;
idx_date_ = idx_date_(1:end-1);
idx_date__ = idx_date__(1:end-1);

%%
CallData__ = [];
PutData__ = [];

% Below takes 8m (LAB. Do not use MEX; it's slower.)
tic;
for jj=1:size(date_, 1)
    tmpIdx_C = idx_date_(jj):idx_date_next(jj) ;
    tmpIdx_P = idx_date__(jj):idx_date__next(jj) ;
    [CallData_, PutData_] = ...
        idNear30D_BSIV(CallData(tmpIdx_C,:), PutData(tmpIdx_P,:));
    CallData__ = [CallData__; CallData_];
    PutData__ = [PutData__; PutData_];
end
toc;

CallData = CallData__;
PutData = PutData__;

% Below takes: 5.7s (DORM)
tic;
save(sprintf('%s\\OpData_dly_2nd_BSIV_near30D.mat', genData_path), 'CallData', 'PutData');
toc;

rmpath(sprintf('%s\\data\\codes\\functions', homeDirectory));
