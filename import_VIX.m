%% import_VIX() -> Cmpr_VIXs()

%% Initialize variables.
clear; clc;
filename = 'E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.csv';
delimiter = ',';
startRow = 2;

%% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Create output variable
VIX = table(dataArray{1:end-1}, 'VariableNames', {'date','vix'});

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%%
date_ = zeros(size(VIX, 1), 1);
for i = 1 : size(VIX, 1)
    date_(i) = datenum(VIX.date{i});
end
VIX.date = date_;
VIX.exdate = daysadd(VIX.date, 30);

%%
save('E:\Dropbox\GitHub\ambiguity_premium\data\gen_data\CBOE_VIX.mat', 'VIX');
