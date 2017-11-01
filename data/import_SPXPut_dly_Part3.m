%%
clear; clc;
DaysPerYear = 252;
%% Importing the data takes only a few seconds.
% Below takes 3.16s.
tic
filename = 'F:\Dropbox\GitHub\ambiguity_premium\data\rawdata\SPXPut_dly_2nd_Part3.csv';
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
% Below takes 57s. (DORM PC)
tic
date = T.date; date = char(date); date = datenum(date);
toc
symbol = T.symbol;
% Below takes 61.5s. (DORM PC)
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
PutData = [date, exdate, strike_price, volume, open_interest, impl_volatility, ...
    delta, gamma, vega, theta, spindx, sprtrn, ...
    tb_m3, div, spxset, spxset_expiry, moneyness, mid, ...
    opret];

PutData(:,20) = 1; % cpflag: put == 1

PutData(:,[21,22]) = [min_datedif, min_datedif_2nd];
symbol_P = symbol; symbol_P = string(symbol_P);

%%
save('rawOpData_2nd_P_Part3.mat', 'PutData', 'symbol_P');