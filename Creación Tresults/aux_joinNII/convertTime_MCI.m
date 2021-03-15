function [mask_MCI,Converts,convertTime,onset]= convertTime_MCI(ADNIMERGE)

mask_DX=(ADNIMERGE.DX=='Dementia') | (ADNIMERGE.DX=='MCI') | (ADNIMERGE.DX=='CN');

% mask_MCI= ADNIMERGE.DX_bl=='LMCI' & mask_DX;
% mask_MCI= (ADNIMERGE.DX_bl=='EMCI') & mask_DX;
mask_MCI=((ADNIMERGE.DX_bl=='LMCI') | (ADNIMERGE.DX_bl=='EMCI')) & mask_DX;

%LMCI: 3474v 542s: 1920v 261s_MCI 1554v 281s_pMCI
%eMCI: v s:  v 262s_MCI v 46s_pMCI
%elMCI: v s: v 523s_MCI v 327s_pMCI
ADNIMERGE=ADNIMERGE(mask_MCI,:); 
%% sort
% RID=unique(ADNIMERGE.RID);
% index_all=[];
% for i=1:length(RID)
%     index=find(ADNIMERGE.RID==RID(i));
%     [val,idx]=sort(ADNIMERGE.Month(index));
%     if((val(1)~=0) || (ADNIMERGE.VISCODE(index(idx(1)))~='bl'))
%         fprintf('Error %d\n',RID(i));
%     else
%         index_all=[index_all;index(idx)];
%     end
%     
% end
% ADNIMERGE=ADNIMERGE(index_all,:);

%% Converts
mask_pMCI= (ADNIMERGE.DX=='Dementia'); % people who convert to AD
Converts=false(size(ADNIMERGE,1),1);
pMCI_subjs=unique(ADNIMERGE.RID(mask_pMCI));
for i=1:length(pMCI_subjs)
    index=find(ADNIMERGE.RID==pMCI_subjs(i));
    DX=ADNIMERGE.DX(index);
    if(DX(end)=='Dementia')
        Converts(index)=true;
    end
end



%% pNC
RID=unique(ADNIMERGE.RID(Converts==1));
convertTime=zeros(size(ADNIMERGE,1),1);
onset=convertTime;
for i=1:length(RID)
    index=find(ADNIMERGE.RID==RID(i));
    viscode=ADNIMERGE.M(index);
    [viscode,ord]=sort(viscode);
    if(length(ord)>1)
        if(sum(ord(2:end)-ord(1:end-1)-1)~=0)
            fprintf(2,'No sorting visits from RID %d.\n',RID(i));
        end
    end
    DX=ADNIMERGE.DX(index(ord));
    ct=find(DX=='Dementia',1);
    convertTime(index)=viscode(ct);
    time_zero=ADNIMERGE.EXAMDATE(index(ord(ct)));
    if(ct>1)
        Delta_days=days(ADNIMERGE.EXAMDATE(index(ord(ct)))-...
            ADNIMERGE.EXAMDATE(index(ord(ct-1))))/2;
    else
        Delta_days=0;      
    end
    onset(index)=(days(ADNIMERGE.EXAMDATE(index)-time_zero)+Delta_days)/30;
    

end



%% pNC
RID=unique(ADNIMERGE.RID(Converts==0));

for i=1:length(RID)
    index=find(ADNIMERGE.RID==RID(i));
    viscode=ADNIMERGE.M(index);
    [viscode,ord]=sort(viscode);
    if(length(ord)>1)
        if(sum(ord(2:end)-ord(1:end-1)-1)~=0)
            fprintf(2,'No sorting visits from RID %d.\n',RID(i));
        end
    end    
    convertTime(index)=viscode(end);
    onset(index)=-viscode(end);

end






end


