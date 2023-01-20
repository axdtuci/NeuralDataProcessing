
tetrodeData = nan(length(binningVector)-1, numTetrodes, length(Hyp));
PopVData = nan(length(binningVector)-1, length(Hyp));
for m = 1:length(Hyp)
    tempData = nan(size(tetrodedata, 1), size(tetrodeData, 2));
    for n = 1:numTetrodes
        relativeSpikeTimes = numTetrodes(n) - hyp(m);
        tempData(:, n) = histogram(relativeSpikeTimes, binningVector);
    end
    tetrodeData(:, :, m) = tempData;
    PopVData(:, n) = sum (tempData, 2);
end
