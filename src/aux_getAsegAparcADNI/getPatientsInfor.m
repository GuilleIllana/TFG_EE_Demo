function strPatients=getPatientsInfor(path_subj,xmlPath)
%This is the default function to take info from xml files.   
% First all subjects directories are stored in listImgs and then . and
% .. are removed from the list.
listImgs = struct2table(dir(strcat(path_subj)));
mask_dir=listImgs.isdir==1;
listImgs=listImgs(mask_dir,:);
name_nii=char(listImgs.name);
first_name_nii=name_nii(:,1);
maks_nii= first_name_nii>='0' & first_name_nii<='9';
listImgs=listImgs(maks_nii,:);
    
     
% A list of all xml files is generated
listFichXML = dir(strcat(xmlPath,'*.xml'));
numImgs = size(listImgs,1);
numXMLs = numel(listFichXML);

 if(numImgs ~= numXMLs)
     fprintf('Numbers of images and XML files are differents');
     return;
 end
     
    
strPatients(1,numImgs)=struct('fsid',[],'years',[],'Age',[],'sex',[],'mmse',[],...
    'gds',[],'cdr',[],'FAQ',[],'diagnose',[],'APOE_A1',[],'APOE_A2',[],...
    'examdate',[], 'viscode', []);
    
    
% In the main loop a match between the xml file and the visit name is
% searched in order to asign the values of the XML to the strPatients
% struct.
for i=1:numImgs
     name_nii=char(listImgs.name(i));
     UID_nii=extractBetween(name_nii, '_I', '.');
    if(strcmp(name_nii(1:23),listFichXML(i).name(6:6+22)))

       [strPatients(i).sex,strPatients(i).Age,strPatients(i).mmse,...
            strPatients(i).gds,strPatients(i).cdr,strPatients(i).FAQ,...
            strPatients(i).diagnose,strPatients(i).fsid,strPatients(i).APOE_A1,...
            strPatients(i).APOE_A2,strPatients(i).examdate,strPatients(i).viscode]=...
            read_xml2struct(strcat(xmlPath,listFichXML(i).name));
        
        UID_xml=extractBetween(listFichXML(i).name, '_I', '.xml');
        
         if(strcmp(UID_nii,UID_xml)~=1)
              fprintf('UID Nii: %s, Xml: %s are differents\n', UID_nii,UID_xml);
         end
        
       
        UID_num=str2double(UID_xml); 
             
        
        if((strPatients(i).fsid-UID_num)~=0)
             fprintf('UID XML: %d, Xml: %d are differents\n',UID_num,strPatients(i).fsid);
        else
            fprintf('%s %s %.3f %s %.1f %d %.1f %d %d %d \n',...
            listFichXML(i).name(6:end-4),...
            strPatients(i).sex,...
            strPatients(i).Age,...
            strPatients(i).diagnose,...
            strPatients(i).mmse,...
            strPatients(i).gds,...
            strPatients(i).cdr,...
            strPatients(i).FAQ,...
            strPatients(i).APOE_A1,...
            strPatients(i).APOE_A2);
            
            strPatients(i).fsid=listFichXML(i).name(6:end-4);       
                              
        end
    else
        fprintf('Nii: %s, Xml: %s are differents\n', name_nii(1:23),listFichXML(i).name(6:6+22));
    end
end

end