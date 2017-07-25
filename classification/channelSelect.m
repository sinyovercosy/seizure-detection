function result = channelSelect(files,numSelectChans)
numFiles = length(files);
result = cell(numFiles,4);

for patientNum = 1:numFiles
    fprintf('loading patient %d\n',patientNum);
    load(files{patientNum});
    full_normal = channelCombine(normalFeats,'interictal');
    full_preictal = channelCombine(preictalFeats,'preictal');
    full_seizure = channelCombine(seizureFresueats,'ictal');
    disp('selecting channels');
    [~,varImp] = caseExtract(full_normal,full_preictal,full_seizure,1);
%     varImp = reshape(cell2mat(varImp),size(normFeats,1),9);
%     chanImp = sum(varImp,2);
%     [~,chanListByImp] = sort(chanImp,'descend');
    [~,chanListByImp] = sort(sum(reshape(cell2mat(varImp),size(normalFeats,1),9),2),'descend');
    selectedChans = chanListByImp(1:numSelectChans)';
    select_normal = channelCombine(normalFeats,'interictal',selectedChans);
    select_preictal = channelCombine(preictalFeats,'preictal',selectedChans);
    select_seizure = channelCombine(seizureFeats,'ictal',selectedChans);
    
    disp('processing case 1');
    result{patientNum,1} = caseExtract(select_normal,select_preictal,select_seizure,1);
    disp('processing case 2');
    result{patientNum,2} = caseExtract(select_normal,select_preictal,'preictal',1);
    disp('processing case 3');
    result{patientNum,3} = caseExtract(select_preictal,select_seizure,'ictal',1);
    disp('processing case 4');
    result{patientNum,4} = caseExtract(select_normal,select_seizure,'interictal',1);
end