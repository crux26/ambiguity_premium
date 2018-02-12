function [T_CallData_1st, T_CallData_2nd, T_PutData_1st, T_PutData_2nd, today_] = ...
    split2nearNnext(T_CallData, T_PutData)
% If XData.exdate.length==2, split them into near- and next-term.
% If Xdata.exdate.length==1, deal the same data into near- and next-term.
% Result will be used for the interpolation, so nothing wrong with this method.

% Length can only be either 1 or 2.
tmp_Expiries_C = unique( T_CallData.exdate );  % length()<=2 : Guaranteed by idNear30D_wrapper().
if length(tmp_Expiries_C) == 1
    tmp_Expiries_C = ones(2,1) * tmp_Expiries_C; % To prevent error in DTM_2nd.
elseif length(tmp_Expiries_C) > 3
    error('tmp_Expiries_C.length() > 3.');
end
tmpIdx_C_1st = find( T_CallData.exdate == tmp_Expiries_C(1) ); % Shorter DTM.
tmpIdx_C_2nd = find( T_CallData.exdate == tmp_Expiries_C(2) ); % Longer DTM.


%%
% Length can only be either 1 or 2.
tmp_Expiries_P = unique( T_PutData.exdate );   % length()==2 in general.
if length(tmp_Expiries_P) == 1
    tmp_Expiries_P = ones(2,1) * tmp_Expiries_P;
elseif length(tmp_Expiries_P) > 3
    error('tmp_Expiries_P.length() > 3.');
end
tmpIdx_P_1st = find( T_PutData.exdate == tmp_Expiries_P(1) );  % Shorter DTM.
tmpIdx_P_2nd = find( T_PutData.exdate == tmp_Expiries_P(2) );  % Longer DTM.

%%
% Sanity check
if ~isequal(length(tmp_Expiries_C), length(tmp_Expiries_P)) % length can be 1 or 3, while each element being the same.
    error('length(tmp_Expiries_C) ~= length(tmp_Expiries_P)');
end
    
Kc_1st = T_CallData.Kc(tmpIdx_C_1st);
Kc_2nd = T_CallData.Kc(tmpIdx_C_2nd);

C_1st = T_CallData.C(tmpIdx_C_1st); % call's mid price (C)
C_1st_bid = T_CallData.Bid(tmpIdx_C_1st);
C_1st_ask = T_CallData.Ask(tmpIdx_C_1st);

TTM_C_1st = yearfrac(T_CallData.date(tmpIdx_C_1st), T_CallData.exdate(tmpIdx_C_1st), 13);

C_2nd = T_CallData.C(tmpIdx_C_2nd);
C_2nd_bid = T_CallData.Bid(tmpIdx_C_2nd);
C_2nd_ask = T_CallData.Ask(tmpIdx_C_2nd);

TTM_C_2nd = yearfrac(T_CallData.date(tmpIdx_C_2nd), T_CallData.exdate(tmpIdx_C_2nd), 13);

Kp_1st = T_PutData.Kp(tmpIdx_P_1st);
Kp_2nd = T_PutData.Kp(tmpIdx_P_2nd);

P_1st = T_PutData.P(tmpIdx_P_1st);  % put's mid price (P)
P_1st_bid = T_PutData.Bid(tmpIdx_P_1st);
P_1st_ask = T_PutData.Ask(tmpIdx_P_1st);

TTM_P_1st = yearfrac(T_PutData.date(tmpIdx_P_1st), T_PutData.exdate(tmpIdx_P_1st), 13);

P_2nd = T_PutData.P(tmpIdx_P_2nd);
P_2nd_bid = T_PutData.Bid(tmpIdx_P_2nd);
P_2nd_ask = T_PutData.Ask(tmpIdx_P_2nd);

TTM_P_2nd = yearfrac(T_PutData.date(tmpIdx_P_2nd), T_PutData.exdate(tmpIdx_P_2nd), 13);

today_ = unique(T_CallData.date);
today__ = unique(T_PutData.date);

if length(today_)~=1 || length(today__)~=1
    error('More than one date is given.');
end

if today_ ~= today__
    error('CallData.date ~= PutData.date.');
end
%%
[Year_1st, Month_1st] = datevec(tmp_Expiries_C(1));
is3rdFri_1st = nweekdate(3,6,Year_1st, Month_1st);
is3rdFriPlus1_1st = nweekdate(3,6,Year_1st, Month_1st)+1;   % 3rd occurrence of 6th day (Fri).
if tmp_Expiries_C(1)==is3rdFri_1st || tmp_Expiries_C(1)==is3rdFriPlus1_1st
    isSTD_1st = 1;
else
    isSTD_1st = 0;
end

[Year_2nd, Month_2nd] = datevec(tmp_Expiries_C(2));
is3rdFri_2nd = nweekdate(3,6,Year_2nd, Month_2nd);
is3rdFriPlus1_2nd = nweekdate(3,6,Year_2nd, Month_2nd)+1;   % 3rd occurrence of 6th day (Fri).
if tmp_Expiries_C(2)==is3rdFri_2nd || tmp_Expiries_C(2)==is3rdFriPlus1_2nd
    isSTD_2nd = 1;
else
    isSTD_2nd = 0;
end
%% DTM: Bus. day diff.

DTM_1st = daysdif(today_, tmp_Expiries_C(1), 13);
DTM_2nd = daysdif(today_, tmp_Expiries_C(2), 13);

%%
T_CallData_1st = table(today_*ones(length(Kc_1st), 1), tmp_Expiries_C(1)*ones(length(Kc_1st), 1), ...
    Kc_1st, C_1st, C_1st_bid, C_1st_ask, ...
    DTM_1st*ones(length(Kc_1st), 1), TTM_C_1st, isSTD_1st*ones(length(Kc_1st), 1), ...
    'VariableNames', {'date', 'exdate', 'Kc', 'C', 'C_bid', 'C_ask', 'DTM_BUS', 'TTM', 'isSTD'});
T_CallData_2nd = table(today_*ones(length(Kc_2nd), 1), tmp_Expiries_C(2)*ones(length(Kc_2nd), 1), ...
    Kc_2nd, C_2nd, C_2nd_bid, C_2nd_ask, ...
    DTM_2nd*ones(length(Kc_2nd), 1), TTM_C_2nd, isSTD_2nd*ones(length(Kc_2nd), 1), ...
    'VariableNames', {'date', 'exdate', 'Kc', 'C', 'C_bid', 'C_ask', 'DTM_BUS', 'TTM', 'isSTD'});

T_PutData_1st = table(today_*ones(length(Kp_1st), 1), tmp_Expiries_P(1)*ones(length(Kp_1st), 1), ...
    Kp_1st, P_1st, P_1st_bid, P_1st_ask, ...
    DTM_1st*ones(length(Kp_1st), 1), TTM_P_1st, isSTD_1st*ones(length(Kp_1st), 1), ...
    'VariableNames', {'date', 'exdate', 'Kp', 'P', 'P_bid', 'P_ask', 'DTM_BUS', 'TTM', 'isSTD'});
T_PutData_2nd = table(today_*ones(length(Kp_2nd), 1), tmp_Expiries_P(2)*ones(length(Kp_2nd), 1), ...
    Kp_2nd, P_2nd, P_2nd_bid, P_2nd_ask, ...
    DTM_2nd*ones(length(Kp_2nd), 1), TTM_P_2nd, isSTD_2nd*ones(length(Kp_2nd), 1), ... 
    'VariableNames', {'date', 'exdate', 'Kp', 'P', 'P_bid', 'P_ask', 'DTM_BUS', 'TTM', 'isSTD'});