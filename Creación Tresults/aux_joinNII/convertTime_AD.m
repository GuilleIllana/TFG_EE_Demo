function [mask_AD,Converts,convertTime,onset]= convertTime_AD(ADNIMERGE)

mask_DX=(ADNIMERGE.DX=='Dementia') | (ADNIMERGE.DX=='MCI') | (ADNIMERGE.DX=='CN');

mask_AD=(ADNIMERGE.DX_bl=='AD') & mask_DX;

%AD: 3474v 542s: 1920v 261s_MCI 1554v 281s_pMCI
ADNIMERGE=ADNIMERGE(mask_AD,:); 
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

%% regresion
mask_regresion= ADNIMERGE.DX=='MCI' | ADNIMERGE.DX=='CN';
Converts=false(size(ADNIMERGE,1),1);
rSubjs=unique(ADNIMERGE.RID(mask_regresion));
for i=1:length(rSubjs)
    index=find(ADNIMERGE.RID==rSubjs(i));
    DX=ADNIMERGE.DX(index);
    if(DX(end)=='MCI' || DX(end)=='CN')
        Converts(index)=true;
    end
end

mask_AD(Converts==1)=0;
Converts=zeros(sum(mask_AD),1);
convertTime=Converts;
onset=Converts;




end


