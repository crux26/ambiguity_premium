function [Kc_1st, C_1st, Kp_1st, P_1st, DTM_1st, ...
    Kc_2nd, C_2nd, Kp_2nd, P_2nd, DTM_2nd, isSTD_1st, isSTD_2nd, today_] = ...
    split2nearNnext(CallData, PutData)
% If XData.exdate.length==2, split them into near- and next-term.
% If Xdata.exdate.length==1, deal the same data into near- and next-term.
% Result will be used for the interpolation, so nothing wrong with this method.

% Length can only be either 1 or 2.
tmp_Expiries_C = unique( CallData(:, 2) );  % length()==2 in general: Guaranteed by idNear30D_wrapper().
if length(tmp_Expiries_C) == 1
    tmp_Expiries_C = ones(2,1) * tmp_Expiries_C;
elseif length(tmp_Expiries_C) > 3
    error('tmp_Expiries_C.length() > 3.');
end
tmpIdx_C_1st = find( CallData(:, 2) == tmp_Expiries_C(1) ); % Shorter DTM.
tmpIdx_C_2nd = find( CallData(:, 2) == tmp_Expiries_C(2) ); % Longer DTM.


%%
% Length can only be either 1 or 2.
tmp_Expiries_P = unique( PutData(:, 2) );   % length()==2 in general.
if length(tmp_Expiries_P) == 1
    tmp_Expiries_P = ones(2,1) * tmp_Expiries_P;
elseif length(tmp_Expiries_P) > 3
    error('tmp_Expiries_P.length() > 3.');
end
tmpIdx_P_1st = find( PutData(:, 2) == tmp_Expiries_P(1) );  % Shorter DTM.
tmpIdx_P_2nd = find( PutData(:, 2) == tmp_Expiries_P(2) );  % Longer DTM.

%%
% Sanity check
if length(tmp_Expiries_C)==2 && length(tmp_Expiries_P)==2
    if tmp_Expiries_C(1) ~= tmp_Expiries_P(1)
        error('1st month maturities of call and put does not match.');
    end
    if tmp_Expiries_C(2) ~= tmp_Expiries_P(2)
        error('2nd month maturities of call and put does not match.');
    end
else
    error('Inconsistency between tmp_Expiries_C and tmp_Expiries_P.');
end
    
Kc_1st = CallData(tmpIdx_C_1st, 3); % CallData(:,3): call's strike price (Kc)
Kc_2nd = CallData(tmpIdx_C_2nd, 3);

C_1st = CallData(tmpIdx_C_1st, 18); % CallData(:,18): call's mid price (C)
C_2nd = CallData(tmpIdx_C_2nd, 18);

Kp_1st = PutData(tmpIdx_P_1st, 3);  % PutData(:,3): put's strike price (Kp)
Kp_2nd = PutData(tmpIdx_P_2nd, 3);

P_1st = PutData(tmpIdx_P_1st, 18);  % PutData(:,18): put's mid price (P)
P_2nd = PutData(tmpIdx_P_2nd, 18);

today_ = unique(CallData(:,1));
today__ = unique(PutData(:,1));

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
%%

DTM_1st = daysdif(today_, tmp_Expiries_C(1), 13);
DTM_2nd = daysdif(today_, tmp_Expiries_C(2), 13);