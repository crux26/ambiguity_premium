%% ReplicateVIX
% Near-Term
% Strike Call Put
Data{1} = [775 125.48 0.11;...
      800 100.79 0.41;...
      825 76.70 1.30;...
      850 54.01 3.60;...
      875 34.05 8.64;...
      900 18.41 17.98;...
      925 8.07 32.63;...
      950 2.68 52.33;...
      975 0.62 75.16;...
      1000 0.09 99.61;...
      1025 0.01 124.52];
% Next Term  
% Strike Call Put
Data{2} = [775 128.78 2.72;...
      800 105.85 4.76;...
      825 84.14 8.01;...
      850 64.13 12.97;...
      875 46.38 20.18;...
      900 31.40 30.17;...
      925 19.57 43.31;...
      950 11.00 59.70;...
      975 5.43 79.10;...
      1000 2.28 100.91;...
      1025 0.78 124.38];
 
 %Time_To_Maturity
 TM = [16;44];  	
 %Risk_Free_Rate  
 Rf = 1.1625/100; %Per Annum
 % Difference between Calls and Puts (Absolute Value)
 DF{1} = abs(Data{1}(:,2) - Data{1}(:,3));
 DF{2} = abs(Data{2}(:,2) - Data{2}(:,3));
 % Current Time
 CT = '08:30:00';
 % FInd Hour, Minute, Second from the time using datevec function
 [Year, Month, Day, Hour, Minute, Second] = datevec(CT);
 %In Years
 %1440 is the number of minutes in a day and 510 is the number of minutes to 8:30 AM which
 %is the time the option expires on its expiration date
 NumYears(1) = [1440 - (Hour * 60 + Minute + Second/60) + 510]/(1440 * 365) + [(TM(1) - 2)/365];
 NumYears(2) = [1440 - (Hour * 60 + Minute + Second/60) + 510]/(1440 * 365) + [(TM(2) - 2)/365];
 % In days
 NumDays = NumYears .* 365;
 % Find the minimum of the difference in Call and Put
 % Prices and Get the corresponding Strike Price.
 ATM(1,:) = Data{1}(find(DF{1}==min(DF{1})),:);
 ATM(2,:) = Data{2}(find(DF{2}==min(DF{2})),:);
 % Calculate Forward Price Level and Referential Strike
 % Application of PUT CALL Parity
 Level = ATM(:,1) + exp(Rf*NumYears(:)) .* (ATM(:,2) - ATM(:,3));
 %Reference Strike
 for i = 1:2
     Strike = ATM(i,1);
     if(ATM(i,2)>=ATM(i,3))
         Ref_Strike(i)=ATM(i,1);
     else
         Ref_Strike(i) = Data{i}(find(Data{i}(:,1) < ATM(i,1),1,'last'),1);
     end
     % Differences of Strikes
     Temp = diff(Data{i}(:,1));
     Delta_Strike{i} = [Temp(1);Temp];
   %{
    ? If the strike is above the ¡°reference strike¡± , use the call price
    ? If the strike is below the ¡°reference strike¡± , use the put price
    ? If the strike equals the ¡°reference strike¡± , use the average of the call
      and put prices
     %}
     cpval= zeros(size(Data{i},1),1);
     cid = find(Data{i}(:,1) > Ref_Strike(i));
     cpval(cid) = Data{i}(cid,2);
     pid = find(Data{i}(:,1) < Ref_Strike(i));
     cpval(pid) = Data{i}(pid,3);
     Aid = find(Data{i}(:,1) == Ref_Strike(i));
     cpval(Aid) = (Data{i}(Aid,2) + Data{i}(Aid,3))/2;
 	
     % Now do the math as given in the paper vixwhite.pdf
 	
     vix{i} = Delta_Strike{i} * exp(Rf*NumYears(i)) .* cpval ./(Data{i}(:,1).^2);
     Var(i) = (2/NumYears(i)) * sum(vix{i}) - ((Level(i)/Ref_Strike(i) - 1).^2)/NumYears(i);
 	
     % Center the data to 30 days
     if(i==1)
        Term(i) = NumYears(i) * Var(i) * ((NumDays(i+1)-30)/(NumDays(i+1)-NumDays(i)));
     elseif(i==2)
        Term(i) = NumYears(i) * Var(i) * ((-NumDays(i-1)+30)/(NumDays(i)-NumDays(i-1)));
     end
     	
 	
 end
 
    % Final Vix Calculation
    VIX = sqrt(sum(Term) * 365/30) * 100
