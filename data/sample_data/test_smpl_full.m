clear; clc;
load('smpl_full.mat');
addpath('F:\Dropbox\GitHub\ambiguity_premium');
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

%% Goto <VIX_replicate.m>
[K_1st, OpPrice_1st] = VIXrawVolCurve(Kp_1st, P_1st_bid, P_1st_ask, Kc_1st, C_1st_bid, C_1st_ask, r_1st, TTM_1st);
[K_2nd, OpPrice_2nd] = VIXrawVolCurve(Kp_2nd, P_2nd_bid, P_2nd_ask, Kc_2nd, C_2nd_bid, C_2nd_ask, r_2nd, TTM_2nd);