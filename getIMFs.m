function modes = getIMFs(data, fs, win)

%m = matfile(filename);
%data = m.raw_data(chan,:);

% convert window length and step from seconds to samples:
windowLength = round(win * fs);

L = length(data);

% compute the total number of frames:
numOfFrames = floor(L/windowLength);
modes = cell(5,numOfFrames);

parfor i=1:numOfFrames % for each frame
    % get current frame:
    frame  = data(1,(i-1)*windowLength+1:i*windowLength);
    all_imfs = ceemdan(frame,0.2,100,5,3000,1);
    modes(:,i) = mat2cell(padarray(all_imfs,5-size(all_imfs,1),'post'),ones(1,5),size(all_imfs,2));
end
