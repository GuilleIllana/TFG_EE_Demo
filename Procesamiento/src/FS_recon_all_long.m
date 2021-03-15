function FS_recon_all_long()
% parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')));

    %% Description
    % This function is charged of executing the longitudinal segmentation based
    % on the information given by a cross segmentation and base (template).
    % This means that the operation will be executed for every visit.
    %
    % Input:Cross and Base processed files
    %
    % Output: Longitudinal segmentation
    
    %% Preparation
    %
    % This is the path where the results of recon_all are. It must be the same
    % directory as the $SUBJECTS_DIR in Freesurfer
    pathSubj = '../Cross/';
    
    %The results of the recon-all -base command will be moved to this directory
    BaseDir = '../Base/';
    
    %The results of the recon-all -long command will be moved to this directory
    LongDir = '../Long/';
    
    %listImg stores the subdirectories in pathSubj. This includes the cross
    %files and the base files.
    listImg=dir(pathSubj);
    numID=numel(listImg);
    
    
    %% Image register
    % For each subject the recon-all -long command is executed.
    % The parpool tool is used to allow some computers to work in parallel.
    % There are some issues between different Matlab versions.
    % parfor is a for loop that enables parallelism
    
    %delete(gcp('nocreate'));
    %pp = parpool('local',4);
    
    
    % parpool local 7;
    parfor i=1:numID
        
        if(length(listImg(i).name())>15 && ~strcmp(listImg(i).name(end-14:end-11),'long'))
            % if it is not a base directory neither long directory:
            % if the corresponding subdirectory is one of the cross
            % segmentation ones, then the template used is named after the
            % subject name (10 first characters).
            template=strcat(pathSubj,listImg(i).name(1:10));
            img=strcat(pathSubj,listImg(i).name());
            longname=strcat(img,'.long.',listImg(i).name(1:10));
            
            if exist(strcat(longname,'/stats/aseg.stats'),'file')
                fprintf('Long processing had already been executed in %s\n',img);
            else
                try
                    fprintf('rm -r %s\n',longname);
                    fprintf('Previous Long processing unfinnished. File removed.\n');
                catch
                    % if removal returned error that means that Long
                    % directory didn't exist yet.
                    fprintf('Long processing had not been executed for subject %s\n',img);
                end
                
                %recon-all -long is executed with the template and the image of
                %this visit.
                command = sprintf( 'recon-all -long %s %s -all\n',img,template);
                disp(command)
                system(command);
            end
            
        end
    end
    %delete(pp);
    
    % parpool close;
    
    
    %% Avoiding undesirable directories
    % Undesired soft links are removed to avoid problems. These are generated
    % after the recon-all operations.
    
    listImg=dir(pathSubj);
    for i=1:numel(listImg)
        if(strcmp(listImg(i).name,'fsaverage')||strcmp(listImg(i).name,'lh.EC_average')||...
                strcmp(listImg(i).name,'rh.EC_average'))
            system(['unlink ' pathSubj,'',listImg(i).name]);
        end
    end
    
    %% Distributing the results data
    % The results of cross, base and long are redistributed. Cross files stay
    % in this folder. However, base files (10 characters of subject name) are
    % moved to the BaseDir folder. Long files (characterized by the in-name
    % 'long'. Count starts at 3 to avoid  . and ..
    
    listImg=dir(pathSubj);
    
    for i=3:numel(listImg)
        orig=strcat(pathSubj, listImg(i).name);
        
        if(length(listImg(i).name)==10)
            dest=strcat(BaseDir,listImg(i).name());
            system(['mv ' orig, ' ' dest]);
            
        elseif(strcmp(listImg(i).name(end-14:end-11),'long'))
            dest=strcat(LongDir,listImg(i).name());
            system(['mv ' orig, ' ' dest]);
        end
        
    end
    
    
% delete(gcp);    

end
