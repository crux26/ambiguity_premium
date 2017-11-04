clear;clc;
isDorm = true;
if isDorm == true
    Drive="F:";
else
    Drive="D:";
end
addpath(sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium\\data', Drive));
load('rawOpData_2nd_Trim.mat');
%% 30Jun99==730301. CallData.date==730301.exdate=[17Jul99,18Sep99,18Dec99]. PutData.date==730301.exdate=[17Jul99,21Aug99,18Sep99].
% --> CallData.TTM=[18,80,181]. PutData.TTM=[18,52,80,171]. TTM < 70D
% (calendar) are discarded. Thus, this is problematic.
CallData = CallData(CallData(:,1) ~= 730301, :);
PutData = PutData(PutData(:,1) ~= 730301, :);
    
%%
[date_, idx_date_] = unique(CallData(:,1));
idx_date_ = [idx_date_; length(CallData(:,1))+1]; % to include the last index.
jj=1;
cnt_exdate=0;
isNotOne=[];
isNotOne_ExdatesNum=[];
isNotOne_TTM=[];
% Below takes 0.05s (DORM PC)
tic
for jj=1:length(date_)
    tmpIdx_C = idx_date_(jj):(idx_date_(jj+1)-1) ;
    exDates_ = unique(CallData(tmpIdx_C,2));
    if length(exDates_) ~= 2
        isNotOne(end+1) = date_(jj);
        isNotOne_ExdatesNum(end+1) = length(exDates_);
        isNotOne_TTM(end+1) = exDates_ - date_(jj) ;
%         if length(isNotOne_TTM) == 96
%             break;
%         end
    end
    cnt_exdate = cnt_exdate + length(exDates_);
end
toc
rmpath(sprintf('%s\\Dropbox\\GitHub\\ambiguity_premium\\data', Drive));
%%
% disp(any(isNotOne_ExdatesNum~=1));
% isNotTTM_30D = find(isNotOne_TTM~=30);
% isTTM_30D = find(isNotOne_TTM==30);
% find(isNotOne_TTM < 30)

%% length(exDates_)~=2 && TTM<30D --> j==881, date_=730301, exdate_=730318 (TTM=17)
%% This is the only such point.

%% other length(exDates_)~=2: TTM > 30D