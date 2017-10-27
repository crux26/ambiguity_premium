
addpath('D:\Dropbox\GitHub\ambiguity_premium');

today_ = datenum('08Oct2013');
CT = '09:46:00';
DTM_1st = 25; DTM_2nd = 32;
symbol_1st = 'SPX'; symbol_2nd = 'SPXW';
TTM_1st = TTM4VIX(CT, DTM_1st, symbol_1st); % TTM_1st = 0.0683486;
TTM_2nd = TTM4VIX(CT, DTM_2nd, symbol_2nd); % TTM_2nd = 0.0882686;

rmpath('D:\Dropbox\GitHub\ambiguity_premium');