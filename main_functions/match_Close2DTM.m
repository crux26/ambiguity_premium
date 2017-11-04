function [r] = match_Close2DTM(today_, caldt, DTM, TDDURATN, TDYLD)
% today_: scalar.
% caldt: vector. "table_.CALDT". length(caldt)==today's length of term structure
idx_today = find(today_ == caldt);
[~, idx_Close2DTM] = min(abs(DTM - TDDURATN(idx_today) ) );
idx_Close2DTM = idx_today( idx_Close2DTM );
r = TDYLD(idx_Close2DTM);