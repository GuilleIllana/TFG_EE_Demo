function comparative_FScross_FSLong
% Comparative between ADNIMERGE (cross 4.3) and Freesufer longitudinal
% pipeline (only T1)

%% data

%MCItoAD T1
% load('./data/Tresults_MCItoAD_1330v', 'Tresults');

% MCI-to-AD T1+DTI
%idelacalle
% load('./data/Tresults_T1DTI_110v_31s', 'Tresults');

%Yuzhi
% load('./data/Tresults_T1DTI_274v_86s', 'Tresults');
% load('./data/Tresults_T1DTI_272v_86s', 'Tresults');


%Yuzhi+idelacalle
% load('../Generate_Tresults/Data_413v_122s_sMCI_pMCI/Tresults_413v_122s.mat', 'Tresults');
load('./data/2021/Tresults_413v_122s.mat', 'Tresults');
% Tresults.Hippocampus=str2double(Tresults.Hippocampus);
% Tresults.ICV_ADNI=str2double(Tresults.ICV);
%% Comparative with hippocampal volume and ICV
figure(1);
subplot(1,2,1);
mask_hippocampus=isnan(Tresults.Hippocampus)==0;
plot(Tresults.Hippocampus(mask_hippocampus),Tresults.LHippVol(mask_hippocampus)+...
    Tresults.RHippVol(mask_hippocampus),'+');
xlabel('Freesurfer cross-sectional  v 4.3');
ylabel('Freesurfer longitudinal  v 5.3');
title('Comparison with Hippocampal volume');
% index=find(Tresults.Hippocampus==3737);
% text(Tresults.Hippocampus(index),Tresults.LHippVol(index)+Tresults.RHippVol(index),...
%     '094\_S\_1293: m24');
% 
% for i=index-3:index
%     fprintf('%.0f %.0f\n',Tresults.Hippocampus(i),Tresults.LHippVol(i)+Tresults.RHippVol(i));
% end
% 


subplot(1,2,2);
mask_ICV=isnan(Tresults.ICV)==0;
plot(Tresults.ICV(mask_ICV),Tresults.ICV(mask_ICV),'+');
xlabel('Freesurfer cross-sectional  v 4.3');
ylabel('Freesurfer longitudinal  v 5.3');
title('Comparison with ICV');
% 1330
% index=find(Tresults.ICV<1374e3 & Tresults.ICV>1372e3);
% text(Tresults.ICV(index),Tresults.ICV_Tdec(index),...
%     '094\_S\_1293: m24');
% 
% for i=index-3:index
%     fprintf('%.0f %.0f\n',Tresults.ICV(i),Tresults.ICV_Tdec(i));
% end

% T1+DTI MCI to AD
% index=find(abs(Tresults.ICV-1.611e6)<1e4 & abs(Tresults.ICV-1.316e6)<1e4);
% text(Tresults.ICV(index),Tresults.ICV_Tdec(index),...
%     '094\_S\_1293: m24');
% 
% for i=index-3:index
%     fprintf('%.0f %.0f\n',Tresults.ICV(i),Tresults.ICV_Tdec(i));
% end
% 

end