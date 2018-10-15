function [T_VIX] = VIXConstruction(T_VIXrawVolCurve)
% Correct: checked with VIX white paper's sample data
date_ = unique(T_VIXrawVolCurve.date);
exdate = unique(T_VIXrawVolCurve.exdate);
TTM = unique(T_VIXrawVolCurve.TTM);
r = unique(T_VIXrawVolCurve.r);
fwd = unique(T_VIXrawVolCurve.fwd);
DTM_BUS = unique(T_VIXrawVolCurve.DTM_BUS);
isSTD = unique(T_VIXrawVolCurve.isSTD);

if length(date_) ~=1 || length(exdate)~=1 || length(TTM) ~= 1 || ...
        length(r) ~=1 || length(fwd) ~= 1 || length(DTM_BUS) ~= 1 || length(isSTD) ~= 1
    error('length(date_) ~=1 || length(exdate)~=1 || length(TTM) ~= 1 || length(r) ~=1 || length(fwd) ~= 1 || length(DTM_BUS) ~= 1 || length(isSTD) ~= 1.');
end

K0 = T_VIXrawVolCurve.K(find(T_VIXrawVolCurve.K < fwd, 1, 'last')); % First K below F (fwd)
if isempty(K0)
    error('isempty(K0).');
end

dK = zeros(length(T_VIXrawVolCurve.K), 1);
for i=2:length(T_VIXrawVolCurve.K)-1
    dK(i) = (T_VIXrawVolCurve.K(i+1) - T_VIXrawVolCurve.K(i-1)) / 2;
end
dK(1) = T_VIXrawVolCurve.K(2) - T_VIXrawVolCurve.K(1);
dK(end) = T_VIXrawVolCurve.K(end) - T_VIXrawVolCurve.K(end-1);

VarIX = 2/TTM * exp(r*TTM) * sum( dK ./ (T_VIXrawVolCurve.K.^2) .* T_VIXrawVolCurve.OpPrice ) - ...
    1/TTM * (fwd/K0 - 1)^2;

%%
DTM_CAL = exdate - date_;

T_VIX = table(date_, exdate, VarIX, TTM, DTM_BUS, DTM_CAL, isSTD, ...
    'VariableNames', {'date', 'exdate', 'VarIX', 'TTM', 'DTM_BUS', 'DTM_CAL', 'isSTD'});
