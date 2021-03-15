function FS_recon_all_cross123()
%parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')));

    %% Description
    % This script is charged of doing a Cross segmentation over the different
    % .nii.gz files executing the Freesurfer command recon-all -autorecon1.
    % This is a computational expensive process, and so parallel processing
    % is recomended when computing several subjects. This part is not as heavy
    % as the -all version, so it allows the user to find errors earlier.
    
    %% Freesurfer previous inizialization
    % export FREESURFER_HOME=/usr/local/freesurfer
    % source /usr/local/freesurfer/SetUpFreeSurfer.sh
    % export SUBJECTS_DIR='/home/cplatero/Hipocampo/fuentes/familia/Cross/'
    
    
    %% About strcat(), sprintf(), display(), disp(), fprintf() and system():
    % To concatenate: strcat.
    % To include variables into a string: sprintf
    % To show information in Matlab: display or disp
    % To combine sprintf and display: fprintf
    % To execute in the terminal: system
    
    %% Preparation
    
    % This is the path where all the data obtained from recon_all will be saved
    % It must be the same directory as the $SUBJECTS_DIR in Freesurfer
    pathSubj = '../Cross_Error/';
    
    % This is the path were conflictive files will be saved
    pathError = '../Error_Error/';
    
    % This is the path where all the .nii.gz input files are stored.
    pathId = '../nii_Error/';
    
    %% Data
    %.nii.gz files are stored for further use in the code:
    listFichImg = dir(strcat(pathId,'*.nii.gz'));
    
    % Number of files is used for the main itteration.
    numID=numel(listFichImg);
    
    %% Main loop
    % The parpool tool is used to allow some computers to work in parallel.
    % There are some issues between different Matlab versions.
    % parfor is a for loop that enables parallelism
    
    % delete(gcp('nocreate'));
    % pp = parpool('local',4);
    
    % parpool local 8;
    % parfor i=1:numID
    
    parfor i=1:numID
        %% Defining subject dir and aseg.stats path
        % This is be the directory inside SUBJ_DIR where all the data will be
        % saved.
        subjDir = strcat(pathSubj, listFichImg(i).name(1:end-7))
        
        % The brainmask.mgz file is used to make sure that the process has been
        % succesful. It also avoids unnecessary itterations from past files.
        brain = strcat(subjDir,'/mri/brainmask.mgz');
        
        if(exist(brain,'FILE')==0)
            %% Make subjects directory
            % The directories tree gets ready to store the fifferent files
            % created by Freesurfer during recon-all.
            
            makeDir =  sprintf ('mksubjdirs %s \n',subjDir);
            disp(makeDir);
            system(makeDir);
            subjName = listFichImg(i).name(1:end-7);
            
            %% Initial volume
            % The .nii.gz file is converted to mgz volume file and stored in
            % /mri/orig/ where Freesurfer will look for it later, when
            % executing the recon-all function
            
            niiFile = strcat(pathId,listFichImg(i).name());
            mgzFile = strcat(subjDir,'/mri/orig/001.mgz');
            convert = sprintf ('mri_convert -it nii %s -ot mgz %s \n',niiFile, mgzFile);
            system(convert);
            disp(convert)
            
            %% Freesurfer recon-all (segmentation)
            try
                %% Autorecon1
                linecommand = sprintf( 'recon-all -subjid %s -all \n',subjName);
                disp(linecommand)
                system(linecommand);
                
                %% Checks for brainmask file to determine success
                if(exist(brain,'FILE')==0)
                    disp('brainmask.mgz file could not be generated. Recon_all did not work properly');
                    orig=strcat(pathSubj,subjName);
                    dest=strcat(pathError,subjName);
                    movefile(orig,dest);
                end
                
            catch
                disp('Unexpected error in autorecon1');
                orig=strcat(pathSubj,subjName);
                dest=strcat(pathError,subjName);
                movefile(orig,dest);
            end
            
        else
            fprintf('Autorecon1 already done in this subject: %s',subjName);
        end
        
    end
    %parpool close;
    % delete(pp);
%delete(gcp);
end
