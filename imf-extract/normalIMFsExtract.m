function normalIMFs = normalIMFsExtract(timestamps,normFiles,validChans,fs)
numSeizures = length(timestamps);
numNorms = length(normFiles);
normalIMFs = cell(length(validChans),numNorms);

totalSeizureLength = 0;
for i=1:numSeizures
    totalSeizureLength = totalSeizureLength+(timestamps(i).tend-timestamps(i).tstart+1);
end

for i=1:numNorms
        [~,raw_data] = edfread(timestamps(i).name);
        secs = 1:size(raw_data,2)/fs;
        secs = sort(secs(randperm(length(secs),round(totalSeizureLength/numNorms))));
        samps = [];
        for t=secs
            samps = [samps,(t-1)*fs+1:t*fs];
        end
        for chan=validChans
            normalIMFs{chan,i} = getIMFs(raw_data(chan,samps),fs,1);
        end
end