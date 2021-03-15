function comparative_DTI_Tadpole
% Comparative between ADNIMERGE (cross 4.3) and Freesufer longitudinal
% pipeline (only T1)

%% data

%Yuzhi+idelacalle
load('./data/Tresults_T1_DTI_382v_117s', 'Tresults');

%DTI TadpoleD1D2
load('./data/DTI_TadpoleD1D2', 'DTItadpoleD1D2');
DTItadpoleD1D2=DTItadpoleD1D2(:,[1:14,103,475,1658:1895]);

%% index join
PTID=string(DTItadpoleD1D2.PTID);
fsidbase=string(Tresults.fsidbase_DTI);

T1_examDate=Tresults.EXAMDATE_ADNI;
EXAMDATE_ADNI=DTItadpoleD1D2.EXAMDATE;
UID_1=Tresults.IMAGEUID;
UID_ADNI_1=str2double(string(DTItadpoleD1D2.IMAGEUID_UCSFFSL_02_01_16_UCSFFSL51ALL_08_01_16));
UID_ADNI_2=str2double(string(DTItadpoleD1D2.IMAGEUID_UCSFFSX_11_02_15_UCSFFSX51_08_01_16));


index=zeros(size(Tresults,1),1);
k=1;
clc;
for i=1:length(index)
%% VISCODE    
%     tmp=find(strcmp(PTID,fsidbase(i)) & DTItadpoleD1D2.VISCODE==Tresults.VISCODE_ADNI(i));
%     if(length(tmp)==1)
%         index(i)=tmp;
%     else
%         fprintf('%d: %s %s without conection with Tadpole table\n',i,fsidbase(i),...
%             Tresults.VISCODE_ADNI(i));
%     end
%% EXAMDATE
    index_ID=find(strcmp(PTID,fsidbase(i)));
    [diff_EXAM,idx]=min(abs(EXAMDATE_ADNI(index_ID)-T1_examDate(i)));
    if(days(diff_EXAM)<1e2)
        index(i)=index_ID(idx);
%         if(UID_ADNI_2(index_ID(idx))~=UID_1(i))
%             fprintf('Warning %d: %s with same date but different IMAGEUID.\n',...
%                 i,string(Tresults.fsid(i)));
%         end
    else
        fprintf('Error %d: %s with different date ',k,string(Tresults.fsid(i)));
        k=k+1;
        idx=find(UID_ADNI_2(index_ID)==UID_1(i));
        if(length(idx)==1)
            index_ADNI(i)=index_ID(idx);
            fprintf('and has an unique UID in ADNI.\n');
         elseif(isempty(idx))
            fprintf('and does not have UID in ADNI.\n');
         else
            fprintf('and has multiple UID in ADNI.\n');
        end
    end            
    
end
%% Comparative with hippocampal volume and ICV
figure(1);

subplot(2,2,1);
MD_CGH_L=str2double(string(DTItadpoleD1D2.MD_CGH_L_DTIROI_04_30_14));
plot(Tresults.MD_CGH_L(index>0),MD_CGH_L(index(index>0)),'+');
xlabel('Tadpole table');
ylabel('TBSS');
title('Comparison with Left CGH');

subplot(2,2,2);
FA_SCR_R=str2double(string(DTItadpoleD1D2.FA_SCR_R_DTIROI_04_30_14));
plot(Tresults.FA_SCR_R(index>0),FA_SCR_R(index(index>0)),'+');
xlabel('Tadpole table');
ylabel('TBSS');
title('Comparison with Rigth FA SCR');

subplot(2,2,3);
AD_CGH_L=str2double(string(DTItadpoleD1D2.AD_CGH_L_DTIROI_04_30_14));
plot(Tresults.AD_CGH_L(index>0),AD_CGH_L(index(index>0)),'+');
xlabel('Tadpole table');
ylabel('TBSS');
title('Comparison with Left AD CGH');


subplot(2,2,4);
RD_SS_R=str2double(string(DTItadpoleD1D2.RD_SS_R_DTIROI_04_30_14));
plot(Tresults.RD_SS_R(index>0),RD_SS_R(index(index>0)),'+');
xlabel('Tadpole table');
ylabel('TBSS');
title('Comparison with Rigth RD SS');

figure(2);
subplot(1,2,1);
FA_CGH_R=str2double(string(DTItadpoleD1D2.FA_CGH_R_DTIROI_04_30_14));
plot(Tresults.FA_CGH_R(index>0),FA_CGH_R(index(index>0)),'+');
xlabel('Tadpole table');
ylabel('TBSS');
title('Comparison with Rigth FA CGH');

subplot(1,2,2);
FA_PTR_L=str2double(string(DTItadpoleD1D2.FA_PTR_L_DTIROI_04_30_14));
plot(Tresults.FA_PTR_L(index>0),FA_PTR_L(index(index>0)),'+');
xlabel('Tadpole table');
ylabel('TBSS');
title('Comparison with Left FA PTR');


%m=[Tresults.MD_CGH_L(index>0),MD_CGH_L(index(index>0))];
% index=find(Tresults.Hippocampus==3737);
% text(Tresults.Hippocampus(index),Tresults.LHippVol(index)+Tresults.RHippVol(index),...
%     '094\_S\_1293: m24');
% 
% for i=index-3:index
%     fprintf('%.0f %.0f\n',Tresults.Hippocampus(i),Tresults.LHippVol(i)+Tresults.RHippVol(i));
% end
% 



end