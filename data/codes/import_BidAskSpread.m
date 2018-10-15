%% goal: calculate Bid(30D), Ask(30D) using IV_bid(30D), IV_ask(30D)
%% This is for SAS to consider option's bid-ask spread for 30D, comparable to VIX.
clear; clc;
DaysPerYear = 252;

isDorm = false;
if isDorm == true
    drive = 'E:';
else
    drive = 'E:';
end
homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);
rawData_path = sprintf('%s\\data\\rawdata', homeDirectory);

%% C_1st_bidask_ATM
filename = sprintf('%s\\C_1st_bidask_ATM.csv', rawData_path);
delimiter = ',';
startRow = 2;

formatSpec = '%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

C_1st_bidask_ATM = table(dataArray{1:end-1}, 'VariableNames', {'date','exdate','K','volume','open_interest','S','sprtrn','r','q','spxset','spxset_expiry','moneyness','mid','opret','cpflag','min_datedif','min_datedif_2nd','TTM','Bid','Ask','symbol','BSIV_dev','IV','delta','gamma','vega','theta','BSIV','m_ATMC','BidAsk'});

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% P_1st_bidask_ATM
filename = sprintf('%s\\P_1st_bidask_ATM.csv', rawData_path);
delimiter = ',';
startRow = 2;

formatSpec = '%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

P_1st_bidask_ATM = table(dataArray{1:end-1}, 'VariableNames', {'date','exdate','K','volume','open_interest','S','sprtrn','r','q','spxset','spxset_expiry','moneyness','mid','opret','cpflag','min_datedif','min_datedif_2nd','TTM','Bid','Ask','symbol','BSIV_dev','IV','delta','gamma','vega','theta','BSIV','m_ATMP','BidAsk'});

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% C_2nd_bidask_ATM
filename = sprintf('%s\\C_2nd_bidask_ATM.csv', rawData_path);
delimiter = ',';
startRow = 2;

formatSpec = '%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

C_2nd_bidask_ATM = table(dataArray{1:end-1}, 'VariableNames', {'date','exdate','K','volume','open_interest','S','sprtrn','r','q','spxset','spxset_expiry','moneyness','mid','opret','cpflag','min_datedif','min_datedif_2nd','TTM','Bid','Ask','symbol','BSIV_dev','IV','delta','gamma','vega','theta','BSIV','m_ATMC','BidAsk'});

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% P_2nd_bidask_ATM
filename = sprintf('%s\\P_2nd_bidask_ATM.csv', rawData_path);
delimiter = ',';
startRow = 2;

formatSpec = '%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

P_2nd_bidask_ATM = table(dataArray{1:end-1}, 'VariableNames', {'date','exdate','K','volume','open_interest','S','sprtrn','r','q','spxset','spxset_expiry','moneyness','mid','opret','cpflag','min_datedif','min_datedif_2nd','TTM','Bid','Ask','symbol','BSIV_dev','IV','delta','gamma','vega','theta','BSIV','m_ATMP','BidAsk'});

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% date, exdate: string -> datenum
tic;
[datenum_, exdatenum_] = deal(zeros(size(C_1st_bidask_ATM, 1), 1));
for i = 1 : size(C_1st_bidask_ATM, 1)
    datenum_(i) = datenum(C_1st_bidask_ATM.date{i});
    exdatenum_(i) = datenum(C_1st_bidask_ATM.exdate{i});
end
C_1st_bidask_ATM.date = datenum_;
C_1st_bidask_ATM.exdate = exdatenum_;
toc;

%
tic;
[datenum_, exdatenum_] = deal(zeros(size(P_1st_bidask_ATM, 1), 1));
for i = 1 : size(P_1st_bidask_ATM, 1)
    datenum_(i) = datenum(P_1st_bidask_ATM.date{i});
    exdatenum_(i) = datenum(P_1st_bidask_ATM.exdate{i});
end
P_1st_bidask_ATM.date = datenum_;
P_1st_bidask_ATM.exdate = exdatenum_;
toc;

%
tic;
[datenum_, exdatenum_] = deal(zeros(size(C_2nd_bidask_ATM, 1), 1));
for i = 1 : size(C_2nd_bidask_ATM, 1)
    datenum_(i) = datenum(C_2nd_bidask_ATM.date{i});
    exdatenum_(i) = datenum(C_2nd_bidask_ATM.exdate{i});
end
C_2nd_bidask_ATM.date = datenum_;
C_2nd_bidask_ATM.exdate = exdatenum_;
toc;

%
tic;
[datenum_, exdatenum_] = deal(zeros(size(P_2nd_bidask_ATM, 1), 1));
for i = 1 : size(P_2nd_bidask_ATM, 1)
    datenum_(i) = datenum(P_2nd_bidask_ATM.date{i});
    exdatenum_(i) = datenum(P_2nd_bidask_ATM.exdate{i});
