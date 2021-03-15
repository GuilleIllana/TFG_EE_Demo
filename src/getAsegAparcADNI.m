function getAsegAparcADNI
    % Generates files with clinical and demographic data * .dat, as well as
    % information of subcortical structures (aseg) and cortical (aparc)
    % files. This files will later be converted into tables and more
    % neuropsicological factors will be added in form of new columns.
    % It is prepared for the long. For the cross comment the long code and
    % uncomment the cross.
    
    %% Freesurfer variables
    % export FREESURFER_HOME=/usr/local/freesurfer
    % source /usr/local/freesurfer/SetUpFreeSurfer.sh
    % export SUBJECTS_DIR = /path_to_Subjects_dir
    %% data
    addpath('./aux_getAsegAparcADNI/');
    xmlPath='../xml/';
    path_subj='../Long/';
    destination_path = './Data_15v_15s/';
    %% Cross
    
%     typePross='Cross';
%     name_dat='clinicaldata_cross_conversores_precl.dat';
%      QdecTable(xmlPath,path_subj,typePross,name_dat);
%     
%     command= strcat('asegstats2table --qdec',32,name_dat,32,...
%     '-t ./aseg_cross.',name_dat);
%     disp(command);
%     system(command);
%     
%     command= strcat('aparcstats2table --qdec',32,name_dat,32,...
%     '-t ./aparc_cross_lh.',name_dat,32,'--hemi lh --meas thickness');
%     disp(command);
%     system(command);
%     
%     command= strcat('aparcstats2table --qdec',32,name_dat,32,...
%     '-t ./aparc_cross_rh.',name_dat,32,'--hemi rh --meas thickness');
%     disp(command);
%     system(command);
    
    %% Long
    % For this type of processing SUBJECTS_DIR must be changed to the Long
    % folder
    
    typePross='Long';
    name_dat='clinical_MCI_15v_15s_gillana.dat';
    QdecTable(xmlPath,path_subj,typePross,name_dat);
    
    % generation of aseg file with subcortical structures info. The
    % --common-segs flag makes data homogenous ensuring that only the
    % segmentations obtained in all visits are used to build the aseg file.
    command= strcat('asegstats2table --qdec-long',32,name_dat,32,...
        '-t ./aseg_long.',name_dat,32,'--common-segs --skip');
    disp(command);
    system(command);
    
    % generation of aparc file with left hemisphere cortical structures
    % info.
    command= strcat('aparcstats2table --qdec-long',32,name_dat,32,...
        '-t ./aparc_long_lh.',name_dat,32,'--hemi lh --meas thickness --skip');
    disp(command);
    system(command);
    
    % generation of aparc file with right hemisphere cortical structures
    % info.
    command= strcat('aparcstats2table --qdec-long',32,name_dat,32,...
        '-t ./aparc_long_rh.',name_dat,32,'--hemi rh --meas thickness --skip');
    disp(command);
    system(command);
    
    command = strcat('mv',32,name_dat,32,'aparc_long_rh.',name_dat,32,...
        'aparc_long_lh.',name_dat,32,'aseg_long.',name_dat,32,destination_path);
    disp(command);
    system(command);
    
    
    rmpath('./aux_getAsegAparcADNI/');
end








