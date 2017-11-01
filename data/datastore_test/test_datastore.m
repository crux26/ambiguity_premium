ds = tabularTextDatastore('airlinesmall.csv')
ds.SelectedVariableNames = {'DepTime','DepDelay'};
preview(ds)

% You can specify the values in your data which represent missing values.
% In airlinesmall.csv, missing values are represented by NA.
ds.TreatAsMissing = 'NA';

% If all of the data in the datastore for the variables of interest fit in memory,
% you can read it using the readall function.
T = readall(ds);

% Otherwise, read the data in smaller subsets that do fit in memory, using the read function.
% By default, the read function reads from a TabularTextDatastore 20000 rows at a time.
% However, you can change this value by assigning a new value to the ReadSize property.
ds.ReadSize = 15000;

% Reset the datastore to the initial state before re-reading, using the reset function.
reset(ds);

% By calling the read function within a while loop,
% you can perform intermediate calculations on each subset of data,
% and then aggregate the intermediate results at the end.
% This code calculates the maximum value of the DepDelay variable.
X = [];
while hasdata(ds)
      T = read(ds);
      X(end+1) = max(T.DepDelay);
end
maxDelay = max(X);

% If the data in each individual file fits in memory,
% you can specify that each call to read should read one complete file rather than a specific number of rows.
reset(ds)
ds.ReadSize = 'file';
X = [];
while hasdata(ds)
      T = read(ds);
      X(end+1) = max(T.DepDelay);
end
maxDelay = max(X);