function [T_out] = VIXrawVolCurve(T_PutData, T_CallData)
% function [K, OpPrice] = VIXrawVolCurve(Kp, P_bid, P_ask, Kc, C_bid, C_ask, r, TTM)
date_ = unique(T_PutData.date);
exdate = unique(T_PutData.exdate);
if length(date_) ~= 1 || length(exdate) ~= 1
    error('length(date_) ~= 1 || length(exdate) ~= 1.');
end
Kp = T_PutData.Kp;
P_bid = T_PutData.P_bid;
P_ask = T_PutData.P_ask;

Kc = T_CallData.Kc;
C_bid = T_CallData.C_bid;
C_ask = T_CallData.C_ask;
r = unique(T_CallData.r);
TTM = unique(T_CallData.TTM);
DTM_BUS = unique(T_CallData.DTM_BUS);
isSTD = unique(T_CallData.isSTD);
if length(r)~=1 || length(TTM)~=1 || length(DTM_BUS)~=1 || length(isSTD)~=1
    error('length(r)~=1 || length(TTM)~=1 || length(DTM_BUS)~=1 || length(isSTD)~=1.');
end

C_mid = 0.5 * (C_bid + C_ask);
P_mid = 0.5 * (P_bid + P_ask);

[~, iKc, iKp] = intersect(Kc, Kp);
C_mid = C_mid(iKc); Kc = Kc(iKc);
P_mid = P_mid(iKp); Kp = Kp(iKp);

[~, tmpIndex] = min(abs(C_mid - P_mid)); % index of the minimum

Kstar = Kc(tmpIndex);

fwd = Kstar + exp(r * TTM) * (C_mid(tmpIndex) - P_mid(tmpIndex));

K0c = Kc(find(Kc < fwd, 1, 'last')); % First Kc below F
K0p = Kp(find(Kp < fwd, 1, 'last')); % First Kp below F

if K0c ~= K0p
    error('Something is wrong with the 1st month data.');
end

%% select OTM options && discard 2 consecutive zero bids
[Kp_OTM, P_bid_OTM, P_ask_OTM] = DelConsecZeroBid_put(Kp, P_bid, P_ask, K0p);
[Kc_OTM, C_bid_OTM, C_ask_OTM] = DelConsecZeroBid_call(Kc, C_bid, C_ask, K0c);

%% Delete zero bids data
[Kp_OTM, P_bid_OTM, P_ask_OTM] = DelZeroBid_put(Kp_OTM, P_bid_OTM, P_ask_OTM);
[Kc_OTM, C_bid_OTM, C_ask_OTM] = DelZeroBid_call(Kc_OTM, C_bid_OTM, C_ask_OTM);

%% Select Kc_OTMC, Kp_OTMP
% K0c == K0p
% 1st month
K = unique([Kp_OTM; K0c; Kc_OTM]); % Kp_OTM < Kc_OTM

if ~isempty(K0p)
    idx_K0 = find(Kp == K0p);
else
    idx_K0 = [];
end

if ~isempty(K0c)
    idx_K0_ = find(Kc == K0c);
else
    idx_K0_ = [];
end

if idx_K0 ~= idx_K0_
    error('K0 not same for call and put.');
end
P_K0 = 0.5 * (P_bid(idx_K0) + P_ask(idx_K0));
C_K0 = 0.5 * (C_bid(idx_K0_) + C_ask(idx_K0_));
OpPrice_K0 = 0.5 * (P_K0 + C_K0);

P_OTM = 0.5 * (P_bid_OTM + P_ask_OTM);
C_OTM = 0.5 * (C_bid_OTM + C_ask_OTM);

OpPrice = [P_OTM; OpPrice_K0; C_OTM];

if length(K) ~= length(OpPrice)
    error('length(K) ~= length(OpPrice).');
end

%% 
T_out = table(date_*ones(size(K,1), 1), exdate*ones(size(K,1), 1),  K, OpPrice, ...
    fwd*ones(size(K,1), 1), r*ones(size(K,1), 1), ...
    TTM*ones(size(K,1), 1), DTM_BUS*ones(size(K,1), 1), isSTD*ones(size(K,1), 1), ...
    'VariableNames', {'date', 'exdate', 'K', 'OpPrice', 'fwd', 'r', 'TTM', 'DTM_BUS', 'isSTD'});