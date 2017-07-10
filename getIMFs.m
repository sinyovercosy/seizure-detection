function modes = getIMFs(data, fs, win, step)

%m = matfile(filename);
%data = m.raw_data(chan,:);

% convert window length and step from seconds to samples:
windowLength = round(win * fs);
step = round(step * fs);

curPos = 1;
L = length(data);

% compute the total number of frames:
numOfFrames = floor((L-windowLength)/step) + 1;
modes = cell(5,numOfFrames);

for i=1:numOfFrames % for each frame
    % get current frame:
    frame  = data(1,curPos:curPos+windowLength-1);
    all_imfs = ceemdan(frame,0.2,100,3000,1);
    modes(:,i) = mat2cell(all_imfs(1:5,:),ones(1,5),windowLength);
    curPos = curPos + step;
end
