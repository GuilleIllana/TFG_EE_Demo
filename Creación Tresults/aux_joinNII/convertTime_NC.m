function [mask_NC,Converts,convertTime,onset]= convertTime_NC(ADNIMERGE)

 
% [ADNI_pNC,ADNI_sNC]=selectedSubjectNC_ADNI(dataset);
mask_DX=(ADNIMERGE.DX=='Dementia') | (ADNIMERGE.DX=='MCI') | (ADNIMERGE.DX=='CN');
mask_NC=(ADNIMERGE.DX_bl=='CN') & mask_DX; %NC
ADNIMERGE=ADNIMERGE(mask_NC,:); %NC: 2771v 409s, (old)4233v 512s
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
mask_pNC= (ADNIMERGE.DX=='Dementia') | (ADNIMERGE.DX=='MCI'); % people who convert to MCI/AD
Converts=false(size(ADNIMERGE,1),1);
pNC_subjs=unique(ADNIMERGE.RID(mask_pNC));
for i=1:length(pNC_subjs)
    index=find(ADNIMERGE.RID==pNC_subjs(i));
    DX=ADNIMERGE.DX(index);
    if((DX(end)=='Dementia') || (DX(end)=='MCI'))
        Converts(index)=true;
    end 
end

% ADNIMERGE.Convert=Converts;
% ADNI_pNC= ADNIMERGE(Converts,:); %pNC: 804v 93s (old)845v 102s %745v 98s
% ADNI_sNC= ADNIMERGE(Converts==0,:); %sNC: 1967v 316s (old) 1963v 408s %1991v 412s


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
    ct=find((DX=='MCI') | (DX=='Dementia'),1);
    convertTime(index)=viscode(ct);
    time_zero=ADNIMERGE.EXAMDATE(index(ord(ct)));
    Delta_days=days(ADNIMERGE.EXAMDATE(index(ord(ct)))-...
        ADNIMERGE.EXAMDATE(index(ord(ct-1))))/2;
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


