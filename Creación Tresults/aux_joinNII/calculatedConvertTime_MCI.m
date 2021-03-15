function ADNI_sMCI= calculatedConvertTime_MCI(dataset)

ADNI_sMCI=selectedSubjectMCI_ADNI(dataset);


%% sMCI
RID=unique(ADNI_sMCI.RID);
convertTime=zeros(size(ADNI_sMCI,1),1);
onset=convertTime;
index_sort=convertTime;
begin_index=1;
for i=1:length(RID)
    index=find(ADNI_sMCI.RID==RID(i));
    viscode=viscode2double(ADNI_sMCI.VISCODE(index));
    [viscode,ord]=sort(viscode);
    convertTime(index)=viscode(end)*30;
    onset(index)=viscode(end)*30;
    end_index=length(index)+begin_index-1;
    index_sort(begin_index:end_index)=index(ord);
    begin_index=end_index+1;
end

ADNI_sMCI.convertTime=convertTime;
ADNI_sMCI.onset=onset;
ADNI_sMCI=ADNI_sMCI(index_sort,:);




end

function vis=viscode2double(viscodes)
vis=zeros(length(viscodes),1);
for i=1:length(viscodes)
    vis(i)=visit2num(viscodes(i));
end

end

function visit=visit2num(VISCODE)
vis=char(VISCODE);
if(vis(1)=='b')
    visit=0;
else
    visit=str2double(vis(2:end));
end

end
