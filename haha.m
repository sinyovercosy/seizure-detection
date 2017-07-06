Fs = 173.61;
window_size_in_sec = 4097/Fs;
step_size_in_sec = 4097/Fs;
classes = {'healthy','healthy','interictal','interictal','ictal'};
headers = {'variance','skewness','kurtosis','energy','entropy',...
    'spectral_centroid','spectral_spread','spectral_entropy','spectral_flux','spectral_rolloff'};
features = cell(5,6);
for set=1:5
    class = cell(100,1);
    class(:) = classes(set);
    class=categorical(class);
    for imf=1:5
        for epoch=1:100
            features{set,imf} = [features{set,imf}, feats(IMFs{set,epoch}(imf,:)',Fs,window_size_in_sec,step_size_in_sec)];
        end;
        %features{set,imf} = num2cell(features{set,imf});
        %[features{set,imf}{11,:}] = deal(classes{set});
        features{set,imf} = array2table(features{set,imf}','VariableNames',strcat(headers,sprintf('_imf%d',imf)));
        features{set,6} = [features{set,6},features{set,imf}];
        features{set,imf}.class = class;
    end;
    features{set,6}.class = class;
end;