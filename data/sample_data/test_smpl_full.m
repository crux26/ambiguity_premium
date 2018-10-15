%% Checked it returns the same value as of white paper
% from CBOE VIX white paper
clear; clc;
load('smpl_full.mat');
addpath('E:\Dropbox\GitHub\ambiguity_premium');
% 1st month
Kc_1st = near_term.K;
Kp_1st = near_term.K;
P_1st_bid = near_term.P_1st_bid;
P_1st_ask = near_term.P_1st_ask;
C_1st_bid = near_term.C_1st_bid;
C_1st_ask = near_term.C_1st_ask;

% 2nd month
Kc_2nd = next_term.K;
Kp_2nd = next_term.K;
P_2nd_bid = next_term.P_2nd_bid;
P_2nd_ask = next_term.P_2nd_ask;
C_2nd_bid = next_term.C_2nd_bid;
C_2nd_ask = next_term.C_2nd_ask;

%
TTM_1st = 0.0683486;
TTM_2nd = 0.0882686;
r_1st = 0.0305 * 0.01;
r_2nd = 0.0286 * 0.01;

%%
CT = '09:46:00';
date = datenum('10oct2006');
exdate1 = daysadd(date, 25);
exdate2 = daysadd(date, 32);

%% Goto <VIX_replicate.m>
% function [T_out] = VIXrawVolCurve(T_PutData, T_CallData)
DTM_BUS = daysdif(date, exdate1, 13); isSTD = ones(size(Kp_1st));
T_PutData_1st = table(date * ones(size(Kp_1st)), exdate1 * ones(size(Kp_1st)), Kp_1st, P_1st_bid, P_1st_ask, ...
    r_1st * ones(size(Kp_1st)), TTM_1st * ones(size(Kp_1st)), DTM_BUS * ones(size(Kp_1st)), isSTD );
T_PutData_1st.Properties.VariableNames = {'date', 'exdate', 'Kp', 'P_bid', 'P_ask', 'r', 'TTM', 'DTM_BUS', 'isSTD'};

isSTD = ones(size(Kc_1st));
T_CallData_1st = table(date * ones(size(Kc_1st)), exdate1 * ones(size(Kc_1st)), Kc_1st, C_1st_bid, C_1st_ask, ...
    r_1st * ones(size(Kc_1st)), TTM_1st * ones(size(Kc_1st)), DTM_BUS * ones(size(Kc_1st)), isSTD);
T_CallData_1st.Properties.VariableNames = {'date', 'exdate', 'Kc', 'C_bid', 'C_ask', 'r', 'TTM', 'DTM_BUS', 'isSTD'};


DTM_BUS = daysdif(date, exdate2, 13); isSTD = zeros(size(Kp_2nd));
T_PutData_2nd = table(date * ones(size(Kp_2nd)), exdate2 * ones(size(Kp_2nd)), Kp_2nd, P_2nd_bid, P_2nd_ask, ...
    r_2nd * ones(size(Kp_2nd)), TTM_2nd * ones(size(Kp_2nd)), DTM_BUS * ones(size(Kp_2nd)), isSTD );
T_PutData_2nd.Properties.VariableNames = {'date', 'exdate', 'Kp', 'P_bid', 'P_ask', 'r', 'TTM', 'DTM_BUS', 'isSTD'};

isSTD = zeros(size(Kc_2nd));
T_CallData_2nd = table(date * ones(size(Kp_2nd)), exdate2 * ones(size(Kp_2nd)), Kc_2nd, C_2nd_bid, C_2nd_ask, ...
    r_2nd * ones(size(Kc_2nd)), TTM_2nd * ones(size(Kc_2nd)), DTM_BUS * ones(size(Kc_2nd)), isSTD );
T_CallData_2nd.Properties.VariableNames = {'date', 'exdate', 'Kc', 'C_bid', 'C_ask', 'r', 'TTM', 'DTM_BUS', 'isSTD'};

[T_1st] = VIXrawVolCurve(T_PutData_1st, T_CallData_1st);
[T_2nd] = VIXrawVolCurve(T_PutData_2nd, T_CallData_2nd);

%% Calculate VIX
VarIX_1st = VIXConstruction(T_1st);
VarIX_2nd = VIXConstruction(T_2nd);
VIX = VIX_30Davg(CT, VarIX_1st, VarIX_2nd);
