%% main_2(): plotting
%% VIX_mid, VIX_bid, VIX_ask, respectively.
clear;clc;
isDorm = 1;
if isDorm == true
    drive='E:';
else
    drive='E:';
end

homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\main_functions', homeDirectory));
load('E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.mat', 'VIX'); CBOE_VIX = VIX;
clear VIX;

%% Below codes are valid (just annotated)
load(sprintf('%s\\VIX_gen', genData_path)); VIX_mid = VIX.VIX * 0.01;
load(sprintf('%s\\VIX_bid_gen', genData_path)); VIX_bid = VIX.VIX * 0.01;
load(sprintf('%s\\VIX_ask_gen', genData_path)); VIX_ask = VIX.VIX * 0.01;

VIX = table(VarIX_1st.date, datestr(VarIX_1st.date), VIX_bid, VIX_mid, VIX_ask, ...
    'VariableNames', {'date', 'datestr', 'VIX_bid', 'VIX_mid', 'VIX_ask'});
VIX.VIXSpread = VIX_ask - VIX_bid;
VIX.bid_diff = VIX_mid - VIX_bid;
VIX.ask_diff = VIX_ask - VIX_mid;
[~, VIX.dayname] = weekday(VIX.date);

%% VIX_bid, VIX_mid, VIX_ask
figure('Position',[300 200 800 600]);
subplot(3,1,1);
plot(VIX.date, VIX.VIX_bid); 
grid on;
legend('VIX bid');
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0 1]);
datetick('x', 12, 'keepticks', 'keeplimits');

subplot(3,1,2);
plot(VIX.date, VIX.VIX_mid); 
grid on;
legend('VIX mid');
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0 1]);
datetick('x', 12, 'keepticks', 'keeplimits');

% Outlier in VIX_ask: 17DEC2014 (24AUG2015, ...)
subplot(3,1,3);
plot(VIX.date, VIX.VIX_ask); 
grid on;
legend('VIX ask');
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0 1]);
datetick('x', 12, 'keepticks', 'keeplimits');

%% VIX_bid, VIX_mid, VIX_ask
figure;
plot(VIX.date, VIX.VIX_bid, VIX.date, VIX.VIX_mid, VIX.date, VIX.VIX_ask); 
grid on;
legend('VIX bid', 'VIX mid', 'VIX ask');
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');


%% bid diff
figure;
plot(VIX.date, VIX.bid_diff);
grid on;
legend('bid spread');
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');

%% ask diff
figure;
plot(VIX.date, VIX.ask_diff);
grid on;
legend('ask spread');
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');

%
idx_neg = find(VIX.ask_diff<0);
date_ask_odd = VIX.date(idx_neg, :);
date_ask_odd = datestr(date_ask_odd);

idx_pos = VIX.ask_diff > 0;
VIX = VIX(idx_pos, :);


%% Plotting VIXSpread and others
figure;
plot(VIX.date, VIX.VIXSpread);
grid on;
legend('mid spread');
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');

%% 
% a = sortrows(VIX, 6);   % 6-th col.: VIXSpread
