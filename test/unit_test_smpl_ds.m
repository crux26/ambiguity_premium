%% main_smpl_ds: to check DelConsecZeroBid_call(), ~_put()
clear;clc;
addpath('E:\Dropbox\GitHub\ambiguity_premium\main_functions');
addpath('E:\Dropbox\GitHub\ambiguity_premium\data\sample_data');
% load('smpl_ds.mat');
load('smplput.mat');
load('smplcall.mat');

K0 = 1960;
%% Remove data outside two consecutive zero bids 
[Kp, P_bid_, P_ask_] = DelConsecZeroBid_put(smplput.Kp, smplput.P_bid, smplput.P_ask, K0);
[Kc, C_bid_, C_ask_] = DelConsecZeroBid_call(smplcall.Kc, smplcall.C_bid, smplcall.C_ask, K0);

%% Should not use all zero bids.
idx_P_nonzeroBid = find(P_bid_ ~= 0);
P_bid_ = P_bid_(idx_P_nonzeroBid);
P_ask_ = P_ask_(idx_P_nonzeroBid);
Kp = Kp(idx_P_nonzeroBid);

idx_C_nonzeroBid = find(C_bid_ ~= 0);
C_bid_ = C_bid_(idx_C_nonzeroBid);
C_ask_ = C_ask_(idx_C_nonzeroBid);
Kc = Kc(idx_C_nonzeroBid);
%%

rmpath('E:\Dropbox\GitHub\ambiguity_premium\main_functions');
rmpath('E:\Dropbox\GitHub\ambiguity_premium\data\sample_data');

