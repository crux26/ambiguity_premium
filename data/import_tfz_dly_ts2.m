%% Import the data, extracting spreadsheet dates in Excel serial date format
clear;clc;
[~, ~, raw, dates] = xlsread('D:\Dropbox\GitHub\ambiguity_premium\data\rawdata\tfz_dly_ts2.xlsx','tfz_dly_ts2','A2:AC19997','',@convertSpreadsheetExcelDates);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
stringVectors = string(raw(:,[4,5,6,18,19,20,21,26,27,28,29]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[1,3,7,8,9,10,11,12,13,14,15,16,17,22,23,24,25]);
dates = dates(:,2);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),dates); % Find non-numeric cells
dates(R) = {NaN}; % Replace non-numeric Excel dates with NaN

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
KYTREASNOX = data(:,1);
CALDT = datetime([dates{:,1}].', 'ConvertFrom', 'Excel');
RDTREASNO = data(:,2);
RDTREASNO_FLG = categorical(stringVectors(:,1));
RDCRSPID = categorical(stringVectors(:,2));
RDCRSPID_FLG = categorical(stringVectors(:,3));
TDBID = data(:,3);
TDASK = data(:,4);
TDNOMPRC = data(:,5);
TDBIDYLD = data(:,6);
TDASKYLD = data(:,7);
TDYLD = data(:,8);
TDDURATN = data(:,9);
TDBIDFWD1 = data(:,10);
TDASKFWD1 = data(:,11);
TDAVEFWD1 = data(:,12);
TDDURFWD1 = data(:,13);
TDBIDFWD4 = stringVectors(:,4);
TDASKFWD4 = stringVectors(:,5);
TDAVEFWD4 = stringVectors(:,6);
TDDURFWD4 = stringVectors(:,7);
TDBIDHLD1 = data(:,14);
TDASKHLD1 = data(:,15);
TDAVEHLD1 = data(:,16);
TDDURHLD1 = data(:,17);
TDBIDHLD4 = stringVectors(:,8);
TDASKHLD4 = stringVectors(:,9);
TDAVEHLD4 = stringVectors(:,10);
TDDURHLD4 = stringVectors(:,11);

% For code requiring serial dates (datenum) instead of datetime, uncomment the following line(s) below to return the
% imported dates as datenum(s).

CALDT=datenum(CALDT);

%% Clear temporary variables
clearvars data raw dates stringVectors R;
table_ = table(KYTREASNOX, CALDT, RDTREASNO, RDCRSPID, TDNOMPRC, TDYLD, TDDURATN);
save('tfz_dly_ts2.mat', 'table_');