results = cell(5,9);

cases = {[1 2 3 4 5],[1 4 5],[1 5],[1 2 3 4 5],[4 5]};
for i=1:5

    for imf=1:5
        data = cat(1,features{cases{i},imf});
        if i==4
            data.class(1:400) = categorical({'nonictal'});
        end
        [b,stats] = trainClassifier(data,'cv');
        % b = TreeBagger(50,data,'class','OOBPred','On');
        % [Yfit,Sfit] = oobPredict(b);
        % [fpr,tpr,~,auc,pt] = perfcurve(b.Y,Sfit(:,strcmp('ictal',b.ClassNames)),'ictal');
        results{i,imf} = stats;
        

        if(imf>1)
            big_data = [big_data,data(:,vartype('numeric'))];
            [b,stats] = trainClassifier(data,'cv');
            results{i,4+imf} = stats;
        else
            big_data = data;
        end
    end
end