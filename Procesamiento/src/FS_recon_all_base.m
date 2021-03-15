function FS_recon_all_base()
%parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')));

    %% Description
    % Input: norm.mgz of all images of the subject.
    % Output: template of the subject.
    
    %% Preparation
    
    % This is the path where the results of recon_all are. It must be the same
    % directory as the $SUBJECTS_DIR in Freesurfer
    pathSubj = '../Cross/';
    
    %This is the maximum number of images planified. A very low value may
    %ignore the information of the last visists.
    n_images = 8;
    
    %listFichImg stores the directory where the subjects are stored. At this
    %moment numID refers to the number of all subdirectories, including . , ..
    %and soft links.
    listFichImg = dir(pathSubj);
    numID=numel(listFichImg);
    
    % ListImg will store different subjects in different rows, and different
    % visits in different columns.
    row=1;
    col=1;
    listImg=cell(1,n_images);
    
    %% Avoiding non desirable directories
    % In this first loop, the indexes of undesired subdirectories of pathSubj
    % are stored in the vector called index. The user might add any other
    % directory (p.e.: a tmp folder used to store some screenshots of the
    % process or any document)
    
    n=1;
    for i=1:numID
        if(strcmp(listFichImg(i).name,'.')||strcmp(listFichImg(i).name,'..')||...
                strcmp(listFichImg(i).name,'fsaverage')||strcmp(listFichImg(i).name,'lh.EC_average')||...
                strcmp(listFichImg(i).name,'rh.EC_average'))
            index(n)=i;
            n=n+1;
        end
    end
    
    % Here the previously selected directories are set to zero, and numID is
    % updated to its new value.
    listFichImg(index)=[];
    numID=numel(listFichImg);
    
    %% Preparation loop
    % This is the loop where the names of the different subjects (rows) and
    % different visits (columns) are stored. The variable template indicates
    % the current subject. The subject correspond to the first 10 characters
    % inside the name. The rest would correspond to the visit.
    
    template=listFichImg(1).name(1:10);
    
    for i=1:numID
        if(strncmp(listFichImg(i).name(),template,10))
            % This is the case when listFichImg(i) is another image of the
            % subject template. In this case, it is stored and the pointer col
            % pass to the next image.
            
            listImg{row,col}=listFichImg(i).name();
            col=col+1;
            
        elseif(strncmp(listFichImg(i).name(),template,10)==0)
            % This is the case when listFichImg(i) is an image of another
            % subject. In this case, a new template is created. The name of the
            % new subject is stored in the variable template.
            template=listFichImg(i).name(1:10);
            row=row+1;
            
            % The detected image is the first of the new subject, and so it is
            % stored in the first position
            listImg{row,1}=listFichImg(i).name();
            col=2;
        end
    end
    
    
    %% Template creation loop
    
    %numP stores the number of patients. This reflects the number of times that
    %Freesurfer will have to be executed.
    numP=numel(listImg(:,1));
    
    % The parpool tool is used to allow some computers to work in parallel.
    % There are some issues between different Matlab versions.
    % parfor is a for loop that enables parallelism
    
    
    % delete(gcp('nocreate'));
    % pp = parpool('local',8);
    % parpool local 2;
    
    parfor i=1:numP
        
        % First element of recon-all comand parameters is the output file
        % (named after the subject)
        aux=listImg{i,1}(1:10);
        
        % This for loop builds up the parameters string
        for j=1:n_images
            %Due to the variable size of the number of images it is necessary
            %to check the cell
            if ~isempty(listImg{i,j})
                aux=[aux, ' -tp ' pathSubj,listImg{i,j}];
            end
        end
        
        % Finally the recon-all -base comand is concatenated with the parameters
        % that have been built up before
        linecommand = sprintf( 'recon-all -base %s -all \n',aux);
        disp(linecommand)
        system(linecommand);
        
    end
    % delete(pp);
    % parpool close;
% delete(gcp);  
end
