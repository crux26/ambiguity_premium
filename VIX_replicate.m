%% Goal: bid-VIX, ask-VIX construction

%% VIX: near- (1st) and next-term (2nd) call/put options where 23D < TTM < 37D
% including "standard" 3rd Friday expiration and "weekly" SPX options that expire every Friday,
% except the 3rd Friday of each month

%% "Today": second Tue, Oct <-- assume Oct 8, 2013
clear;clc;
isDorm = true;
if isDorm == true
    drive='F:';
else
    drive='D:';
end

homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\main_functions', homeDirectory));
% r_1st, r_2nd: bond-equivalent yields of the US T-bill maturing closest to the expiration dates of relevant SPX options

OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);

load(sprintf('%s\\raw_tfz_dly_ts2.mat', OptionsData_genData_path), 'table_');
table_ = sortrows(table_, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.

load(sprintf('%s\\OpData_dly_2nd_near30D.mat', genData_path));

%% Delete if isnan(tb_m3)
% Below takes: 0.29s (LAB PC)
tic;
idx_notNaN_C = find(~isnan(CallData(:,13)));
CallData = CallData(idx_notNaN_C, :);
% symbol_C = symbol_C(idx_notNaN_C, :);
% CallBidAsk = CallBidAsk(idx_notNaN_C, :);
toc;

% Below takes: 0.29s (LAB PC)
tic;
idx_notNaN_P = find(~isnan(PutData(:,13)));
PutData = PutData(idx_notNaN_P, :);
% symbol_P = symbol_P(idx_notNaN_P, :);
% PutBidAsk = PutBidAsk(idx_notNaN_P, :);
toc;


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

idx_date_next = idx_date_(2:end)-1; idx_date__next = idx_date__(2:end)-1;
idx_date_ = idx_date_(1:end-1); idx_date__ = idx_date__(1:end-1);
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
r_1st = zeros(length(date_), 1);
r_2nd = zeros(length(date_), 1);

CT = '15:00:00';  % fix the Current Time.
jj=1;
for jj=1:length(date_)                   % Note that length(date_)+1==length(ia_date_) now.
    try
        tmpIdx_C = idx_date_(jj):idx_date_next(jj) ;
        tmpIdx_P = idx_date__(jj):idx_date__next(jj) ;
        
        % DISCARDING ALL BUT NEAR 30D SHOULD COME HERE, REDEFINING tmpIdx_.
        % RETURNING ONLY THOSE AND WORKING WITH THEM WOULD BE MORE EFFICIENT.

        %--------------
        [Kc_1st, C_1st, Kp_1st, P_1st, DTM_1st, ...
            Kc_2nd, C_2nd, Kp_2nd, P_2nd, DTM_2nd, isSTD_1st, isSTD_2nd, today_] = ...
            split2nearNnext(CallData(tmpIdx_C, :), PutData(tmpIdx_P, :));
        C = [C_1st; C_2nd]; Kc = [Kc_1st; Kc_2nd];
        P = [P_1st; P_2nd]; Kp = [Kp_1st; Kp_2nd];
        
        [TTM_C_1st, TTM_P_1st] = deal(TTM4VIX(CT, DTM_1st, isSTD_1st));
        [TTM_C_2nd, TTM_P_2nd] = deal(TTM4VIX(CT, DTM_2nd, isSTD_2nd));
        
        idx_today = find(today_ == table_.CALDT);
        r_1st(jj) = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_1st, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));
        r_2nd(jj) = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_2nd, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));
        
        % MORE SHOULD COME HERE. NOT DONE YET.
        disp('For breakpoint.');
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
rmpath(sprintf('%s\\main_functions', homeDirectory));