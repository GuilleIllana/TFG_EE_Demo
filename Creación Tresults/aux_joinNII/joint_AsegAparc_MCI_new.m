function Tdec=joint_AsegAparc_MCI_new

% addpath('./external/lme/Qdec/');

%% Read demographic and clinical data

%% Gauss/media/Elements/Copernico/Lin
%Gauss/media/6T/Lyapunov/lin/hipocampo/ADNI
%Gauss/media/Elements/Gauss/sliebana/PacientesCompletados

%V668
% 668 sMCI vs pMCI(16/17)
%
% 17/18
% fdemographic='./data/17_18/clinical_pMCI_148_1718.dat';
% faseg='./data/17_18/aseg_long.clinical_pMCI_148_1718.dat';
% faparc_lh='./data/17_18/aparc_long_lh.clinical_pMCI_148_1718.dat';
% faparc_rh='./data/17_18/aparc_long_rh.clinical_pMCI_148_1718.dat';
% Tdec=readClinicalData(fdemographic);
% TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
% T148=[Tdec,TMarkers];

%% Gauss/media/Elements/Copernico/Jaime/Long
%Gauss/media/6T/Copernico/jsimarro/Extract_Data_V1
% fdemographic='./data/17_18/clinical_Jaime_1718.dat';
% faseg='./data/17_18/aseg_long.pMCI_Jaime_1718.dat';
% faparc_lh='./data/17_18/aparc_long_lh.pMCI_Jaime_1718.dat';
% faparc_rh='./data/17_18/aparc_long_rh.pMCI_Jaime_1718.dat';
% Tdec=readClinicalData(fdemographic);
% TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
% T110=[Tdec,TMarkers];

%% Gauss/media/Elements/Gauss/ywu/Sorted/SORTED_ESKILSEN/XML
%/media/Elements/Gauss/ywu/Eskilsen
% fdemographic='./data/17_18/clinical_sMCI_jwu.dat';
% faseg='./data/17_18/aseg_long.clinical_sMCI_jwu.dat';
% faparc_lh='./data/17_18/aparc_long_lh.clinical_sMCI_jwu.dat';
% faparc_rh='./data/17_18/aparc_long_rh.clinical_sMCI_jwu.dat';
% Tdec=readClinicalData(fdemographic);
% TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
% T343=[Tdec,TMarkers];


%% Gauss/media/6T/Newton/jrojo/DEMO/Sorted/nii
% fdemographic='./data/17_18/clinical_MCI_jrojo_1718.dat';
% faseg='./data/17_18/aseg_long.clinical_MCI_jrojo_1718.dat';
% faparc_lh='./data/17_18/aparc_long_lh.clinical_MCI_jrojo_1718.dat';
% faparc_rh='./data/17_18/aparc_long_rh.clinical_MCI_jrojo_1718.dat';
% Tdec=readClinicalData(fdemographic);
% TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
% T209=[Tdec,TMarkers];

%% Curie/media/bck/mballe/Procesamiento/T1/AD_106v_44s/Long
% fdemographic='./data/106v_44s/clinicaldata_long_106v_44s_mballe_1920.dat';
% faseg='./data/106v_44s/aseg_long.clinical_AD_106v_44s_mballe_1920.dat';
% faparc_lh='./data/106v_44s/aparc_long_lh.clinical_AD_106v_44s_mballe_1920.dat';
% faparc_rh='./data/106v_44s/aparc_long_rh.clinical_AD_106v_44s_mballe_1920.dat';

fdemographic='./data/106v_44s/clinicaldata_long_106v.dat';
faseg='./data/106v_44s/aseg_long.clinicaldata_long_106v.dat';
faparc_lh='./data/106v_44s/aparc_long_lh.clinicaldata_long_106v.dat';
faparc_rh='./data/106v_44s/aparc_long_rh.clinicaldata_long_106v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T106=[Tdec,TMarkers];

%% Gauss/media/6T/Copernico/cplatero/MCI/Long_aux
fdemographic='./data/116v_33s/clinicaldata_long_116v.dat';
faseg='./data/116v_33s/aseg_long.clinicaldata_long_116v.dat';
faparc_lh='./data/116v_33s/aparc_long_lh.clinicaldata_long_116v.dat';
faparc_rh='./data/116v_33s/aparc_long_rh.clinicaldata_long_116v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T116=[Tdec,TMarkers];