end
P_2nd_bidask_ATM.date = datenum_;
P_2nd_bidask_ATM.exdate = exdatenum_;
toc;

clear datenum_ exdatenum_;

%% IV_bid, IV_ask calculation

% 15s each
tic;
C_1st_bidask_ATM.BSIV_bid = blsimpv(C_1st_bidask_ATM.S, ...
    C_1st_bidask_ATM.K, C_1st_bidask_ATM.r, ...
    C_1st_bidask_ATM.TTM, C_1st_bidask_ATM.Bid, ...
    [], C_1st_bidask_ATM.q, 1e-6, {'call'});
toc;    

tic;
C_1st_bidask_ATM.BSIV_ask = blsimpv(C_1st_bidask_ATM.S, ...
    C_1st_bidask_ATM.K, C_1st_bidask_ATM.r, ...
    C_1st_bidask_ATM.TTM, C_1st_bidask_ATM.Ask, ...
    [], C_1st_bidask_ATM.q, 1e-6, {'call'});
toc;

tic;
P_1st_bidask_ATM.BSIV_bid = blsimpv(P_1st_bidask_ATM.S, ...
    P_1st_bidask_ATM.K, P_1st_bidask_ATM.r, ...
    P_1st_bidask_ATM.TTM, P_1st_bidask_ATM.Bid, ...
    [], P_1st_bidask_ATM.q, 1e-6, {'put'});
toc;

tic;
P_1st_bidask_ATM.BSIV_ask = blsimpv(P_1st_bidask_ATM.S, ...
    P_1st_bidask_ATM.K, P_1st_bidask_ATM.r, ...
    P_1st_bidask_ATM.TTM, P_1st_bidask_ATM.Ask, ...
    [], P_1st_bidask_ATM.q, 1e-6, {'put'});
toc;

%
tic;
C_2nd_bidask_ATM.BSIV_bid = blsimpv(C_2nd_bidask_ATM.S, ...
    C_2nd_bidask_ATM.K, C_2nd_bidask_ATM.r, ...
    C_2nd_bidask_ATM.TTM, C_2nd_bidask_ATM.Bid, ...
    [], C_2nd_bidask_ATM.q, 1e-6, {'call'});
toc;

tic;
C_2nd_bidask_ATM.BSIV_ask = blsimpv(C_2nd_bidask_ATM.S, ...
    C_2nd_bidask_ATM.K, C_2nd_bidask_ATM.r, ...
    C_2nd_bidask_ATM.TTM, C_2nd_bidask_ATM.Ask, ...
    [], C_2nd_bidask_ATM.q, 1e-6, {'call'});
toc;

tic;
P_2nd_bidask_ATM.BSIV_bid = blsimpv(P_2nd_bidask_ATM.S, ...
    P_2nd_bidask_ATM.K, P_2nd_bidask_ATM.r, ...
    P_2nd_bidask_ATM.TTM, P_2nd_bidask_ATM.Bid, ...
    [], P_2nd_bidask_ATM.q, 1e-6, {'put'});
toc;

tic;
P_2nd_bidask_ATM.BSIV_ask = blsimpv(P_2nd_bidask_ATM.S, ...
    P_2nd_bidask_ATM.K, P_2nd_bidask_ATM.r, ...
    P_2nd_bidask_ATM.TTM, P_2nd_bidask_ATM.Ask, ...
    [], P_2nd_bidask_ATM.q, 1e-6, {'put'});
toc;

%% Change TTM_bus to TTM_cal.
C_1st_bidask_ATM.TTM = yearfrac(C_1st_bidask_ATM.date, C_1st_bidask_ATM.exdate);
P_1st_bidask_ATM.TTM = yearfrac(P_1st_bidask_ATM.date, P_1st_bidask_ATM.exdate);

C_2nd_bidask_ATM.TTM = yearfrac(C_2nd_bidask_ATM.date, C_2nd_bidask_ATM.exdate);
P_2nd_bidask_ATM.TTM = yearfrac(P_2nd_bidask_ATM.date, P_2nd_bidask_ATM.exdate);

%% P_1st_bidask_ATM misses 29SEP2000 somehow. Use intersection of dates only.
% This is due to SAS's data issue. If SAS's fixed, then here it's sanity check.
date_intersection = intersect( ...
    intersect( ...
    intersect(C_1st_bidask_ATM.date, ...
    P_1st_bidask_ATM.date), ...
    C_2nd_bidask_ATM.date), ...
    P_2nd_bidask_ATM.date);

