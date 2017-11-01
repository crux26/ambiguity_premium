%%
clear; clc;
DaysPerYear = 252;
%% Importing the data takes only a few seconds.
% Below takes 5.1s (LAB PC)
tic
filename = 'D:\Dropbox\GitHub\ambiguity_premium\data\rawdata\SPXCall_dly_2nd_Part4.csv';
ds = tabularTextDatastore(filename);
% disp(preview(ds));

ds.MissingValue = NaN;
ds.TreatAsMissing = 'NA';

ds.ReadSize = 15000;    % Default: 20000 rows at a time

reset(ds);

T = table;
while hasdata(ds)
      T_ = read(ds);
      T = [T; T_];
end
toc
%%
secid = T.secid;
% Below takes 80.1s (LAB PC)
tic
date = T.date; date = char(date); date = datenum(date);
toc
symbol = T.symbol;
% Below takes 80.3s (DORM PC)
tic
exdate = T.exdate; exdate = char(exdate); exdate = datenum(exdate);
toc
cp_flag = T.cp_flag; cp_flag = string(cp_flag);
strike_price = T.strike_price;
best_bid = T.best_bid;
best_offer = T.best_offer;
volume = T.volume;
open_interest = T.open_interest;
impl_volatility = T.impl_volatility;
delta = T.delta;
gamma = T.gamma;
vega = T.vega;
theta = T.theta;
ss_flag = T.ss_flag;
datedif = T.datedif;
spindx = T.spindx;
sprtrn = T.sprtrn;
tb_m3 = T.TB_M3 / DaysPerYear;
div = T.div;
spxset = T.spxset;
spxset_expiry = T.spxset_expiry;
moneyness = T.moneyness;
mid = T.mid;
opret = T.opret;
min_datedif = T.min_datedif;
min_datedif_2nd = T.min_datedif_2nd;

%%
CallData = [date, exdate, strike_price, volume, open_interest, impl_volatility, ...
    delta, gamma, vega, theta, spindx, sprtrn, ...
    tb_m3, div, spxset, spxset_expiry, moneyness, mid, ...
    opret];

CallData(:,20) = 0; % cpflag: Call == 0

CallData(:,[21,22]) = [min_datedif, min_datedif_2nd];
symbol_C = symbol; symbol_C = string(symbol_C);

%%
save('rawOpData_2nd_C_Part4.mat', 'CallData', 'symbol_C');