function TTM = TTM4VIX_backup(CT, DTM, symbol)
% CT: e.g. '09:46:00'
% DTM: days to maturity
% symbol: option symbol (e.g. SPX)

% Find Hour, Minute, Second from the time using datevec function
[~, ~, ~, Hour, Minute, Second] = datevec(CT);

% M_CurrentDay: minutes remaining until midnight("2400") of the current day
% 1440: The number of minutes in a day (60*24)
M_CurrentDay = 1440 - (Hour*60 + Minute + Second/60);

% M_SettlementDay: minutes from midnight("0000") until 0830 for SPX, until 1500 for SPXW
if strcmp(symbol, 'SPX')
    M_SettlementDay = (8*60 + 30 + 0/60); % SPX's expiration time: 0830
elseif strcmp(symbol, 'SPXW') % || strcmp(symbol, 'SPXPM')
    M_SettlementDay = (15*60 + 0 + 0/60); % SPXW's expiration time: 1500
end

% M_OtherDays: total minutes in the days between current day and expiration day
M_OtherDays = (DTM - 1) * 1440;

%% TTM: same for call, put
% 525600: The numberof minutes in a year (60*24*365)
TTM = (M_CurrentDay + M_SettlementDay + M_OtherDays)/525600;

