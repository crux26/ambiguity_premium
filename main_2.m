%% main(), main_bid(), main_ask() --> main2()
load('VIX_gen'); VIX_mid = VIX.VIX * 0.01;
load('VIX_bid_gen'); VIX_bid = VIX.VIX * 0.01;
load('VIX_ask_gen'); VIX_ask = VIX.VIX * 0.01;

VIX = table(VarIX_1st.date, datestr(VarIX_1st.date), VIX_bid, VIX_mid, VIX_ask, ...
    'VariableNames', {'date', 'datestr', 'VIX_bid', 'VIX_mid', 'VIX_ask'});
VIX.VIXSpread = VIX_ask - VIX_bid;
[~, VIX.dayname] = weekday(VIX.date);

%% Plotting VIXSpread and others

% figure;
% plot(VIX.date, VIX.VIXSpread);
% legend('VIX Spread');
% xlim([VIX.date(1)-200, VIX.date(end)+200]);
% ylim auto;
% datetick('x', 12, 'keepticks', 'keeplimits');
% 
% figure;
% plot(VIX.date, VIX.VIX_bid, VIX.date, VIX.VIX_mid, VIX.date, VIX.VIX_ask);
% legend('VIX bid', 'VIX mid', 'VIX ask');
% xlim([VIX.date(1)-200, VIX.date(end)+200]);
% ylim auto;
% datetick('x', 12, 'keepticks', 'keeplimits');

%% 
a = sortrows(VIX, 6);   % 6-th col.: VIXSpread