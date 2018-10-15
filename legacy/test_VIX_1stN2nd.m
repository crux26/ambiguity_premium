%% VIX_mid, VIX_bid, VIX_ask, respectively.
clear;clc;
isDorm = false;
if isDorm == true
    drive='E:';
else
    drive='E:';
end

homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\main_functions', homeDirectory));
CT = '15:00:00';

load('E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.mat', 'VIX');
CBOE_VIX = VIX;
% load(sprintf('%s\\VIX_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');
% load(sprintf('%s\\VIX_ask_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');
load(sprintf('%s\\VIX_bid_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');
VIX.VIX_1st = sqrt(VarIX_1st.VarIX);
VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX);

[date_, ~] = unique(CBOE_VIX.date, 'rows');
[date__, ~] = unique(VIX.date, 'rows');
[date___, ~] = unique(VarIX_1st.date, 'rows');
[date____, ~] = unique(VarIX_2nd.date, 'rows');

date_intersect = intersect(intersect(intersect(date_, date__), date___), date____);
idx_ = ismember(date_, date_intersect);
idx__ = ismember(date__, date_intersect);
idx___ = ismember(date___, date_intersect);
idx____ = ismember(date____, date_intersect);

CBOE_VIX = CBOE_VIX(idx_, :);
VIX = VIX(idx__, :);
VarIX_1st = VarIX_1st(idx___, :);
VarIX_2nd = VarIX_2nd(idx____, :);

clear date_ date__ date___ date____ idx_ idx__ idx___ idx____;

%%
VIX.TTM_bus_1st = daysdif(VIX.date, VIX.exdate_1st, 13);
idx = VIX.TTM_bus_1st > 10;
VIX = VIX(idx, :);
VIX.VIX = sqrt(VarIX_1st.VarIX(idx));
VIX.VIX = sqrt(VarIX_2nd.VarIX(idx));
% VIX.TTM_bus_2nd = daysdif(VIX.date, VIX.exdate_2nd, 13);
% VIX.VIX(~idx) = sqrt(VarIX_2nd.VarIX(~idx)) .* sqrt(30 ./ VIX.TTM_bus_2nd(~idx));

%% Below returns the largest error (whether adjusted or not)

VIX_ = VIX_30Davg(CT, VarIX_1st(idx, :), VarIX_2nd(idx, :));
VIX.VIX = VIX_.VIX * 0.01;

figure('position', [400, 100, 1200, 800]);
plot(VIX.date, VIX.VIX, CBOE_VIX.date, CBOE_VIX.vix );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX', 'CBOE VIX', 'Location', 'northwest');
title('VIX level');

%% VIX_1st only
% [date_, ~] = unique(CBOE_VIX.date, 'rows');
% [date__, ~] = unique(VIX.date, 'rows');
% date_intersect = intersect(date_, date__);
% idx_ = ismember(date_, date_intersect);
% idx__ = ismember(date__, date_intersect);
% 
% CBOE_VIX = CBOE_VIX(idx_, :);
% VIX = VIX(idx__, :);
% clear date_ date__ idx_ idx__;

figure('position', [400, 100, 1200, 800]);
plot(VIX.date, VIX.VIX_1st, CBOE_VIX.date, CBOE_VIX.vix );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX 1st', 'CBOE VIX', 'Location', 'northwest');
title('VIX level');

%% VIX_2nd only
figure('position', [400, 100, 1200, 800]);
plot(VIX.date, VIX.VIX_2nd, CBOE_VIX.date, CBOE_VIX.vix );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX 2nd', 'CBOE VIX', 'Location', 'northwest');
title('VIX level');
