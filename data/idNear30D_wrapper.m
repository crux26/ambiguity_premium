%% Extract near-/next-term only, the 2 closest to 30D.
clear;clc;
isDorm = true;
if isDorm == true
    Drive="F:";
else
    Drive="D:";
end
% addpath(sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', Drive));
% addpath(sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium\\data', Drive));
load('rawOpData_2nd_C.mat');
load('rawOpData_2nd_P.mat');

%% 30Jun99==730301. CallData.date==730301.exdate=[17Jul99,18Sep99,18Dec99]. PutData.date==730301.exdate=[17Jul99,21Aug99,18Sep99].
% --> CallData.TTM=[18,80,181]. PutData.TTM=[18,52,80,171]. TTM < 70D
% (calendar) are discarded. Thus, this is problematic.
CallData = CallData(CallData(:,1) ~= 730301, :);
PutData = PutData(PutData(:,1) ~= 730301, :);

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

%%
% Below takes 203.9s or 3.4m (DORM PC)
CallData__ = [];
PutData__ = [];
tic
for jj=1:length(date_)
    tmpIdx_C = idx_date_(jj):(idx_date_(jj+1)-1) ;
    tmpIdx_P = idx_date__(jj):(idx_date__(jj+1)-1) ;    
    [CallData_, PutData_] = idNear30D(CallData(tmpIdx_C,:), PutData(tmpIdx_P,:));
    CallData__ = [CallData__; CallData_];
    PutData__ = [PutData__; PutData_];
end
toc

CallData = CallData__;
PutData = PutData__;
save('rawOpData_2nd_Trim.mat', 'CallData', 'PutData');