%% Gauss/media/Elements/Copernico/Jaime/Long
fdemographic='./data/148v_39s/clinicaldata_long_148v.dat';
faseg='./data/148v_39s/aseg_long.clinicaldata_long_148v.dat';
faparc_lh='./data/148v_39s/aparc_long_lh.clinicaldata_long_148v.dat';
faparc_rh='./data/148v_39s/aparc_long_rh.clinicaldata_long_148v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T148=[Tdec,TMarkers];

%% Gauss/media/6T/Newton/jrojo/DEMO/Long
fdemographic='./data/209v_42s/clinicaldata_long_209v.dat';
faseg='./data/209v_42s/aseg_long.clinicaldata_long_209v.dat';
faparc_lh='./data/209v_42s/aparc_long_lh.clinicaldata_long_209v.dat';
faparc_rh='./data/209v_42s/aparc_long_rh.clinicaldata_long_209v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T209=[Tdec,TMarkers];

%% Gauss/media/Elements/Gauss/ywu/Eskilsen/Long
fdemographic='./data/343v_65s/clinicaldata_long_343v.dat';
faseg='./data/343v_65s/aseg_long.clinicaldata_long_343v.dat';
faparc_lh='./data/343v_65s/aparc_long_lh.clinicaldata_long_343v.dat';
faparc_rh='./data/343v_65s/aparc_long_rh.clinicaldata_long_343v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T343=[Tdec,TMarkers];


%% Curie/media/bck/mballe/Procesamiento/T1/sMCI_pMCI_413v_122s/Long
% fdemographic='./data/413v_122s/clinical_MCI_413v_122s_mballe_1920.dat';
% faseg='./data/413v_122s/aseg_long.clinical_MCI_413v_122s_mballe_1920.dat';
% faparc_lh='./data/413v_122s/aparc_long_lh.clinical_MCI_413v_122s_mballe_1920.dat';
% faparc_rh='./data/413v_122s/aparc_long_rh.clinical_MCI_413v_122s_mballe_1920.dat';

fdemographic='./data/413v_122s/clinicaldata_long_413v.dat';
faseg='./data/413v_122s/aseg_long.clinicaldata_long_413v.dat';
faparc_lh='./data/413v_122s/aparc_long_lh.clinicaldata_long_413v.dat';
faparc_rh='./data/413v_122s/aparc_long_rh.clinicaldata_long_413v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T413=[Tdec,TMarkers];


%% Gauss/media/6T/Copernico/cplatero/MCI/Long
fdemographic='./data/554v_149s/clinicaldata_long_554v.dat';
faseg='./data/554v_149s/aseg_long.clinicaldata_long_554v.dat';
faparc_lh='./data/554v_149s/aparc_long_lh.clinicaldata_long_554v.dat';
faparc_rh='./data/554v_149s/aparc_long_rh.clinicaldata_long_554v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T554=[Tdec,TMarkers];


%% Gauss/media/Elements/Gauss/sliebana/PacientesCompletados/Long
fdemographic='./data/102v_28s/clinicaldata_long_102v.dat';
faseg='./data/102v_28s/aseg_long.clinicaldata_long_102v.dat';
faparc_lh='./data/102v_28s/aparc_long_lh.clinicaldata_long_102v.dat';
faparc_rh='./data/102v_28s/aparc_long_rh.clinicaldata_long_102v.dat';
Tdec=readClinicalData(fdemographic);
TMarkers=convertAsegAparc2Table(faseg,faparc_lh,faparc_rh);
T102=[Tdec,TMarkers];


%% all
% Tdec=[T106;T116;T148;T209;T343;T413;T554;T102]; % Todas 
% Tdec=[T116;T148;T209;T343;T554;T102;T106]; % Todas menos T413 
% Tdec=[T106;T413]; % mballe
% Tdec=T413; % Testing and checking
%% Checking
fsid=unique(Tdec.fsid);
delete_visits=[];
num_duplicate_visits=0;
for i=1:length(fsid)
    index=find(strcmp(Tdec.fsid,fsid(i)));
    if(length(index)>1)
        fprintf(2,'duplicate visit: %s number of repetitions %d\n',string(fsid(i)),length(index)-1);
        delete_visits=[delete_visits;index(2:end)];
        num_duplicate_visits=num_duplicate_visits+1;
    end        
