function result = getResults(files,combineChanOpt)
% combineChanOpt: 1 for combined channels, 0 for separate channels
% files: cell array of filenames

numFiles = length(files);
result = cell(numFiles,4);

for patientNum = 1:numFiles
    fprintf('loading patient %d\n',patientNum);
    load(files{patientNum});
    if(combineChanOpt == 1)
        normalFeats = channelCombine(normalFeats,'interictal');
        preictalFeats = channelCombine(preictalFeats,'preictal');
        seizureFeats = channelCombine(seizureFeats,'ictal');
    end
    disp('processing case 1');
    result{patientNum,1} = caseExtract(normalFeats,preictalFeats,seizureFeats);
    disp('processing case 2');
    result{patientNum,2} = caseExtract(normalFeats,preictalFeats,'preictal');
    disp('processing case 3');
    result{patientNum,3} = caseExtract(preictalFeats,seizureFeats,'ictal');
    disp('processing case 4');
    result{patientNum,4} = caseExtract(normalFeats,seizureFeats,'interictal');
end