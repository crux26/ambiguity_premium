%% Extract near-/next-term only, the 2 closest to 30D.
%% Result is missing the first 2 weeks every month.
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

% Below takes: 4.0s (DORM)
tic;
load(sprintf('%s\\rawOpData_dly_2nd_BSIV_Trim.mat', OptionsData_genData_path));
toc;

%% VIX old white paper: discard DTM_CAL < 7D
DTM_C = daysdif(CallData.date, CallData.exdate);
DTM_P = daysdif(PutData.date, PutData.exdate);
CallData = CallData(DTM_C >= 7, :);
PutData = PutData(DTM_P >= 7, :);

%% Choose DTM b/w [23D, 37D] (Calendar day diff.).
% DTM_C = CallData.exdate - CallData.date; 
% DTM_P = PutData.exdate - PutData.date;
% CallData = CallData((DTM_C >= 23 & DTM_C <= 37), :);
% PutData = PutData((DTM_P >= 23 & DTM_P <= 37), :);

% Above removes more than needed. It's okay to have TTM_1st = 10D, TTM_2nd=40D, which are removed above.

%% Choose only intersection of (date, exdate) pair of CallData, PutData.
[date_, ~] = unique([CallData.date, CallData.exdate], 'rows');
[date__, ~] = unique([PutData.date, PutData.exdate], 'rows');

date_intersect = intersect(date_,date__, 'rows');
idx_C = ismember([CallData.date, CallData.exdate], date_intersect, 'rows');
CallData = CallData(idx_C, :);
idx_P = ismember([PutData.date, PutData.exdate], date_intersect, 'rows');
PutData = PutData(idx_P, :);

%%
[date_, idx_date_] = unique(CallData.date);
[date__, idx_date__] = unique(PutData.date);
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

% Below takes 10m (DORM. Do not use MEX; it's slower.)
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

% Below takes: 4.1s (DORM)
tic;
save(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path), 'CallData', 'PutData');
toc;

rmpath(sprintf('%s\\data\\codes\\functions', homeDirectory));
