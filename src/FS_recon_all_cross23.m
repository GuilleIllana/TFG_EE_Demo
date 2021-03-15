function FS_recon_all_cross23()
%parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')));

    %% Description
    % This script is charged of doing a Cross segmentation over the different
    % .nii.gz files executing the Freesurfer command recon-all -autorecon2 and
    % -autorecon3. This is the most computational expensive process, and so
    % paralel processing is recomended when computing several subjects.
    
    %% Freesurfer previous inizialization
    % export FREESURFER_HOME=/usr/local/freesurfer
    % source /usr/local/freesurfer/SetUpFreeSurfer.sh
    % export SUBJECTS_DIR='/home/javierr/Desktop/Cross/'
    
    %% About strcat(),sprintf(),display(), disp() fprintf() and system():
    % To concatenate: strcat.
    % To include variables into a string: sprintf
    % To show information in Matlab: display or disp
    % To combine sprintf and display: fprintf
    % To execute in the terminal: system
    
    %% Preparation
    
    % This is the path where all the data obtained from recon_all will be saved
    % It must be the same directory as the $SUBJECTS_DIR in Freesurfer
    pathSubj = '../Cross/';
    
    % This is the path were conflictive files will be saved
    pathError = '../Error/';
    
    % This is the path where all the .nii.gz input files are stored.
    pathId = '../nii/';
    
    
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
        subjDir = strcat(pathSubj, listFichImg(i).name(1:end-7));
        
        % The aseg.stats file is used to make sure that the process has been
        % succesful. It also avoids unnecessary itterations from past files.
        stats = strcat(subjDir,'/stats/aseg.stats');
        subjName = listFichImg(i).name(1:end-7);
        
        if(exist(stats,'FILE')==0)
            %% Determine subject id.
            
           
                        
            %% Freesurfer recon-all (segmentation)
           try
                %% Autorecon23
                linecommand = sprintf('recon-all -subjid %s -autorecon2 -autorecon3 \n',subjName);
                disp(linecommand)
               system(linecommand);
                
                %% Check if exist stats to determine success
                if(exist(stats,'FILE')==0)
                    disp('brainmask.mgz file could not be generated. Recon_all did not work properly');
                    orig=strcat(pathSubj,subjName);
                    dest=strcat(pathError,subjName);
                    movefile(orig,dest);
                end
                
            catch
                disp('Unexpected error in autorecon23');
                orig=strcat(pathSubj,subjName);
                dest=strcat(pathError,subjName);
                movefile(orig,dest);
            end
            
        else
            fprintf('Autorecon23 already done in this subject: %s\n',subjName);
        end
        
    end
    % parpool close;
    % delete(pp);
%delete(gcp);    
end
