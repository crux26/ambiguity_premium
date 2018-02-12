%% 30Jun99==730301. CallData.date==730301.exdate=[17Jul99,18Sep99,18Dec99]. PutData.date==730301.exdate=[17Jul99,21Aug99,18Sep99].
% --> CallData.TTM=[18,80,181]. PutData.TTM=[18,52,80,171]. TTM < 70D
% (calendar) are discarded. Thus, this is problematic.
% CallData = CallData(CallData.date ~= 730301, :);
% PutData = PutData(PutData.date ~= 730301, :);


%% Below returns error because on 30JUN1999, only 17JUL1999 && 18SEP1999 available for Call.
% [idx_exdate_, exdate_] = find(diff(CallData.exdate)~=0);
% [idx_exdate__, exdate__] = find(diff(PutData.exdate)~=0);
% 
% %% START AGAIN FROM HERE.
% if exdate_ ~= exdate__
%     error('#exdates(call)~=#exdates(put). Check the data.');
% end
%% On the other hand, two 21AUG1999 available for Put.

