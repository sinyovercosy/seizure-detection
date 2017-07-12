function [features_by_seizure, features_by_imf] = featureExtract(signal,className,Fs,window_size_in_sec,step_size_in_sec)
%classes = {'healthy','healthy','interictal','interictal','ictal'};
headers = {'variance','skewness','kurtosis','energy','entropy',...
    'spectral_centroid','spectral_spread','spectral_entropy','spectral_flux','spectral_rolloff'};
[numChans,numSeizures] = size(signal);
features_by_seizure = cell(numChans,numSeizures);

for chan=1:numChans

    for seizure=1:numSeizures
        features_by_seizure{chan,seizure} = cell(6,1);
        for imf=1:5
            features_by_seizure{chan,seizure}{imf} = feats(cat(2,signal{chan,seizure}{imf,:})',Fs,window_size_in_sec,step_size_in_sec);
            features_by_seizure{chan,seizure}{imf} = array2table(features_by_seizure{chan,seizure}{imf}','VariableNames',strcat(headers,sprintf('_imf%d',imf)));
            features_by_seizure{chan,seizure}{6} = [features_by_seizure{chan,seizure}{6},features_by_seizure{chan,seizure}{imf}];
            class = cell(size(features_by_seizure{chan,seizure}{imf},1),1);
            class(:) = {className};
            class=categorical(class);
            features_by_seizure{chan,seizure}{imf}.class = class;
        end
        class = cell(size(features_by_seizure{chan,seizure}{6},1),1);
        class(:) = {className};
        class=categorical(class);
        features_by_seizure{chan,seizure}{6}.class = class;
    end
    
end

features_by_imf = cell(numChans,6);
for chan=1:numChans
for imf = 1:6
for seizure=1:numSeizures
features_by_imf{chan,imf}=[features_by_imf{chan,imf};features_by_seizure{chan,seizure}{imf,1}];
end
end
end