function preictalIMFs = preictalIMFsExtract(timestamps,horizonMins,postOffsetMins,validChans,fs)
numSeizures = length(timestamps);
preictalIMFs = cell(length(validChans),numSeizures);

for i=1:numSeizures
    if (i==1||~strcmp(timestamps(i).name,timestamps(i-1).name))
        [~,raw_data] = edfread(timestamps(i).name);
    end
    preictalStart = timestamps(i).tstart-horizonMins*60;
    if(preictalStart<1)
        preictalStart = 1;
    end
    if (i~=1&&strcmp(timestamps(i).name,timestamps(i-1).name)...
            &&preictalStart<=timestamps(i-1).tend+postOffsetMins*60)
        preictalStart = timestamps(i-1).tend+postOffsetMins*60+1;
    end
    preictalEnd=timestamps(i).tstart-1;
    seizureLength = timestamps(i).tend-timestamps(i).tstart+1;
    preictalTimes = preictalStart:preictalEnd;
    if (length(preictalTimes)>seizureLength)
        preictalTimes = sort(preictalTimes(randperm(length(preictalTimes),seizureLength)));
    end
    preictalSamps = [];
    for t=preictalTimes
        preictalSamps = [preictalSamps,(t-1)*fs+1:t*fs];
    end
    for chan=validChans
        preictalIMFs{chan,i} = getIMFs(raw_data(chan,preictalSamps),fs,1);
    end
end