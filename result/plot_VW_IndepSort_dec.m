%% Import data from SAS, PROC EXPORT.
filename = 'E:\Dropbox\GitHub\ambiguity_premium\result\rawdata\VW_IndepSort_dec.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

VWIndepSort = table(dataArray{1:end-1}, 'VariableNames', {'beta_MKTRF_rank','beta_VIX_spread_norm_rank','RET','exret','IVSkew','VRP','VS','beta_MKTRF','beta_VIX','beta_VIX_spread_norm','MktCap','SIZE','BM'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% After running, seemingly irrelevants: SIZE, BM, IVSkew, VRP, VS, 
% beta_MKTRF, beta_VIX_spread_norm seems to carry its premium w/i its rank.
% Seems beta_VIX is a stronger determinant than beta_VIX_spread_norm.

figure;
bar3(reshape(VWIndepSort.RET, 10, 10)');
title('ret');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\ret.png');


figure;
bar3(reshape(VWIndepSort.exret, 10, 10)');
title('exret');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\exret.png');

figure;
bar3(reshape(VWIndepSort.IVSkew, 10, 10)');
title('VWIndepSort, IVSkew');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\IVSkew.png');

figure;
bar3(reshape(VWIndepSort.VRP, 10, 10)');
title('VRP');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\VRP.png');

figure;
bar3(reshape(VWIndepSort.VS, 10, 10)');
title('VS');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\VS.png');

figure;
bar3(reshape(VWIndepSort.beta_MKTRF, 10, 10)');
title('beta MKTRF');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\beta_MKTRF.png');

figure;
bar3(reshape(VWIndepSort.beta_VIX, 10, 10)');
title('beta VIX');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\beta_VIX.png');

figure;
bar3(reshape(VWIndepSort.beta_VIX_spread_norm, 10, 10)');
title('beta VIX spread norm');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\beta_VIX_spread_norm.png');

figure;
bar3(reshape(VWIndepSort.MktCap, 10, 10)');
title('MktCap');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\MktCap.png');

figure;
bar3(reshape(VWIndepSort.SIZE, 10, 10)');
title('size');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\SIZE.png');

figure;
bar3(reshape(VWIndepSort.BM, 10, 10)');
title('BM');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_IndepSort\BM.png');

%%
close all;