C_1st_bidask_ATM = C_1st_bidask_ATM( ismember(C_1st_bidask_ATM.date, date_intersection), :);
P_1st_bidask_ATM = P_1st_bidask_ATM( ismember(P_1st_bidask_ATM.date, date_intersection), :);

C_2nd_bidask_ATM = C_2nd_bidask_ATM( ismember(C_2nd_bidask_ATM.date, date_intersection), :);
P_2nd_bidask_ATM = P_2nd_bidask_ATM( ismember(P_2nd_bidask_ATM.date, date_intersection), :);

%% interp IV_bid, IV_ask in TTM to gen IV_bid(30D), IV_ask(30D)
% Ignore IV; use BSIV instead.
% IV: variance interp. w.r.t. TTM, and take sqrt().

% Call
C_30D_bidask_ATM = C_1st_bidask_ATM;
C_30D_bidask_ATM.exdate = daysadd(C_1st_bidask_ATM.date, 30);
C_30D_bidask_ATM.TTM = yearfrac(C_1st_bidask_ATM.date, C_1st_bidask_ATM.exdate);
C_30D_bidask_ATM.moneyness = C_30D_bidask_ATM.S ./ C_30D_bidask_ATM.K;
C_30D_bidask_ATM.volume = [];
C_30D_bidask_ATM.open_interest = [];
C_30D_bidask_ATM.min_datedif = [];
C_30D_bidask_ATM.min_datedif_2nd = [];
C_30D_bidask_ATM.symbol = [];
C_30D_bidask_ATM.IV = [];
C_30D_bidask_ATM.delta = [];
C_30D_bidask_ATM.gamma = [];
C_30D_bidask_ATM.vega = [];
C_30D_bidask_ATM.theta = [];
C_30D_bidask_ATM.m_ATMC = [];
C_30D_bidask_ATM.BSIV_dev = [];
C_30D_bidask_ATM.opret = [];

% 3s
tic;
for i = 1 : size(C_30D_bidask_ATM, 1)
    try
        C_30D_bidask_ATM.BSIV_bid(i) = sqrt( ...
            interp1( [C_1st_bidask_ATM.TTM(i), C_2nd_bidask_ATM.TTM(i)], ...
            [(C_1st_bidask_ATM.BSIV_bid(i)).^2, (C_2nd_bidask_ATM.BSIV_bid(i)).^2], C_30D_bidask_ATM.TTM(i)) ...
            );

        C_30D_bidask_ATM.BSIV(i) = sqrt( ...
            interp1( [C_1st_bidask_ATM.TTM(i), C_2nd_bidask_ATM.TTM(i)], ...
            [(C_1st_bidask_ATM.BSIV(i)).^2, (C_2nd_bidask_ATM.BSIV(i)).^2], C_30D_bidask_ATM.TTM(i)) ...
            );        
        
        C_30D_bidask_ATM.BSIV_ask(i) = sqrt( ...
            interp1( [C_1st_bidask_ATM.TTM(i), C_2nd_bidask_ATM.TTM(i)], ...
            [(C_1st_bidask_ATM.BSIV_ask(i)).^2, (C_2nd_bidask_ATM.BSIV_ask(i)).^2], C_30D_bidask_ATM.TTM(i)) ...
            );
        
    catch
        C_30D_bidask_ATM.BSIV_bid(i) = C_1st_bidask_ATM.BSIV_bid(i);
        C_30D_bidask_ATM.BSIV(i) = C_1st_bidask_ATM.BSIV(i);
        C_30D_bidask_ATM.BSIV_ask(i) = C_1st_bidask_ATM.BSIV_ask(i);
    end
end
toc;

% Put
P_30D_bidask_ATM = P_1st_bidask_ATM;
P_30D_bidask_ATM.exdate = daysadd(P_1st_bidask_ATM.date, 30);
P_30D_bidask_ATM.TTM = yearfrac(P_1st_bidask_ATM.date, P_1st_bidask_ATM.exdate);
P_30D_bidask_ATM.moneyness = P_30D_bidask_ATM.S ./ P_30D_bidask_ATM.K;
P_30D_bidask_ATM.volume = [];
P_30D_bidask_ATM.open_interest = [];
P_30D_bidask_ATM.min_datedif = [];
P_30D_bidask_ATM.min_datedif_2nd = [];
P_30D_bidask_ATM.symbol = [];
P_30D_bidask_ATM.IV = [];
P_30D_bidask_ATM.delta = [];
P_30D_bidask_ATM.gamma = [];
P_30D_bidask_ATM.vega = [];
P_30D_bidask_ATM.theta = [];
P_30D_bidask_ATM.m_ATMP = [];
P_30D_bidask_ATM.BSIV_dev = [];
P_30D_bidask_ATM.opret = [];

