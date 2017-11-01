clear; clc;
ds = tabularTextDatastore('airlinesmall.csv','TreatAsMissing','NA')
ds.SelectedVariableNames = 'Distance';
preview(ds)

outds = mapreduce(ds, @MeanDistMapFun, @MeanDistReduceFun);
readall(outds)