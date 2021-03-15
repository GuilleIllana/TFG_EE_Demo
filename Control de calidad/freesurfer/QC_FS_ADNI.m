function [corr_QC,vol_QC]=QC_FS_ADNI
% Input: Freesurfer subject dir
% Output; correlations and volumetry of subjects and visits.

%% Path
addpath('/usr/local/freesurfer/matlab'); %MRIread
%path_scan= '/media/Elements_/Gauss/ywu/Long/';
%path_scan= '/media/Elements_/Gauss/sliebana/PacientesCompletados/Long/';
%path_scan= '/media/Elements_/Newton/Sliebana/PacientesCompletados/Long/';
%path_scan= '/media/Elements_/Copernico/Lin/Long/';
%path_scan='../cross/conversores/Cross/';

%path_scan='/home/idelacalle/IRENE_T1_DTI/Cross_1/Long/'; %Newton
% path_scan='../../../AD_106v_44s/Long/'; %Curie
%path_scan='../../../sMCI_pMCI_413v_122s/Long/'; %Curie
path_scan='/media/bck/mballe/Procesamiento/T1/sMCI_pMCI_413v_122s/Long/'; %Curie

%% Measurements
listScans=dir(path_scan);
listScans=listScans(cat(1,listScans(:).isdir));
listScans(1:2)=[];
%listScans(end)=[]; %fsaverge

numScans=numel(listScans);

QC=[];
list_base=[];
ni=[];
markers=zeros(numScans,4);
i=1;
while(i<=numScans)
    id_base=listScans(i).name(1:10);
    list_base=[list_base;id_base];
    j=1;
    
    if(i<numScans)
        while((strcmp(id_base,listScans(i+j).name(1:10))))
            j=j+1;
            if((i+j)==(numScans+1))
                break;
            end

        end
    end
    
    fprintf('%d: %s %d:\n',i+j,id_base,size(list_base,1));
    [cortex_hipp,QC_subj]=qualityControl(path_scan,listScans,i,j);
    markers(i:i+j-1,:)=cortex_hipp;
    ni=[ni;j];
    QC=[QC;QC_subj];

    i=i+j;
    
%     if(i>105)
%         pause;
%     end
end

corr_QC=table(list_base,ni,QC(:,1),QC(:,2),QC(:,3),QC(:,4),...
    'VariableNames',{'fsidbase','ni','coefImg_Hipp','coefLabel_Hipp','coefImg_Cortex','coefLabel_Cortex'});

% vol_QC=table(cat(1,listScans(:).name),markers(:,1),markers(:,2),markers(:,3),markers(:,4),...
%     'VariableNames',{'fsid','LCortex_vol','RCortex_vol','LHipp_vol','RHipp_vol'});

listScans=struct2table(listScans);
vol_QC=table(string(listScans.name),markers(:,1),markers(:,2),markers(:,3),markers(:,4),...
    'VariableNames',{'fsid','LCortex_vol','RCortex_vol','LHipp_vol','RHipp_vol'});


save('QC_long_413v_122s','corr_QC','vol_QC');
%save('QC_long_413v_122s','corr_QC','vol_QC');
end


function [cortex_hipp,QC]=qualityControl(path_scan,listScans,j,numImgs)

