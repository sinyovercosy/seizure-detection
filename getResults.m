files = what('chb-mit');
files = files.mat;
numFiles = length(files);

classifiers = zeros(numFiles,4);
results = zeros(numFiles,4);

for patientNum = 1:numFiles
    load(files{patientNum});
    [classifiers(patientNum,1), results(patientNum,1)] = caseExtract(normalFeats,preictalFeats,seizureFeats);
    [classifiers(patientNum,2), results(patientNum,2)] = caseExtract(normalFeats,preictalFeats,'preictal');
    [classifiers(patientNum,3), results(patientNum,3)] = caseExtract(preictalFeats,seizureFeats,'ictal');
    [classifiers(patientNum,4), results(patientNum,4)] = caseExtract(normalFeats,seizureFeats,'interictal');
end