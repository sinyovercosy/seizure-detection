function Features = feats(signal, fs, win, step)

% function Features = stFeatureExtraction(signal, fs, win, step)
%
% This function computes basic audio feature sequencies for an audio
% signal, on a short-term basis.
%
% ARGUMENTS:
%  - signal:    the audio signal
%  - fs:        the sampling frequency
%  - win:       short-term window size (in seconds)
%  - step:      short-term step (in seconds)
%
% RETURNS:
%  - Features: a [MxN] matrix, where M is the number of features and N is
%  the total number of short-term windows. Each line of the matrix
%  corresponds to a seperate feature sequence
%
% (c) 2014 T. Giannakopoulos, A. Pikrakis

% if STEREO ...
if (size(signal,2)>1)
    signal = (sum(signal,2)/2); % convert to MONO
end

% convert window length and step from seconds to samples:
windowLength = round(win * fs);
step = round(step * fs);

curPos = 1;
L = length(signal);

% compute the total number of frames:
numOfFrames = floor((L-windowLength)/step) + 1;
% number of features to be computed:
numOfFeatures = 10;
Features = zeros(numOfFeatures, numOfFrames);
%Ham = window(@hamming, windowLength);

for i=1:numOfFrames % for each frame
    % get current frame:
    frame  = signal(curPos:curPos+windowLength-1);
    %frame  = frame .* Ham;
    [frameFFT,Freq] = getDFT(frame, fs);
    
    
    if (sum(abs(frame))>eps)
        % compute time-domain features:
        Features(1,i) = var(frame);
        Features(2,i) = skewness(frame);
        Features(3,i) = kurtosis(frame);
        Features(4,i) = feature_energy(frame);
        Features(5,i) = feature_energy_entropy(frame, 10);

        % compute freq-domain features: 
        if (i==1); frameFFTPrev = frameFFT; end;
        [Features(6,i), Features(7,i)] = ...
            feature_spectral_centroid(frameFFT, fs);
        Features(8,i) = feature_spectral_entropy(frameFFT, 10);
        Features(9,i) = feature_spectral_flux(frameFFT, frameFFTPrev);
        Features(10,i) = feature_spectral_rolloff(frameFFT, 0.90);
        
    else
        Features(:,i) = zeros(numOfFeatures, 1);
    end    
    curPos = curPos + step;
    frameFFTPrev = frameFFT;
end
