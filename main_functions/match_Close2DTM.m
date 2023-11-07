function [r] = match_Close2DTM(DTM, T_tfz_dly_ts2)
%
% Matches T-bill whose duration is closest to given option's DTM.
%
% today_: scalar.
% caldt: vector. "table_.CALDT". length(caldt)==today's length of term structure
% CALDT = T_tfz_dly_ts2.CALDT; % if ~scalar, then problem

TDDURATN = T_tfz_dly_ts2.TDDURATN;
TDYLD = T_tfz_dly_ts2.TDYLD;

if any(ismember(T_tfz_dly_ts2.TDDURATN, DTM))
	[~, idx_min1st] = min(abs(DTM - TDDURATN) );
	r = T_tfz_dly_ts2.TDYLD(idx_min1st);
else
	[~, idx_min1st] = min(abs(DTM - TDDURATN) );
	idx = ~ismember(TDDURATN, TDDURATN(idx_min1st));
	TDDURATN_ = TDDURATN(idx);
	TDYLD_ = TDYLD(idx);
	[~, idx_min2nd] = min(abs(DTM - TDDURATN_) );
	
	% linear interp for 2 closest
	r = interp1([TDDURATN(idx_min1st), TDDURATN_(idx_min2nd)], ...
		[TDYLD(idx_min1st), TDYLD_(idx_min2nd)], ...
		DTM, 'linear', 'extrap');
end

	



%% legacy codes - If the code doesn't work for ambiguity, change back to legacy ones.
% function [r] = match_Close2DTM(today_, CALDT, DTM, TDDURATN, TDYLD)
%
%
% idx_today = find(today_ == CALDT);
% [~, idx_Close2DTM] = min(abs(DTM - TDDURATN(idx_today) ) );
% idx_Close2DTM = idx_today( idx_Close2DTM );
% r = TDYLD(idx_Close2DTM);
