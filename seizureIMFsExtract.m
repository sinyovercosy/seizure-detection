function seizureIMFs = seizureIMFsExtract(dirname,timestamps,validChans,fs)
numSeizures = size(timestamps,1);
seizureIMFs = cell(length(validChans),numSeizures);
for i=1:numSeizures
    m = matfile(strcat(dirname,'/',timestamps(i).name));
    for chan=validChans
        seizureIMFs{chan,i} = getIMFs(m.raw_data(chan,...
            (timestamps(i).tstart-1)*fs+1:timestamps(i).tend*fs),fs,1,1);
    end
end