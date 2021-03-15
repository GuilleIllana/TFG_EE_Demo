function fix_XML_MCI 
clc;
%% IMAGEUID
% xmlPath='./106v_44s/xml/';
% xmlTmp='./106v_44s/xml_tmp/';
% xmlResult='./106v_44s/xml_2/';

% xmlPath='./413v_122s/xml/';
% xmlTmp='./413v_122s/xml_tmp/';
% xmlResult='./413v_122s/xml_2/';

% xmlPath='./209v_42s/xml/';
% xmlTmp='./209v_42s/xml_tmp/';
% xmlResult='./209v_42s/xml_2/';

% xmlPath='./490v/xml/';
% xmlTmp='./490v/xml_tmp/';
% xmlResult='./490v/xml_2/';
% xmlTmp2='./490v/xml_tmp2/';

% xmlPath='./343v/xml/';
% xmlTmp='./343v/xml_tmp/';
% xmlResult='./343v/xml_2/';
% xmlTmp2='./343v/xml_tmp2/';

xmlPath='./157v/xml/';
xmlTmp='./157v/xml_tmp/';
xmlResult='./157v/xml_2/';
xmlTmp2='./157v/xml_tmp2/';
%% NII
% niiPath ='./nii/';
% listNII=dir(strcat(niiPath,'*.nii'));

%load('./209v_42s/listNII_209v_42s','listNII');
%load('./490v/ListNII_lin_490v','listNII');
%load('./343v/ListNIIywu_ESKILSEN_343v','listNII');
load('./157v/ListNIIJaime_157v','listNII');

% for i = 1 : numel(listNII)
%     listNII(i).name = strcat(listNII(i).name, '.nii.gz');
% end

%% Change names
% A list of all xml files is generated
listFichXML = dir(strcat(xmlPath,'*.xml'));
numXML = numel(listFichXML);

UID_orig=[];
UID_dest=[];

for i=1:numXML
   IMAGEUID_filename=char(extractBetween(listFichXML(i).name,'_I','.'));
   IMAGEUID_XML=readXML_IMAGEUID(strcat(xmlPath,listFichXML(i).name));

   if(strcmp(IMAGEUID_filename,IMAGEUID_XML))
       orig=strcat(xmlPath,listFichXML(i).name);
       
       command=sprintf('copy %s %s',orig,xmlResult);
       system(command);
   else
       fprintf('%s -- %s \n',IMAGEUID_filename,IMAGEUID_XML);
       UID_orig=[UID_orig;listFichXML(i).name,32];
       orig=strcat(xmlPath,listFichXML(i).name);
       if(length(IMAGEUID_XML)==6 && length(IMAGEUID_filename)==6)
         dest=strcat(xmlTmp,listFichXML(i).name(1:22),IMAGEUID_XML,'.xml');
         UID_dest=[UID_dest;strcat(listFichXML(i).name(1:22),IMAGEUID_XML,'.xml')];
       elseif(length(IMAGEUID_XML)==6 && length(IMAGEUID_filename)==5)
         dest=strcat(xmlTmp,listFichXML(i).name(1:20),'_I',IMAGEUID_XML,'.xml');
         UID_dest=[UID_dest;strcat(listFichXML(i).name(1:20),'_I',IMAGEUID_XML,'.xml')];
       elseif(length(IMAGEUID_XML)==5 && length(IMAGEUID_filename)==6)
         dest=strcat(xmlTmp,listFichXML(i).name(1:20),'__I',IMAGEUID_XML,'.xml');
         UID_dest=[UID_dest;strcat(listFichXML(i).name(1:20),'__I',IMAGEUID_XML,'.xml')];
       elseif(length(IMAGEUID_XML)==5 && length(IMAGEUID_filename)==5)
         %without debbuging
         dest=strcat(xmlTmp,listFichXML(i).name(1:23),IMAGEUID_XML,'.xml');
         UID_dest=[UID_dest;strcat(listFichXML(i).name(1:23),IMAGEUID_XML,'.xml')];
       end
       
       command=sprintf('cp %s %s',orig,dest); % Linux command 
       % command=sprintf('copy %s %s',orig,dest); % Windows command
       
       disp(command);
       system(command);
   end

