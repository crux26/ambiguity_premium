function MeanDistMapFun(data, info, intermKVStore)
    distances = data.Distance(~isnan(data.Distance));
    sumLenValue = [sum(distances)  length(distances)];
    add(intermKVStore, 'sumAndLength', sumLenValue);
end