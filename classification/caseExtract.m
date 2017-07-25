function [results,varImp] = caseExtract(class1,class2,posclass,specifyImfs)

results = cell(size(class1,1),9);
varImp = cell(size(class1,1),9);

if(nargin<4)
    specifyImfs = 1:5;
end

for chan=1:size(class1,1)
    
%     fprintf('\tprocessing channel %d... ',chan);
    for imf=specifyImfs
        
        if(~ischar(posclass))
            data = [class1{chan,imf};class2{chan,imf};posclass{chan,imf}];
        else
            data = [class1{chan,imf};class2{chan,imf}];
        end
        
        if(nargout>1)
            [results{chan,imf},varImp{chan,imf}] = trainClassifier(data,'cv',posclass);
        else
            results{chan,imf} = trainClassifier(data,'cv',posclass);
        end
        % b = TreeBagger(50,data,'class','OOBPred','On');
        % [Yfit,Sfit] = oobPredict(b);
        % [fpr,tpr,~,auc,pt] = perfcurve(b.Y,Sfit(:,strcmp('ictal',b.ClassNames)),'ictal');
        
        
        if(imf>1)
            big_data = [big_data,data(:,vartype('numeric'))];
            if(nargout>1)
                [results{chan,4+imf},varImp{chan,4+imf}] = trainClassifier(data,'cv',posclass);
            else
                results{chan,4+imf} = trainClassifier(data,'cv',posclass);
            end
        else
            big_data = data;
        end
    end
%     fprintf('done\n');
end

varImp = varImp(~cellfun(@isempty,varImp));
results = cell2mat(results(~cellfun(@isempty,results)));