end

%% code_v
UID_orig_s=string(UID_orig);
UID_orig_s=extractBetween(UID_orig_s,'_I','.');
UID_dest_s=string(UID_dest);
UID_dest_s=extractBetween(UID_dest_s,'_I','.');

for i=1:size(UID_dest,1)
    index=find(strcmp(UID_orig_s,UID_dest_s(i)));
    if(~strcmp(UID_orig(index,1:15),UID_dest(i,1:15)))
        fprintf(2,'Error: changes between XMLs must be the same subject: orig %s, dest %s.\n',...
            UID_orig(index,1:15),UID_dest(i,1:15));
    else
        code_v=UID_orig(index,:);
        new_IMAGEUID=UID_dest(i,:);

        if(length(char(UID_dest_s(i)))==6)
            code_v=code_v(17:20);   
            new_IMAGEUID(17:20)=code_v;
        elseif(length(char(UID_dest_s(i)))==5)
            code_v=code_v(17:21);   
            new_IMAGEUID(17:21)=code_v;
        end

        orig=strcat(xmlTmp,UID_dest(i,:));
        dest=strcat(xmlResult,new_IMAGEUID);
        %command=sprintf('cp %s %s',orig,dest);
        command=sprintf('copy %s %s',orig,dest);
        disp(command);
        system(command);
    end
     
end


%% Checking NII
clc;
nii_names=char(listNII(:).name);
nii_names=extractBefore(string(nii_names),'.');
xml_fault = [];
nii_fault = [];
listFichXML = dir(strcat(xmlResult,'*.xml'));
xml_names=char(listFichXML(:).name);
xml_names_NII=extractBetween(string(xml_names),'ADNI_','.');

for i=1:length(xml_names)
    index=find(strcmp(nii_names,xml_names_NII(i)));
    if(isempty(index))
        orig=strcat(xmlResult,xml_names(i,:));
        dest=strcat(xmlTmp2,xml_names(i,:));
        command=sprintf('move %s %s',orig,dest);
        disp(command);
        system(command);
    end
end

listFichXML = dir(strcat(xmlResult,'*.xml'));
xml_names=char(listFichXML(:).name);
xml_names=extractBetween(string(xml_names),'ADNI_','.');

for i=1:length(xml_names)
    index=find(strcmp(nii_names,xml_names(i))); 
    if(length(index)~=1)
        nii_fault = [nii_fault; xml_names(i)];
        fprintf(2,'%s xml without nii file\n',xml_names(i));
    end
end

if(numel(xml_names)~=numel(nii_names))
    fprintf(2,'The number of files between nii and xml are differents.\n');
end

for i=1:length(nii_names)
    index=find(strcmp(xml_names,nii_names(i)));
    if(length(index)~=1)
        xml_fault = [xml_fault; nii_names(i)];
        fprintf(2,'%s nii without xml file\n',nii_names(i));
    end
end
if  ~isempty(nii_fault)
    save('./157v/xml_without_nii.mat', 'nii_fault');
elseif ~isempty(xml_fault)
    save('./157v/nii_without_xml.mat', 'xml_fault');
end

end




function IMAGEUID=readXML_IMAGEUID(filename)
% This function is charged of finding the different parameters in the xml
% file, when possible. Default value for all of them is -1, and only if a
% valid value is found it will be changed.

%% Reading the xml file

theStruct = xml2struct(filename);

% These parts of the struct are repeatedly used over the function.
data1 = theStruct.idaxs.project.subject;

%% Guaranteed parameters
% These parameters are always expected to be found, and so they're not
% checked.

%% sex, id, diagnose, age
IMAGEUID = data1.study.series.seriesLevelMeta.derivedProduct.imageUID.Text;
%imageUID=str2double(data1.study.series.seriesLevelMeta.derivedProduct.imageUID.Text);
end