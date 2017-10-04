%% Goal: bid-VIX, ask-VIX construction
% --> same methodology, different data --> Only one function is enough

%% VIX: near- and next-term call/put options where 23D < TTM < 37D
% including "standard" 3rd Friday expiration and "weekly" SPX options that expire every Friday,
% except the 3rd Friday of each month

% near-term: cannot say whether it's SPX or SPXW
% As TTM_SPX, TTM_SPXW calculations are different, need to distinguish them

% Can choose 1st, 2nd month by 
% 1) Filter out whose TTM < 23D or > 37D
% 2) 1st month == min(TTM), 2nd month == max(TTM)

%%
% S

% r_1st, r_2nd: bond-equivalent yields of the US T-bill maturing closest to the expiration dates of relevant SPX options

% Kc_1st, C_1st, Kp_1st, P_1st
% Kc_2nd, C_2nd, Kp_2nd, P_2nd

%% TTM calculation
% Current time
CT = '09:46:00';

% FInd Hour, Minute, Second from the time using datevec function
[~, ~, ~, Hour, Minute, Second] = datevec(CT);

% 1440: The number of minutes in a day (60*24)


% M_CurrentDay: minutes remaining until midnight("2400") of the current day
M_CurrentDay = 1440 - (Hour*60 + Minute + Second/60);

% M_SettlementDay: minutes from midnight("0000") until 0830 for SPX, until 1500 for SPXW
if symbol_1st == SPX
    M_SettlementDay_1st = (8*60 + 30 + 0/60); % SPX's expiration time: 0830
else
    M_SettlementDay_1st = (15*60 + 0 + 0/60); % SPXW's expiration time: 1500
end

if symbol_2nd == SPX
    M_SettlementDay_2nd = (8*60 + 30 + 0/60); % SPX's expiration time: 0830
else
    M_SettlementDay_2nd = (15*60 + 0 + 0/60); % SPXW's expiration time: 1500
end

% M_OtherDays: total minutes in the days between current day and expiration day
% DTM: days to maturity
M_OtherDays_1st = (DTM_1st - 1) * 1440;
M_OtherDays_2nd = (DTM_2nd - 1) * 1440;

%% TTM_1st, _2nd: same for call, put
% 525600: The numberof minutes in a year (60*24*365)
TTM_1st = (M_CurrentDay + M_SettlementDay_1st + M_OtherDays_1st)/525600;
TTM_2nd = (M_CurrentDay + M_SettlementDay_2nd + M_OtherDays_2nd)/525600;

%% fwd_1st, _2nd: same for call, put
% C_1st, P_1st: have different length <--- should handle this!
% --> Cut out deep-OTM for both call, put: dollar price difference would be large
[K_intersect_1st, iKc_1st, iKp_1st] = intersect(Kc_1st, Kp_1st);
C_1st = C_1st(iKc_1st); Kc_1st = Kc_1st(iKc_1st);
P_1st = P_1st(iKp_1st); Kp_1st = Kp_1st(iKp_1st);

[K_intersect_2nd, iKc_2nd, iKp_2nd] = intersect(Kc_2nd, Kp_2nd);
C_2nd = C_2nd(iKc_2nd); Kc_2nd = Kc_2nd(iKc_2nd);
P_2nd = P_2nd(iKp_2nd); Kp_2nd = Kp_2nd(iKp_2nd);

% C_1st, P_1st (C_2nd, P_2nd) has the same length now, respectively

[~, tmpIndex_1st] = min(abs(C_1st - P_1st)); % index of the minimum
[~, tmpIndex_2nd] = min(abs(C_2nd - P_2nd));

% if Kc_1st(tmpIndex_1st) ~= Kp_1st(tmpIndex_1st)
%     error('Data error.');
% end

Kstar_1st = Kc(tmpIndex_1st);
Kstar_2nd = Kc(tmpIndex_2nd);

fwd_1st = Kstar_1st + exp(r_1st * TTM_1st) * (C_1st(tmpIndex_1st) - P_1st(tmpIndex_1st));
fwd_2nd = Kstar_2nd + exp(r_2nd * TTM_2nd) * (C_2nd(tmpIndex_2nd) - P_2nd(tmpIndex_2nd));



%--------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------

%% Ko, the first strike below the forward index level
% C_1st, C_2nd, P_1st, P_2nd: mid prices Q(K)
% 1st month
K0c_1st = Kc(find(Kc < fwd_1st, 1, 'last')); % First Kc below F
K0p_1st = Kp(find(Kp < fwd_1st, 1, 'last')); % First Kp below F

if K0c_1st ~= K0p_1st
    error('Something is wrong with the 1st month data.');
end

% 2nd month
K0c_2nd = Kc(find(Kc < fwd_2nd, 1, 'last')); % First Kc below F
K0p_2nd = Kp(find(Kp < fwd_2nd, 1, 'last')); % First Kp below F

if K0c_2nd ~= K0p_2nd
    error('Something is wrong with the 2nd month data.');
end

%% select OTM options
% 1st month
Kc_OTM_1st = Kc(Kc>=fwd_1st);
Kp_OTM_1st = Kp(Kp<=fwd_1st);
K_OTM_1st = unique([Kp_OTM_1st; Kc_OTM_1st]); % Kp_OTM < Kc_OTM

dK_OTM_1st = zeros(length(K_OTM_1st), 1);
for i=2:length(K_OTM_1st)-1
    dK_OTM_1st(i) = 0.5 * (K_OTM_1st(i+1) - K_OTM_1st(i-1));
end
dK_OTM_1st(1) = K_OTM_1st(2) - K_OTM_1st(1);
dK_OTM_1st(end) = K_OTM_1st(end) - K_OTM_1st(end-1);

% Do the same for the 2nd month

%% 


