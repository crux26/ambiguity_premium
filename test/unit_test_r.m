% unit_test_r

% r_1st, r_2nd: bond-equivalent yields of the US T-bill maturing closest to the expiration dates of relevant SPX options
addpath('D:\Dropbox\GitHub\ambiguity_premium\data');
addpath('D:\Dropbox\GitHub\ambiguity_premium');
load('tfz_dly_ts2.mat', 'table_');
table_ = sortrows(table_, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.

today_ = datenum('08Oct2013');
DTM_1st = 25; DTM_2nd = 32;

%% matching r_*.
idx_today = find(today_ == table_.CALDT);
r_1st = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_1st, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));
r_2nd = match_Close2DTM(today_, table_.CALDT(idx_today), DTM_2nd, table_.TDDURATN(idx_today), table_.TDYLD(idx_today));
% r_1st = 0.0305 * 0.01;
% r_2nd = 0.0286 * 0.01;

rmpath('D:\Dropbox\GitHub\ambiguity_premium');
rmpath('D:\Dropbox\GitHub\ambiguity_premium\data');
