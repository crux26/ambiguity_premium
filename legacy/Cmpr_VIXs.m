%% import_VIX() -> Cmpr_VIXs()

%% unTrimmed data returns closer result to CBOE VIX.
%% CBOE VIX seems not to adjust for irregular prices at tails. See the white paper.
clear; clc;
isDorm = false;
if isDorm == true
    drive='E:';
else
    drive='E:';
end

homeDirectory = sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium', drive);
genData_path = sprintf('%s\\data\\gen_data', homeDirectory);

addpath(sprintf('%s\\main_functions', homeDirectory));

OptionsData_genData_path = sprintf('%s\\Dropbox\\GitHub\\OptionsData\\data\\gen_data', drive);

load(sprintf('%s\\raw_tfz_dly_ts2.mat', OptionsData_genData_path), 'table_');
T_tfz_dly_ts2 = table_;
T_tfz_dly_ts2 = sortrows(T_tfz_dly_ts2, [2, 7], {'ascend', 'descend'});  % [2, 7]: CALDT, TDDURATN, respectively.

% load(sprintf('%s\\OpData_dly_2nd_BSIV_near30D_Trim.mat', genData_path));

load('E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.mat', 'VIX'); CBOE_VIX = VIX;
% load(sprintf('%s\\VIX_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX'); % VIX_mid
load(sprintf('%s\\VIX_ask_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');
% load(sprintf('%s\\VIX_bid_gen', genData_path), 'VarIX_1st', 'VarIX_2nd', 'VIX');
VIX.VIX = VIX.VIX*0.01;
VIX.VIX_1st = sqrt(VarIX_1st.VarIX);
VIX.VIX_2nd = sqrt(VarIX_2nd.VarIX);

%%
% [date_, ~] = unique([CBOE_VIX.date, CBOE_VIX.exdate], 'rows');
% [date__, ~] = unique([VIX.date, VIX.exdate], 'rows');
[date_, ~] = unique(CBOE_VIX.date, 'rows');
[date__, ~] = unique(VIX.date, 'rows');

date_intersect = intersect(date_, date__);
idx_ = ismember(date_, date_intersect);
idx__ = ismember(date__, date_intersect);

CBOE_VIX = CBOE_VIX(idx_, :);
VIX = VIX(idx__, :);

%% CBOE VIX
figure('position', [400, 100, 1200, 800]);
plot(VIX.date, CBOE_VIX.vix);
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('CBOE VIX', 'Location', 'northwest');
title('VIX level');

%% VIX_1st, VIX_2nd
figure('position', [400, 100, 1200, 800]);
plot(VIX.date, VIX.VIX_1st, VIX.date, VIX.VIX_2nd );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX 1st', 'my VIX 2nd', 'Location', 'northwest');
title('VIX level');

%% VIX_2nd, scaled VIX_2nd
idx = 1:size(VIX, 1);
date_pair = [datenum(VIX.date), datenum(VIX.exdate_2nd)];
date_pair = date_pair(idx, :);
dateDiff = daysdif(date_pair(:,1), date_pair(:,2));
myVIX_2nd = VIX.VIX_2nd(idx) .* sqrt (30 ./ dateDiff);

figure('position', [400, 100, 1200, 800]);
plot(VIX.date, VIX.VIX_2nd, VIX.date, myVIX_2nd );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX 2nd', 'scaled my VIX 2nd', 'Location', 'northwest');
title('VIX level');

%% VIX_1st, VIX_2nd, VIX(30D wavg of two)
figure('position', [400, 100, 1200, 800]);
plot(VIX.date, VIX.VIX, VIX.date, VIX.VIX_1st, VIX.date, VIX.VIX_2nd );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX', 'my VIX 1st', 'my VIX 2nd', 'Location', 'northwest');
title('VIX level');

%% Indv. plot
figure('position', [400, 100, 1200, 800]);
subplot(3, 1, 1);
plot(VIX.date, VIX.VIX, VIX.date, mean(VIX.VIX)*ones(length(VIX.VIX), 1) );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX', 'mean(my VIX)', 'Location', 'northwest');
title('VIX level');

subplot(3, 1, 2);
plot(VIX.date, CBOE_VIX.vix, VIX.date, mean(CBOE_VIX.vix)*ones(length(VIX.VIX), 1));
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('CBOE VIX', 'mean(CBOE VIX)', 'Location', 'northwest');
title('VIX level');

% Cmpr
subplot(3,1,3);
plot(VIX.date, VIX.VIX, VIX.date, CBOE_VIX.vix, ...
    VIX.date, mean(VIX.VIX)*ones(length(VIX.VIX), 1), VIX.date, mean(CBOE_VIX.vix)*ones(length(VIX.VIX), 1) );
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim([0, 1]);
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('my VIX', 'CBOE VIX', 'mean(my VIX)', 'mean(CBOE VIX)', 'Location', 'northwest');
title('VIX comparison');

%% CBOE_VIX - VIX.VIX
VIX_diff = CBOE_VIX.vix - VIX.VIX;
figure('position', [400, 100, 1200, 400]);
plot(VIX.date, VIX_diff);
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('CBOE VIX - my VIX', 'Location', 'northwest');
title('VIX diff');

%% CBOE_VIX - VIX.VIX_1st
VIX_diff = CBOE_VIX.vix - VIX.VIX_1st;
figure('position', [400, 100, 1200, 400]);
plot(VIX.date, VIX_diff);
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('CBOE VIX - my VIX 1st', 'Location', 'northwest');
title('VIX diff');


%% CBOE_VIX - VIX.VIX_2nd
VIX_diff = CBOE_VIX.vix - VIX.VIX_2nd;
figure('position', [400, 100, 1200, 400]);
plot(VIX.date, VIX_diff);
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('CBOE VIX - my VIX 2nd', 'Location', 'northwest');
title('VIX diff');

%% CVOW_VIX - scaled VIX.VIX_2nd
% idx = find(datenum(VIX.date) < date_SPXW_beg);
idx = 1:size(VIX, 1);
date_pair = [datenum(VIX.date), datenum(VIX.exdate_2nd)];
date_pair = date_pair(idx, :);
dateDiff = daysdif(date_pair(:,1), date_pair(:,2));
myVIX_2nd = VIX.VIX_2nd(idx) .* sqrt (30 ./ dateDiff);

VIX_diff = CBOE_VIX.vix - myVIX_2nd;
figure('position', [400, 100, 1200, 400]);
plot(VIX.date, VIX_diff);
xlim([VIX.date(1)-200, VIX.date(end)+200]);
ylim auto;
datetick('x', 12, 'keepticks', 'keeplimits');
grid on;
legend('CBOE VIX - my VIX 2nd', 'Location', 'northwest');
title('VIX diff');