cortex_hipp=zeros(numImgs,4);
for i=1:numImgs
    f= MRIread(strcat(path_scan,listScans(j+i-1).name,'/mri/aseg.mgz'));
    screen=f.vol;
    lb_R1=screen==53; %RH
    lb_R2=screen==17; %LH
    lb_R3=screen==42; %RC
    lb_R4=screen==3;  %LC
    if(i>1)
        mask_R1=mask_R1 | lb_R1;
        mask_R2=mask_R2 | lb_R2;
        mask_R3=mask_R3 | lb_R3;
        mask_R4=mask_R4 | lb_R4;
    else
        lb_R14D=false([size(screen),numImgs]);
        lb_R24D=false([size(screen),numImgs]);
        lb_R34D=false([size(screen),numImgs]);
        lb_R44D=false([size(screen),numImgs]);
        im4D=zeros([size(screen),numImgs]);
        mask_R1=lb_R1;
        mask_R2=lb_R2;
        mask_R3=lb_R3;
        mask_R4=lb_R4;
    end

    lb_R14D(:,:,:,i)=lb_R1;
    lb_R24D(:,:,:,i)=lb_R2;
    lb_R34D(:,:,:,i)=lb_R3;            
    lb_R44D(:,:,:,i)=lb_R4;

    f= MRIread(strcat(path_scan,listScans(j+i-1).name,'/mri/T1.mgz'));
    im4D(:,:,:,i)=double(f.vol);

    cortex_hipp(i,:)=[sum(lb_R4(:)),sum(lb_R3(:)),sum(lb_R2(:)),sum(lb_R1(:))];
    fprintf('%s: %5.0f %5.0f %4.0f %4.0f\n',listScans(j+i-1).name(1:20),...
        cortex_hipp(i,:));
end
%% Between scans
if(numImgs>1)
    radious=3;
    mask_R1=imdilate(mask_R1,strel('disk',radious));
    mask_R2=imdilate(mask_R2,strel('disk',radious));
    mask_R3=imdilate(mask_R3,strel('disk',radious));
    mask_R4=imdilate(mask_R4,strel('disk',radious));

    corr_im_lb=zeros(factorial(numImgs)/2/factorial(numImgs-2),8);
    m=1;
    for k=1:numImgs-1
        for l=k+1:numImgs
            im3D_k=im4D(:,:,:,k);
            im3D_l=im4D(:,:,:,l);
            l13D_k=lb_R14D(:,:,:,k);
            l13D_l=lb_R14D(:,:,:,l);
            l23D_k=lb_R24D(:,:,:,k);
            l23D_l=lb_R24D(:,:,:,l);
            l33D_k=lb_R34D(:,:,:,k);
            l33D_l=lb_R34D(:,:,:,l);
            l43D_k=lb_R44D(:,:,:,k);
            l43D_l=lb_R44D(:,:,:,l);

            corr_im_lb(m,[1,3])=getCorrelationImLb(im3D_k(mask_R1),im3D_l(mask_R1),...
                l13D_k(mask_R1),l13D_l(mask_R1));
            corr_im_lb(m,[2,4])=getCorrelationImLb(im3D_k(mask_R2),im3D_l(mask_R2),...
                l23D_k(mask_R2),l23D_l(mask_R2));
            corr_im_lb(m,[5,7])=getCorrelationImLb(im3D_k(mask_R3),im3D_l(mask_R3),...
                l33D_k(mask_R3),l33D_l(mask_R3));
            corr_im_lb(m,[6,8])=getCorrelationImLb(im3D_k(mask_R4),im3D_l(mask_R4),...
                l43D_k(mask_R4),l43D_l(mask_R4));

            m=m+1;
        end
    end
    corr_im_12=corr_im_lb(1:m-1,1:2);
    corr_lb_12=corr_im_lb(1:m-1,3:4);
    corr_im_34=corr_im_lb(1:m-1,5:6);
    corr_lb_34=corr_im_lb(1:m-1,7:8);

    QC=[min(corr_im_12(:)),min(corr_lb_12(:)),min(corr_im_34(:)),min(corr_lb_34(:))];
else
    QC=ones(1,4);
end

end

function corr_im_lb=getCorrelationImLb(im1,im2,lb1,lb2)
c1=corrcoef(im1(:),im2(:));
dice=@(X,Y) 2* sum(X(:) & Y(:))/sum(X(:)+Y(:));
% c2=corrcoef(double(lb1(:)),double(lb2(:)));
% corr_im_lb=[c1(1,2),c2(1,2)];
corr_im_lb=[c1(1,2),dice(lb1,lb2)];
end
