function getNIIFilesv2()
    %% Desription
    % This function is charged of copying the .nii and .xml files downloaded
    % from ADNI to a more confortable directory structure (previously
    % prepared by the user). The files will be copied to their new location
    % and compressed into .nii.gz files.
    %
    % It is important to make sure that every xml file is actually directly
    % inside the pathNII specified in the first line, as they will be used
    % to determine the number of .nii files stored.
    %
    % The searchNIIFiles(pathNII) function is used to determine the number,
    % location and names of every .nii file, as well as joining all the xml
    % files in a list for later iterating  over it in the main code.
    
    %% PREPARATION
    
    % path where the xml and nii files are located
    pathNII= '../ADNI_2';
    
    % destination directory where nii files will be stored
    pathNIIDest = '../nii123';
    
    % destination directory where nii files will be stored
    pathXMLDest = '../xml123';
    
    % See searchNIIFiles(pathNII) fucntion for further information
    [listFiles,names,xmlList]=searchNIIFiles(pathNII);
    
    % number of xml elements is used to determine the total number of pairs
    % of files (xml+nii)
    fileNums=numel(xmlList);
    
    
    %% NII_________________________________________________________________
    for i=1:fileNums
        % syntax for copying files in linux.
        comand=sprintf('cp %s %s/%s',listFiles{i},pathNIIDest,names{i});
        % displays the comand in matlab for easy debugging and
        % follow the workflow
        disp(comand);
        % executes the comand in the system console/terminal
        system(comand);
        
        % The .nii file is compressed after being copied in order
        % to save disk space.
        comand=sprintf('gzip -9 %s/%s',pathNIIDest,names{i});
        system(comand);
    end
    
    
    %% XML_________________________________________________________________
    % Old code, it could cause issues naming xml files with different
    % IMAGEUID. 
%     for i=1:fileNums
%         comand=sprintf('cp %s/%s %s/%s',pathNII,xmlList(i).name,pathXMLDest,...
%             strcat('ADNI_',names{i}(1:end-3),'xml'));
%         disp(comand);
%         system(comand);
%     end
%     
      for i=1:fileNums
          comand=sprintf('cp %s/%s %s/%s',pathNII,xmlList(i).name,pathXMLDest,...
              strcat('ADNI_',xmlList(i).name([6:16,end-15:end])));
          disp(comand);
          system(comand);
      end
     
  %% CHECKING NII vs XML___________________________________________________
     Error = false;  
     xmlList_Comp=dir(strcat(pathXMLDest,'/*.xml'));
     niiList_Comp=dir(strcat(pathNIIDest,'/*.nii.gz'));
     for i=1:fileNums
       name_nii=niiList_Comp(i).name(1:end-7);
       name_xml=xmlList_Comp(i).name(6:end-4);
       if(strcmp(name_nii,name_xml)==0)
         fprintf('Error %d, nii = %s and xml = %s\n', i, name_nii, name_xml);
         Error = true;
       end
     end
     if(Error == false)
        fprintf('No errors found\n');
     end
        
end

  
%% AUXILIAR FUNCITONS

function [listFiles,names,xmlList]=searchNIIFiles(pathNII)
    %% DESCRIPTION
    %This function is charged of determining the number, location and
    %names of every .nii file, as well as joining all the xml files in a list
    %for later iterating over it in the main code.
    
    %% PREPARATION
    %The xmlList is made including all the .xml files which are directly
    %in the directory pathNII. 
    xmlList=dir(strcat(pathNII,'/*.xml'));
     
    
    %the parameter pathNII is saved as a directory for further
    %use inside the function.
    path_father=dir(pathNII);
    
    
    %Space is reserved for the information about the niifiles asuming
    %that there are the same amount of nii files than xml files.
    listFiles=cell(numel(xmlList),1);
    names=cell(numel(xmlList),1);
    
    
    %% LOOP
    
    %In this nested 'for' loops, a maximum of 4 layers of subdirectories
    %(according to the structure offered by ADNI when the files are downloaded)
    %are traced in order to find the .nii files.
    
    m=1;
    for i=1:numel(path_father)
        if(path_father(i).isdir && strcmp(path_father(i).name,'.')==0 && strcmp(path_father(i).name,'..')==0)
            path_child=dir(strcat(pathNII,'/',path_father(i).name));
            
            for j=1:numel(path_child)
                if(path_child(j).isdir && strcmp(path_child(j).name,'.')==0 && strcmp(path_child(j).name,'..')==0)
                    path_child_2=dir(strcat(pathNII,'/',path_father(i).name,'/',...
                        path_child(j).name));
                    
                    for k=1:numel(path_child_2)
                        if(path_child_2(k).isdir && strcmp(path_child_2(k).name,'.')==0 && strcmp(path_child_2(k).name,'..')==0)
                            path_child_3=dir(strcat(pathNII,'/',path_father(i).name,'/',...
                                path_child(j).name,'/',path_child_2(k).name));
                            
                            for l=1:numel(path_child_3)
                                if(path_child_3(l).isdir && strcmp(path_child_3(l).name,'.')==0 && strcmp(path_child_3(l).name,'..')==0)
                                    path_child_4=dir(strcat(pathNII,'/',path_father(i).name,'/',...
                                        path_child(j).name,'/',path_child_2(k).name,'/',path_child_3(l).name,'/*.nii'));
                                    listFiles{m}=strcat(pathNII,'/',path_father(i).name,'/',...
                                        path_child(j).name,'/',path_child_2(k).name,'/',...
                                        path_child_3(l).name,'/',path_child_4(1).name);
                                    names{m}=path_child_4(1).name([6:16,end-15:end]);
                                    m=m+1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    %end of the searchNIIFiles(pathNII) function
end