% 3s
tic;
for i = 1 : size(P_30D_bidask_ATM, 1)
    try
        P_30D_bidask_ATM.BSIV_bid(i) = sqrt( ...
            interp1( [P_1st_bidask_ATM.TTM(i), P_2nd_bidask_ATM.TTM(i)], ...
            [(P_1st_bidask_ATM.BSIV_bid(i)).^2, (P_2nd_bidask_ATM.BSIV_bid(i)).^2], P_30D_bidask_ATM.TTM(i)) ...
            );

        P_30D_bidask_ATM.BSIV(i) = sqrt( ...
            interp1( [P_1st_bidask_ATM.TTM(i), P_2nd_bidask_ATM.TTM(i)], ...
            [(P_1st_bidask_ATM.BSIV(i)).^2, (P_2nd_bidask_ATM.BSIV(i)).^2], P_30D_bidask_ATM.TTM(i)) ...
            );        
        
        P_30D_bidask_ATM.BSIV_ask(i) = sqrt( ...
            interp1( [P_1st_bidask_ATM.TTM(i), P_2nd_bidask_ATM.TTM(i)], ...
            [(P_1st_bidask_ATM.BSIV_ask(i)).^2, (P_2nd_bidask_ATM.BSIV_ask(i)).^2], P_30D_bidask_ATM.TTM(i)) ...
            );
        
    catch
        P_30D_bidask_ATM.BSIV_bid(i) = P_1st_bidask_ATM.BSIV_bid(i);
        P_30D_bidask_ATM.BSIV(i) = P_1st_bidask_ATM.BSIV(i);
        P_30D_bidask_ATM.BSIV_ask(i) = P_1st_bidask_ATM.BSIV_ask(i);
    end
end
toc;

%% Calculate Bid(30D), Ask(30D) using IV_bid(30D), IV_ask(30D)
tic;
C_30D_bidask_ATM.Bid = blsprice(C_30D_bidask_ATM.S, ...
    C_30D_bidask_ATM.K, C_30D_bidask_ATM.r, ...
    C_30D_bidask_ATM.TTM, C_30D_bidask_ATM.BSIV_bid, ...
    C_30D_bidask_ATM.q);
toc;

tic;
C_30D_bidask_ATM.Ask = blsprice(C_30D_bidask_ATM.S, ...
    C_30D_bidask_ATM.K, C_30D_bidask_ATM.r, ...
    C_30D_bidask_ATM.TTM, C_30D_bidask_ATM.BSIV_ask, ...
    C_30D_bidask_ATM.q);
toc;

C_30D_bidask_ATM.BidAsk = C_30D_bidask_ATM.Ask - C_30D_bidask_ATM.Bid;
C_30D_bidask_ATM.mid = (C_30D_bidask_ATM.Ask + C_30D_bidask_ATM.Bid) * 0.5;

tic;
P_30D_bidask_ATM.Bid = blsprice(P_30D_bidask_ATM.S, ...
    P_30D_bidask_ATM.K, P_30D_bidask_ATM.r, ...
    P_30D_bidask_ATM.TTM, P_30D_bidask_ATM.BSIV_bid, ...
    P_30D_bidask_ATM.q);
toc;

tic;
P_30D_bidask_ATM.Ask = blsprice(P_30D_bidask_ATM.S, ...
    P_30D_bidask_ATM.K, P_30D_bidask_ATM.r, ...
    P_30D_bidask_ATM.TTM, P_30D_bidask_ATM.BSIV_ask, ...
    P_30D_bidask_ATM.q);
toc;

P_30D_bidask_ATM.BidAsk = P_30D_bidask_ATM.Ask - P_30D_bidask_ATM.Bid;
P_30D_bidask_ATM.mid = (P_30D_bidask_ATM.Ask + P_30D_bidask_ATM.Bid) * 0.5;

%%
C_30D_bidask_ATM.date = datestr(C_30D_bidask_ATM.date);
C_30D_bidask_ATM.exdate = datestr(C_30D_bidask_ATM.exdate);

P_30D_bidask_ATM.date = datestr(P_30D_bidask_ATM.date);
P_30D_bidask_ATM.exdate = datestr(P_30D_bidask_ATM.exdate);

%% Save results
save(sprintf('%s\\C_30D_bidask_ATM.mat', genData_path), 'C_30D_bidask_ATM');
save(sprintf('%s\\P_30D_bidask_ATM.mat', genData_path), 'P_30D_bidask_ATM');
writetable(C_30D_bidask_ATM, sprintf('%s\\C_30D_bidask_ATM.csv', genData_path));
writetable(P_30D_bidask_ATM, sprintf('%s\\P_30D_bidask_ATM.csv', genData_path));