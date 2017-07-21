function [classifiers,results] = caseExtract(class1,class2,posclass)

results = zeros(size(class1,1),9);
classifiers = zeros(size(results));

for chan=1:size(results,1)

    for imf=1:5
        
        if(~ischar(posclass))
            data = [class1{chan,imf};class2{chan,imf};posclass{chan,imf}];
        else
            data = [class1{chan,imf};class2{chan,imf}];
        end

        [bag,stats] = trainClassifier(data,'cv',posclass);
        % b = TreeBagger(50,data,'class','OOBPred','On');
        % [Yfit,Sfit] = oobPredict(b);
        % [fpr,tpr,~,auc,pt] = perfcurve(b.Y,Sfit(:,strcmp('ictal',b.ClassNames)),'ictal');
        results(chan,imf) = stats;
        classifiers(chan,imf) = bag;
        

        if(imf>1)
            big_data = [big_data,data(:,vartype('numeric'))];
            [bag,stats] = trainClassifier(data,'cv',posclass);
            results(chan,4+imf) = stats;
            classifiers(chan,4+imf) = bag;
         else
            big_data = data;
        end
    end
end