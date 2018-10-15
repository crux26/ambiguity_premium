%% Import data from SAS, PROC EXPORT.
filename = 'E:\Dropbox\GitHub\ambiguity_premium\result\rawdata\VW_SeqSort2_VIX.csv';
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
bar3(reshape(VWIndepSort.RET, 5, 5)');
title('ret');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\ret.png');


figure;
bar3(reshape(VWIndepSort.exret, 5, 5)');
title('exret');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\exret.png');

figure;
bar3(reshape(VWIndepSort.IVSkew, 5, 5)');
title('VWIndepSort, IVSkew');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\IVSkew.png');

figure;
bar3(reshape(VWIndepSort.VRP, 5, 5)');
title('VRP');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\VRP.png');

figure;
bar3(reshape(VWIndepSort.VS, 5, 5)');
title('VS');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\VS.png');

figure;
bar3(reshape(VWIndepSort.beta_MKTRF, 5, 5)');
title('beta MKTRF');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\beta_MKTRF.png');

figure;
bar3(reshape(VWIndepSort.beta_VIX, 5, 5)');
title('beta VIX');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\beta_VIX.png');

figure;
bar3(reshape(VWIndepSort.beta_VIX_spread_norm, 5, 5)');
title('beta VIX spread norm');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\beta_VIX_spread_norm.png');

figure;
bar3(reshape(VWIndepSort.MktCap, 5, 5)');
title('MktCap');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\MktCap.png');

figure;
bar3(reshape(VWIndepSort.SIZE, 5, 5)');
title('size');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\SIZE.png');

figure;
bar3(reshape(VWIndepSort.BM, 5, 5)');
title('BM');
xlabel('beta VIX sprad norm rank');
ylabel('beta MKTRF rank');
zlim auto;
saveas(gcf, 'E:\Dropbox\GitHub\ambiguity_premium\result\VW_SeqSort_VIX\BM.png');

%%
close all;