Fs = 256;
window_size_in_sec = 1;
step_size_in_sec = 1;
%classes = {'healthy','healthy','interictal','interictal','ictal'};
headers = {'variance','skewness','kurtosis','energy','entropy',...
    'spectral_centroid','spectral_spread','spectral_entropy','spectral_flux','spectral_rolloff'};
features_by_seizure = cell(23,7);

for chan=1:23

    for seizure=1:size(seizures,2)
        features_by_seizure{chan,seizure} = cell(6,1);
        for imf=1:5
            features_by_seizure{chan,seizure}{imf} = feats(cat(2,seizures{chan,seizure}{imf,:})',Fs,window_size_in_sec,step_size_in_sec);
            features_by_seizure{chan,seizure}{imf} = array2table(features_by_seizure{chan,seizure}{imf}','VariableNames',strcat(headers,sprintf('_imf%d',imf)));
            features_by_seizure{chan,seizure}{6} = [features_by_seizure{chan,seizure}{6},features_by_seizure{chan,seizure}{imf}];
            class = cell(size(features_by_seizure{chan,seizure}{imf},1),1);
            class(:) = {'ictal'};
            class=categorical(class);
            features_by_seizure{chan,seizure}{imf}.class = class;
        end
        class = cell(size(features_by_seizure{chan,seizure}{6},1),1);
        class(:) = {'ictal'};
        class=categorical(class);
        features_by_seizure{chan,seizure}{6}.class = class;
    end
    
end

features_by_imf = cell(23,6);
for chan=1:23
for imf = 1:6
for seizure=1:7
features_by_imf{chan,imf}=[features_by_imf{chan,imf};features_by_seizure{chan,seizure}{imf,1}];
end
end
end