function [K, OpPrice] = VIXrawVolCurve(Kp, P_bid, P_ask, Kc, C_bid, C_ask, r, TTM)
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
idx_K0 = find(Kp == K0p);
idx_K0_ = find(Kc == K0c);
if idx_K0 ~= idx_K0_
    error('K0 not same for call and put.');
end
P_K0 = 0.5 * (P_bid(idx_K0) + P_ask(idx_K0));
C_K0 = 0.5 * (C_bid(idx_K0_) + C_ask(idx_K0_));
OpPrice_K0 = 0.5 * (P_K0 + C_K0);

P_OTM = 0.5 * (P_bid_OTM + P_ask_OTM);
C_OTM = 0.5 * (C_bid_OTM + C_ask_OTM);

OpPrice = [P_OTM; OpPrice_K0; C_OTM];