end
display(num_duplicate_visits);
Tdec(delete_visits,:)=[];

%% Exit
% rmpath('./external/lme/Qdec/');

end



function Tdec=readClinicalData(fname)

Qdec = fReadQdec(fname);
Tdec=cell2table(Qdec(2:end,:));
varname=cellstr(Qdec(1,:));
varname{2}='fsidbase';
Tdec.Properties.VariableNames=varname;
Tdec.years=str2double(Tdec.years);
Tdec.Age=str2double(Tdec.Age);

Tdec.MMSE=str2double(Tdec.MMSE);
Tdec.GDS=str2double(Tdec.GDS);
Tdec.CDR=str2double(Tdec.CDR);

Tdec.IMAGEUID=double(string(Tdec.IMAGEUID));

Tdec.APOE_A1=str2double(Tdec.APOE_A1);
Tdec.APOE_A2=str2double(Tdec.APOE_A2);


%% NEW CODE

Tdec.FAQ=str2double(Tdec.FAQ);
Tdec.EXAMDATE=datetime(Tdec.EXAMDATE);
Tdec.fsidbase=categorical(Tdec.fsidbase);
Tdec.sex=categorical(Tdec.sex);
Tdec.diagnose=categorical(Tdec.diagnose);

Tdec.fsid=string(Tdec.fsid);
rid=extractBetween(Tdec.fsid,'S_','_');


    
m12=strcmp(Tdec.CODE,'m12');
m12_rid=unique(rid(m12));
for i=1:length(m12_rid)
    aux=m12_rid{i};
    m12_EXAMDATE=Tdec.EXAMDATE(rid==aux & m12);
    
    if numel(m12_EXAMDATE)>1 %if 2 m12 samples exist and m60 for one rid, the oldest is m72
        older=max(m12_EXAMDATE);
        m72=Tdec.EXAMDATE==older & m12 & rid==aux;
        Tdec.CODE(m72)={'m72'};
    end
end

    m60=strcmp(Tdec.CODE,'m60');
    m60_rid=unique(rid(m60));

    for i=1:length(m60_rid)
        aux=m60_rid{i};
        m12=strcmp(Tdec.CODE,'m12') & rid==aux;
        m12_EXAMDATE=Tdec.EXAMDATE(m12);
        m60_EXAMDATE=Tdec.EXAMDATE(rid==aux & m60);
        if numel(m12_EXAMDATE)>1 % if 2 m12 samples exist and m60 for one rid, the oldest is m72
            older=max(m12_EXAMDATE);
            m72=Tdec.EXAMDATE==older & m12;
            Tdec.CODE(m72)={'m72'};
        elseif numel(m60_EXAMDATE)>1 % if 2 m60 samples exist for one rid, the oldest is m72
            older=max(m60_EXAMDATE);
            m72=Tdec.EXAMDATE==older & m60;
            Tdec.CODE(m72)={'m72'};
        elseif numel(m60_EXAMDATE)==1 % if 1 m60 exists for one rid but m72 does not exist, check previous EXAMDATE
            index=find(Tdec.EXAMDATE==m60_EXAMDATE & rid==aux);
            reference=Tdec.EXAMDATE(index-1);
            diff=m60_EXAMDATE-reference;
            m72=index;
            if diff>hours((60+6-48)*30*24) && strcmp(Tdec.CODE(index-1),'m48') % 6 months margin
                Tdec.CODE(m72)={'m72'};
            elseif diff>hours((60+6-36)*30*24) && strcmp(Tdec.CODE(index-1),'m36')
                Tdec.CODE(m72)={'m72'};
            elseif diff>hours((60+6-24)*30*24) && strcmp(Tdec.CODE(index-1),'m24')
                Tdec.CODE(m72)={'m72'};
            elseif diff>hours((60+6-12)*30*24) && strcmp(Tdec.CODE(index-1),'m12')
                Tdec.CODE(m72)={'m72'};
            end
        end
    end

    Tdec.CODE=categorical(Tdec.CODE);
    
    var=size(Tdec);
    for i=1:var(2)
        column=Tdec{:,i};
        numeric=isnumeric(column);
        if numeric
            NULL=column==-1;
            column(NULL)=NaN;
            Tdec{:,i}=column;
        end
    end
   
