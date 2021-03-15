function getAsegAparcADNILong
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
    xmlPath='/home/gillana/Demo/MRI/AD_17v_15s/xml/';
    path_subj='/home/gillana/Demo/MRI/AD_17v_15s/Long/';
    
    %% Long
    % For this type of processing SUBJECTS_DIR must be changed to the Long
    % folder
     
    name_dat='clinicaldata_long_15v_14s_NC.dat';
    name_xlsx='clinicaldata_long_15v_14s_NC.xlsx';
    %QdecTableLong(xmlPath,path_subj,name_dat);
    QdecTableLong(xmlPath,path_subj,name_xlsx);
    
    %Hasta que se encuentre un método mejor
    name_dat='clinicaldata_long_15v_14s_NC.xlsx';
    
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
    
% %     command = strcat('mv',32,name_dat,32,'aparc_long_rh.',name_dat,32,...
% %         'aparc_long_lh.',name_dat,32,'aseg_long.',name_dat,32,destination_path);
% %     disp(command);
% %     system(command);
     
    
    rmpath('./aux_getAsegAparcADNI/');
end








