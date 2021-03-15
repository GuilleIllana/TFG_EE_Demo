function [ADNI_pNC,ADNI_sNC]= calculatedConvertTime_NC(dataset)

 
[ADNI_pNC,ADNI_sNC]=selectedSubjectNC_ADNI(dataset);

%% pNC
% DX_code=unique(ADNI_pNC.DX);
RID=unique(ADNI_pNC.RID);
convertTime=zeros(size(ADNI_pNC,1),1);
onset=convertTime;
index_sort=convertTime;
begin_index=1;
for i=1:length(RID)
    index=find(ADNI_pNC.RID==RID(i));
    viscode=viscode2double(ADNI_pNC.VISCODE(index));
    [viscode,ord]=sort(viscode);
    DX=ADNI_pNC.DX(index(ord));
    ct=find(DX~='CN',1);
    convertTime(index)=viscode(ct)*30;
    time_zero=ADNI_pNC.EXAMDATE(index(ord(ct)));
    Delta_days=days(ADNI_pNC.EXAMDATE(index(ord(ct)))-...
        ADNI_pNC.EXAMDATE(index(ord(ct-1))))/2;
    onset(index)=days(ADNI_pNC.EXAMDATE(index)-time_zero)+Delta_days;
    
    end_index=length(index)+begin_index-1;
    index_sort(begin_index:end_index)=index(ord);
    begin_index=end_index+1;
    %Test
%     DX=ADNI_pNC.DX(index);
%     ct=(days(ADNI_pNC.EXAMDATE(index)-time_zero)+Delta_days)/30;
end

ADNI_pNC.convertTime=convertTime;
ADNI_pNC.onset=onset;
ADNI_pNC=ADNI_pNC(index_sort,:);


%% pNC
RID=unique(ADNI_sNC.RID);
convertTime=zeros(size(ADNI_sNC,1),1);
onset=convertTime;
index_sort=convertTime;
begin_index=1;
for i=1:length(RID)
    index=find(ADNI_sNC.RID==RID(i));
    viscode=viscode2double(ADNI_sNC.VISCODE(index));
    [viscode,ord]=sort(viscode);
    convertTime(index)=viscode(end)*30;
    onset(index)=-viscode(end)*30;
    end_index=length(index)+begin_index-1;
    index_sort(begin_index:end_index)=index(ord);
    begin_index=end_index+1;
end

ADNI_sNC.convertTime=convertTime;
ADNI_sNC.onset=onset;
ADNI_sNC=ADNI_sNC(index_sort,:);


%% Show
% show=false;
% if(show)
% addpath('../../Univariante/external/lme/univariate');
% 
% level_smooth=.6;
% level_linear=0.1; %% grado de suavidad, 0 corresponde a rectas
% 
% 
% figure(1);
% clf;
% maskNaN=isnan(ADNI_pNC.Hippocampus)==0;
% NHV=ADNI_pNC.Hippocampus(maskNaN)./ADNI_pNC.ICV(maskNaN);
% lme_lowessPlot(ADNI_pNC.onset(maskNaN),NHV,level_smooth,...
%     ADNI_pNC.Converts(maskNaN));
% hold on;
% draw_longTray(ADNI_pNC.RID(maskNaN),ADNI_pNC.onset(maskNaN),NHV,level_linear)
% hold off;
% title('NHV');
% 
% figure(2);
% clf;
% ADNI_pNC.ADAS13=str2double(ADNI_pNC.ADAS13);
% maskNaN=isnan(ADNI_pNC.ADAS13)==0;
% lme_lowessPlot(ADNI_pNC.onset(maskNaN),ADNI_pNC.ADAS13(maskNaN),level_smooth,...
%     ADNI_pNC.Converts(maskNaN));
% hold on;
% draw_longTray(ADNI_pNC.RID(maskNaN),ADNI_pNC.onset(maskNaN),...
%     ADNI_pNC.ADAS13(maskNaN),level_linear);
% hold off;
% title('A13');
% 
% 
% 
% figure(3);
% clf;
% maskNaN=isnan(ADNI_pNC.RAVLT_immediate)==0;
% lme_lowessPlot(ADNI_pNC.onset(maskNaN),ADNI_pNC.RAVLT_immediate(maskNaN),level_smooth,...
%     ADNI_pNC.Converts(maskNaN));
% hold on;
% draw_longTray(ADNI_pNC.RID(maskNaN),ADNI_pNC.onset(maskNaN),...
%     ADNI_pNC.RAVLT_immediate(maskNaN),level_linear);
% hold off;
% title('RALVTinm');
% 
% % figure(4);
% % clf;
% % maskNaN=isnan(ADNI_pNC.FAQ)==0;
% % lme_lowessPlot(ADNI_pNC.onset(maskNaN),ADNI_pNC.FAQ(maskNaN),level_smooth,...
% %     ADNI_pNC.Converts(maskNaN));
% % title('FAQ');
% 
% rmpath('../Univariante/external/lme/univariate');
% 
% end


end

function draw_longTray(RID,time,feat,level_linear)
uRID=unique(RID);
for i=1:length(uRID)
    if(sum(RID==uRID(i))>=2)
        drawSplines(feat(RID==uRID(i)),time(RID==uRID(i)),level_linear);
    end
end

end

function drawSplines(samples,time,lineal)

sp=csaps(time,samples,lineal);
fnplt(sp,':');

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