end


function TMarkers=convertAsegAparc2Table(fname_aseg,fname_aparc_lh,fname_aparc_rh)

[aseg,~,asegcols] =  fast_ldtable(fname_aseg);
asegcols=cellstr(asegcols); % convert column names into cell string
id=[find(strcmp('Left-Hippocampus',asegcols)==1),...
    find(strcmp('Right-Hippocampus',asegcols)==1),...
    find(strcmp('EstimatedTotalIntraCranialVol',asegcols)==1),...
    find(strcmp('lhCortexVol',asegcols)==1),...
    find(strcmp('rhCortexVol',asegcols)==1),...%5
    find(strcmp('Left-Putamen',asegcols)==1),...
    find(strcmp('Right-Putamen',asegcols)==1),...
    find(strcmp('Left-Pallidum',asegcols)==1),...
    find(strcmp('Right-Pallidum',asegcols)==1),...
    find(strcmp('Left-Caudate',asegcols)==1),...%10
    find(strcmp('Right-Caudate',asegcols)==1),...
    find(strcmp('Left-Amygdala',asegcols)==1),...
    find(strcmp('Right-Amygdala',asegcols)==1),...
    find(strcmp('Left-Lateral-Ventricle',asegcols)==1),...   
    find(strcmp('Right-Lateral-Ventricle',asegcols)==1),...%15           
    ];
HV = aseg(:,id);
TAseg=table(HV(:,1),HV(:,2),HV(:,3),HV(:,4),HV(:,5),HV(:,6),HV(:,7),HV(:,8),HV(:,9),HV(:,10),HV(:,11),HV(:,12),HV(:,13),HV(:,14),HV(:,15),...
    'VariableNames',{'LHippVol','RHippVol','ICV','LCortVol','RCortVol','LPutamen','RPutamen','LPallidum','RPallidum','LCaudete','RCaudete','LAmygdala','RAmigdala','LLatVentr','RLatVentr'});

[aparc_lh,~,aparc_lhcols] =  fast_ldtable(fname_aparc_lh);

aparc_lhcols=cellstr(aparc_lhcols); % convert column names into cell string
id_lh=[find(strcmp('lh_entorhinal_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_temporalpole_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_inferiortemporal_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_middletemporal_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_inferiorparietal_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_superiorparietal_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_precuneus_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_posteriorcingulate_thickness',aparc_lhcols)==1),...
    find(strcmp('lh_MeanThickness_thickness',aparc_lhcols)==1)];

[aparc_rh,~,aparc_rhcols] =  fast_ldtable(fname_aparc_rh);

 aparc_rhcols=cellstr(aparc_rhcols); % convert column names into cell string           
 id_rh=[find(strcmp('rh_entorhinal_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_temporalpole_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_inferiortemporal_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_middletemporal_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_inferiorparietal_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_superiorparietal_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_precuneus_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_posteriorcingulate_thickness',aparc_rhcols)==1),...
    find(strcmp('rh_MeanThickness_thickness',aparc_rhcols)==1)];

TH=[aparc_lh(:,id_lh),aparc_rh(:,id_rh)];
TApar=table(TH(:,1),TH(:,10),TH(:,9),TH(:,18),TH(:,2),TH(:,3),TH(:,4),TH(:,5),TH(:,6),TH(:,7),TH(:,8),...
    TH(:,11),TH(:,12),TH(:,13),TH(:,14),TH(:,15),TH(:,16),TH(:,17),...
    'VariableNames',{'L_ECT','R_ECT','L_MT','R_MT','LtmpPole','LinfTmp','LmidTmp','LinfPar','LsupPar','Lprecu','LpostCing','RtmpPole','RinfTmp','RmidTmp','RinfPar','RsupPar','Rprecu','RpostCing'});
TMarkers=[TAseg,TApar];


end



