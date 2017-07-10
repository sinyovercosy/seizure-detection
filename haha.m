Fs = 256;
window_size_in_sec = 1;
step_size_in_sec = 1;
%classes = {'healthy','healthy','interictal','interictal','ictal'};
headers = {'variance','skewness','kurtosis','energy','entropy',...
    'spectral_centroid','spectral_spread','spectral_entropy','spectral_flux','spectral_rolloff'};
features = cell(23,7);

for chan=1:23

    for seizure=1:size(seizures,2)
        features{chan,seizure} = cell(6,1);
        for imf=1:5
            features{chan,seizure}{imf} = feats(cat(2,seizures{chan,seizure}{imf,:})',Fs,window_size_in_sec,step_size_in_sec);
            features{chan,seizure}{imf} = array2table(features{chan,seizure}{imf}','VariableNames',strcat(headers,sprintf('_imf%d',imf)));
            features{chan,seizure}{6} = [features{chan,seizure}{6},features{chan,seizure}{imf}];
            class = cell(size(features{chan,seizure}{imf},1),1);
            class(:) = {'ictal'};
            class=categorical(class);
            features{chan,seizure}{imf}.class = class;
        end
        class = cell(size(features{chan,seizure}{6},1),1);
        class(:) = {'ictal'};
        class=categorical(class);
        features{chan,seizure}{6}.class = class;
    end
    
end