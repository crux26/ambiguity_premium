%% Goal: bid-VIX, ask-VIX construction
% --> same methodology, different data --> Only one function is enough

%% VIX: near- (1st) and next-term (2nd) call/put options where 23D < TTM < 37D
% including "standard" 3rd Friday expiration and "weekly" SPX options that expire every Friday,
% except the 3rd Friday of each month

% near-term: cannot say whether it's SPX or SPXW --> identify with symbol.

% Can choose 1st, 2nd month by 
% 1) Filter out whose TTM < 23D or > 37D
% 2) 1st month == min(TTM), 2nd month == max(TTM)

%% "Today": second Tue, Oct <-- assume Oct 8, 2013
clear;clc;
addpath('D:\Dropbox\GitHub\ambiguity_premium\data\sample_data');
load('OpData_BSIV_2nd.mat');

% r_1st, r_2nd: bond-equivalent yields of the US T-bill maturing closest to the expiration dates of relevant SPX options
addpath('D:\Dropbox\GitHub\ambiguity_premium\data');
load('tfz_dly_ts2.mat', 'table_');
table_ = sortrows(table_, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.
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

%% Classify standard / non-standard options.
% [idx_exdate_, exdate_] = find(diff(CallData(:,2))~=0);
% [idx_exdate__, exdate__] = find(diff(PutData(:,2))~=0);
% 
% %% START AGAIN FROM HERE.
% if exdate_ ~= exdate__
%     error('#exdates(call)~=#exdates(put). Check the data.');
% end

%% Above error because on 30JUN1999, only 17JUL1999 && 18SEP1999 available for Call.
%% On the other hand, two 21AUG1999 available for Put.
% --> This will be catched by "catch" below.

%%
CT = '15:00:00';  % fix the Current Time.
jj=1;
for jj=1:length(date_)                   % Note that length(date_)+1==length(ia_date_) now.
    try
        tmpIdx_C = idx_date_(jj):(idx_date_(jj+1)-1) ;
        tmpIdx_P = idx_date__(jj):(idx_date__(jj+1)-1) ;
        %--------------
        [Kc_1st, C_1st, Kp_1st, P_1st, DTM_1st, ...
            Kc_2nd, C_2nd, Kp_2nd, P_2nd, DTM_2nd, isSTD_1st, isSTD_2nd, today_] = ...
            split2nearNnext(CallData(tmpIdx_C, :), PutData(tmpIdx_P, :));
        C = [C_1st; C_2nd]; Kc = [Kc_1st; Kc_2nd];
        P = [P_1st; P_2nd]; Kp = [Kp_1st; Kp_2nd];
        
        [TTM_C_1st, TTM_P_1st] = deal(TTM4VIX(CT, DTM_1st, isSTD_1st));
        [TTM_C_2nd, TTM_P_2nd] = deal(TTM4VIX(CT, DTM_2nd, isSTD_2nd));
        
        idx_today = find(today_ == table_.CALDT);
        r_1st = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_1st, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));
        r_2nd = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_2nd, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));

    catch
        warning('Problem with the function or data. Check again.');
    end
end

%------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------

%%
% today_ = datenum('08Oct2013');
% CT = '09:46:00';
% DTM_1st = 25; DTM_2nd = 32;
% symbol_1st = 'SPX'; symbol_2nd = 'SPXW';
% TTM_1st = TTM4VIX(CT, DTM_1st, symbol_1st); % TTM_1st = 0.0683486;
% TTM_2nd = TTM4VIX(CT, DTM_2nd, symbol_2nd); % TTM_2nd = 0.0882686;


%%


%% matching r_*.
idx_today = find(today_ == table_.CALDT);
r_1st = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_1st, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));
r_2nd = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_2nd, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));
% r_1st = 0.0305 * 0.01;
% r_2nd = 0.0286 * 0.01;
%--------------------------------------------------------------------------------------------------------------

%%
[K_1st, OpPrice_1st] = VIXrawVolCurve(Kp_1st, P_1st_bid, P_1st_ask, Kc_1st, C_1st_bid, C_1st_ask, r_1st, TTM_1st);
[K_2nd, OpPrice_2nd] = VIXrawVolCurve(Kp_2nd, P_2nd_bid, P_2nd_ask, Kc_2nd, C_2nd_bid, C_2nd_ask, r_2nd, TTM_2nd);

%%
% dK_OTM_1st = zeros(length(K_OTM_1st), 1);
% for i=2:length(K_OTM_1st)-1
%     dK_OTM_1st(i) = 0.5 * (K_OTM_1st(i+1) - K_OTM_1st(i-1));
% end
% dK_OTM_1st(1) = K_OTM_1st(2) - K_OTM_1st(1);
% dK_OTM_1st(end) = K_OTM_1st(end) - K_OTM_1st(end-1);

% Do the same for the 2nd month

%% 


