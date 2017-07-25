function [fullChan,renamedFeats] = channelCombine(feats,className,selectedChans)

renamedFeats = feats;
fullChan = cell(1,5);
if(nargin<3)
    selectedChans = 1:size(feats,1);
end

for jj = 1:5
    for ii=selectedChans
        renamedFeats{ii,jj}.Properties.VariableNames(1:9) = strcat(feats{ii,jj}.Properties.VariableNames(1:9),sprintf('_chan%d',ii));
        fullChan{jj} = [fullChan{jj},renamedFeats{ii,jj}(:,1:9)];
    end
    fullChan{jj}.class(:,1) = {className};
    fullChan{jj}.class = categorical(fullChan{jj}.class);
end