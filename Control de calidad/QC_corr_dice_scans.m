 function QC_corr_dice_scans
% Input: Tresults, QC measurements from
% Output: Pearson correlation vs dice from a MRI subject scans (figure 1)
%         Hippocampal and cortex volumes from MRI vs Tresults.           
%% data
% MCI-to-AD T1+DTI
%idelacalle
% load('./data/Tresults_T1DTI_110v_31s', 'Tresults');
% load('./data/QC_long_T1DTI_110v_31s','corr_QC','vol_QC');

%Yuzhi
% load('./data/Tresults_T1DTI_274v_86s', 'Tresults');
% load('./data/QC_long_T1DTI_274v_86s','corr_QC','vol_QC');
% load('./data/Tresults_T1DTI_272v_86s', 'Tresults');
% load('./data/QC_long_T1DTI_272v_86s','corr_QC','vol_QC');


%Yuzhi+idelacalle
% load('./data/Tresults_T1DTI_384v_117s', 'Tresults');
% load('./data/QC_long_T1DTI_384v_117s','corr_QC','vol_QC');

%mballe
%load('../Generate_Tresults/Data_413v_122s_sMCI_pMCI/Tresults_413v_122s.mat', 'Tresults');
%load('./data/QC_long_413v_122s','corr_QC','vol_QC');
% load('../Generate_Tresults/Data_106v_44s_AD/Tresults_106v_44s_AD.mat', 'Tresults');
% load('./data/QC_long_106v_44s','corr_QC','vol_QC');
load('./data/2021/Tresults_413v_122s.mat', 'Tresults');
load('./data/2021/QC_long_413v_122s','corr_QC','vol_QC');

%% Data check
ID=string(Tresults.fsidbase);
ID=sort(ID);
[~,index]=unique(ID);
% index=sort(index);
ID_1=ID(index);
ID_Subj=ID(index);

ID_2=string(corr_QC.fsidbase);
for i=1:length(ID_1)
    if(strcmp(ID_2(i),ID_1(i))==0)
        fprintf('%s in table 1 %d and table 2 not the same\n',ID_1(i),i);
    end
end

ID_1=sort(extractBefore(string(Tresults.fsid),12));
ID_2=extractBefore(string(vol_QC.fsid),12);
for i=1:length(ID_1)
    if(strcmp(ID_2(i),ID_1(i))==0)
        fprintf('%s in table 1 %d and table 2 not the same\n',ID_1(i),i);
    end
end



%% Pearson vs dice
close all;

QC=[corr_QC.coefImg_Hipp,corr_QC.coefLabel_Hipp,corr_QC.coefImg_Cortex,...
    corr_QC.coefLabel_Cortex];

figure(1);
plotQC(QC,ID_Subj,Tresults.Convert(index));


%% Correlation between stats and masks of the aseg

ID_scans= extractBefore(string(Tresults.fsid),24);
fsid=extractBefore(string(vol_QC.fsid),24);
numScans=length(fsid);
index=zeros(numScans,1);
del_scans=[];
for i=1:numScans
    tmp_index=find(strcmp(ID_scans,fsid(i)));
    if(length(tmp_index)==1)
        index(i)=tmp_index;       
        if(strcmp(ID_scans(index(i)),fsid(i))==0)
            fprintf('The scan order between Tresults and QC is different: %d %s %s.\n',...
                i,ID_scans(index(i)),fsid(i));
        end
    elseif(isempty(tmp_index))
        fprintf('Error: %s does not present in Tresults\n',fsid(i));
        del_scans=[del_scans;i];
    else
        fprintf('Multiple names in Tresults: %s\n',fsid(i));
    end
end
index(del_scans)=[];
vol_QC(del_scans,:)=[];

%test
fsid=extractBefore(string(vol_QC.fsid),24);
for i=1:size(vol_QC,1)
    if(strcmp(ID_scans(index(i)),fsid(i))==0)
        fprintf('The scan order between Tresults and vol-QC is different: %d %s %s.\n',...
            i,ID_scans(index(i)),fsid(i));
    end
end

figure(2);
subplot(2,2,1);plot(Tresults.LHippVol(index),vol_QC.LHipp_vol,'+');
xlabel('LHV (stats) mm3'); ylabel('LHV (aseg) mm3'); 
subplot(2,2,2);plot(Tresults.RHippVol(index),vol_QC.RHipp_vol,'+');
xlabel('RHV (stats) mm3'); ylabel('RHV (aseg) mm3'); 
subplot(2,2,3);plot(Tresults.LCortVol(index),vol_QC.LCortex_vol,'+');
xlabel('L CortexVol (stats) mm3'); ylabel('L CortexVol (aseg) mm3'); 
subplot(2,2,4);plot(Tresults.RCortVol(index),vol_QC.RCortex_vol,'+');
xlabel('R CortexVol (stats) mm3'); ylabel('R CortexVol (aseg) mm3'); 


end



function plotQC(QC,fsidbase,diagn)


subplot(1,2,1);
hold on;
%sMCI vs pMCI
plot(QC(diagn==0,1),QC(diagn==0,2),'r+',QC(diagn==1,1),QC(diagn==1,2),'go');
%------
%AD
% plot(QC(:,1),QC(:,2),'c*');
%------
axis([0 1 0 1]);
index_outliers_Hipp=find(QC(:,1)<.7 & QC(:,2)<.7);
if(isempty(index_outliers_Hipp)==0)
    for i=1:length(index_outliers_Hipp)
        text(QC(index_outliers_Hipp(i),1),QC(index_outliers_Hipp(i),2),...
            fsidbase(index_outliers_Hipp(i),:),'Interpreter','none');
    end
end

hold off;
%sMCI vs pMCI 
legend('Stable','Convert');
%------
%AD
% legend('Dementia');
%------
xlabel('Intensity correlation coefficients');
ylabel('Labeling dice coefficients');
title('Lowest correlations between pairs of scans from each subject for the hippocampus');

subplot(1,2,2);
hold on;
%sMCI vs pMCI
plot(QC(diagn==0,3),QC(diagn==0,4),'r+',QC(diagn==1,3),QC(diagn==1,4),'go');
%------
%AD
% plot(QC(:,4),QC(:,3),'c*');
%------
axis([0 1 0 1]);
index_outliers_Cortex=find(QC(:,3)<.7 & QC(:,4)<.7);
if(isempty(index_outliers_Cortex)==0)
    for i=1:length(index_outliers_Cortex)
        text(QC(index_outliers_Cortex(i),3),QC(index_outliers_Cortex(i),4),...
            fsidbase(index_outliers_Cortex(i),:),'Interpreter','none');
    end
end

hold off;
axis([0 1 0 1]);
%sMCI vs pMCI
legend('Stable','Convert');
%-----
%AD
% legend('Dementia');
%-----
xlabel('Intensity correlation coefficients');
ylabel('Labeling dice coefficients');
title('Lowest correlations between pairs of scans from each subject for the cortex');


end
