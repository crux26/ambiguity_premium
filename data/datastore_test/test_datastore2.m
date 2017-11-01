%% Create a datastore
ds = datastore('airlinesmall.csv','TreatAsMissing','NA');
ds.MissingValue = 0;
ds.SelectedVariableNames = 'ArrDelay';
data = preview(ds)

%% Read subsets of data
ds.ReadSize = 15000;

sums = [];
counts = [];
while hasdata(ds)
    T = read(ds);
    
    sums(end+1) = sum(T.ArrDelay);
    counts(end+1) = length(T.ArrDelay);
end

avgArrivalDelay = sum(sums)/sum(counts)

reset(ds)

%% Read one file at a time
ds.ReadSize = 'file';
sums = [];
counts = [];
while hasdata(ds)
    T = read(ds);
    
    sums(end+1) = sum(T.ArrDelay);
    counts(end+1) = length(T.ArrDelay);
end
avgArrivalDelay = sum(sums)/sum(counts)