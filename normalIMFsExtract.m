function normalIMFs = normalIMFsExtract(timestamps,validChans,fs)
numSeizures = length(timestamps);
normalIMFs = cell(length(validChans),length(unique({timestamps.name})));
filenum = 0;

for i=1:numSeizures
    if (i==1||~strcmp(timestamps(i).name,timestamps(i-1).name))
        [~,raw_data] = edfread(timestamps(i).name);
        secs = 1:size(raw_data,2)/fs;
        totalSeizureLength = 0;
        filenum = filenum+1;
    end
    secs(find(secs==timestamps(i).tstart):find(secs==timestamps(i).tend)) = [];
    totalSeizureLength = totalSeizureLength+(timestamps(i).tend-timestamps(i).tstart+1);
    if (i==numSeizures||~strcmp(timestamps(i).name,timestamps(i+1).name))
        secs = sort(secs(randperm(length(secs),totalSeizureLength)));
        samps = [];
        for t=secs
            samps = [samps,(t-1)*fs+1:t*fs];
        end
        for chan=validChans
            normalIMFs{chan,filenum} = getIMFs(raw_data(chan,samps),fs,1);
        end
    end
end