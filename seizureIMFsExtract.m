function seizureIMFs = seizureIMFsExtract(timestamps,validChans,fs)
numSeizures = length(timestamps);
seizureIMFs = cell(length(validChans),numSeizures);
for i=1:numSeizures
    if (i==1||~strcmp(timestamps(i).name,timestamps(i-1).name))
        [~,raw_data] = edfread(timestamps(i).name);
    end
    for chan=validChans
        seizureIMFs{chan,i} = getIMFs(raw_data(chan,...
            (timestamps(i).tstart-1)*fs+1:timestamps(i).tend*fs),fs,1);
    end
end