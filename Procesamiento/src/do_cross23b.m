function do_cross23b()
    
    %% Preparation
    
    % This is the path where all the data obtained from recon_all will be saved
    % It must be the same directory as the $SUBJECTS_DIR in Freesurfer
    %pathSubj = '../Cross/';
    %pathSubj = '/home/llopez/TFG/PPMI/Cross/';
    pathSubj = '../Cross/';
       
    % This is the path where all the .nii.gz input files are stored.
    %pathId = '../data/Parte2/';
    pathId = '../nii/';
    
    %% Data
    %.nii.gz files are stored for further use in the code:
    %listFichImg = dir(pathSubj);
    %listFichImg(1)=[];
    %listFichImg(1)=[];
    
    listFichImg = dir(strcat(pathId,'*.nii'));
    
    % Number of files is used for the main itteration.
    numID=numel(listFichImg);
    
    %% Main loop
    clc;
    
    k=1;
    for i=1:numID
        %% Defining subject dir and aseg.stats path
        % This is be the directory inside SUBJ_DIR where all the data will be
        % saved.
        %subjDir = strcat(pathSubj, listFichImg(i).name);
        subjDir = strcat(pathSubj, listFichImg(i).name(1:end-4));
        
        % The aseg.stats file is used to make sure that the process has been
        % succesful. It also avoids unnecessary itterations from past files.
        stats = strcat(subjDir,'/stats/aseg.stats');
        
        if(exist(stats,'FILE'))
            fprintf('%d:Done %s\n',k,listFichImg(i).name);
            k=k+1;
        else
            fprintf('Autorecon23 does not process in this subject: %s\n',...
                listFichImg(i).name);
        end
        
    end
end
