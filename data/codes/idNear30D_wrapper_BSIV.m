%% Extract near-/next-term only, the 2 closest to 30D.
clear;clc;
isDorm = true;
if isDorm == true
    drive='F:';
else
    drive='D:';
end
homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
gen_data_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\data\\codes\\functions', homeDirectory));

OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);

% Below takes: 19.6s (LAB PC)
tic;
load(sprintf('%s\\rawOpData_dly_2nd_BSIV.mat', OptionsData_genData_path));
toc;
%% size(CallData,2) = 22
% Below takes 0.41s (DORM PC)
tic
CallData = [CallData, CallIV, CallVolDev];
PutData = [PutData, PutIV, PutVolDev];
toc

%% 30Jun99==730301. CallData.date==730301.exdate=[17Jul99,18Sep99,18Dec99]. PutData.date==730301.exdate=[17Jul99,21Aug99,18Sep99].
% --> CallData.TTM=[18,80,181]. PutData.TTM=[18,52,80,171]. TTM < 70D
% (calendar) are discarded. Thus, this is problematic.
% CallData = CallData(CallData(:,1) ~= 730301, :);
% PutData = PutData(PutData(:,1) ~= 730301, :);

%%
[date_, idx_date_] = unique(CallData(:,1));
[date__, idx_date__] = unique(PutData(:,1));
if date_ ~= date__
    error('#dates(Call) ~= #dates(Put). Check the data.');
end

%%
S = CallData(idx_date_, 11);                                     % CallData(:,11): spindx
DaysPerYear = 252;
r = CallData(idx_date_, 13) * DaysPerYear;                       % CallData(:,13): tb_m3, 1D HPR
q = CallData(idx_date_, 14);                                     % CallData(:,14): annualized dividend
% DTM = daysdif(CallData(ia_date_,1), CallData(ia_date_,2), 13);  % DTM: Days to Maturity

if length(S) ~= length(idx_date_)
    error('Something is wrong. Re-check.');
end

idx_date_ = [idx_date_; length(CallData(:,1))+1]; % to include the last index.
idx_date__ = [idx_date__; length(PutData(:,1))+1]; % unique() doesn't return the last index.

idx_date_next = idx_date_(2:end)-1;
idx_date__next = idx_date__(2:end)-1;
idx_date_ = idx_date_(1:end-1);
idx_date__ = idx_date__(1:end-1);

%%
% Below takes 344.5s or 5.7m (DORM PC)
% --> 361.8s (DORM, MEX)
CallData__ = [];
PutData__ = [];
symbol_C__ = [];
symbol_P__ = [];
tic
for jj=1:length(date_)
    tmpIdx_C = idx_date_(jj):idx_date_next(jj) ;
    tmpIdx_P = idx_date__(jj):idx_date__next(jj) ;
    [CallData_, PutData_, symbol_C_, symbol_P_] = ...
        idNear30D_BSIV(CallData(tmpIdx_C,:), PutData(tmpIdx_P,:), symbol_C(tmpIdx_C, :), symbol_P(tmpIdx_P, :));
    CallData__ = [CallData__; CallData_];
    PutData__ = [PutData__; PutData_];
    symbol_C__ = [symbol_C__; symbol_C_];
    symbol_P__ = [symbol_P__; symbol_P_];
end
toc

CallData = CallData__(:, 1:22);
CallIV = CallData__(:, 23);
CallVolDev = CallData__(:, 24);
symbol_C = symbol_C__;

PutData = PutData__(:, 1:22);
PutIV = PutData__(:, 23);
PutVolDev = PutData__(:, 24);
symbol_P = symbol_P__;

% Below takes: 8.8s (DORM PC)
tic;
save(sprintf('%s\\OpData_dly_2nd_BSIV_near30D.mat', gen_data_path), ...
    'CallData', 'PutData', 'CallIV', 'PutIV', 'CallVolDev', 'PutVolDev', 'symbol_C', 'symbol_P');
toc;

rmpath(sprintf('%s\\data\\codes\\functions', homeDirectory));