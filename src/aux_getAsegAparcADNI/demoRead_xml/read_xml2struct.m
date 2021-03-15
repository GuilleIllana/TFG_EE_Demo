function [sex,Age,MMSE,GDS,CDR,FAQ,diagnose,ID,APOE_A1,APOE_A2,imageUID,EXAMDATE]=read_xml2struct(filename)
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
sex = data1.subjectSex.Text;
ID = str2double(data1.study.series.seriesLevelMeta.derivedProduct.imageUID.Text);
diagnose= data1.subjectInfo{1,1}.Text;
Age=str2double(data1.study.subjectAge.Text);
EXAMDATE=data1.study.series.dateAcquired.Text;
imageUID=str2double(data1.study.series.seriesLevelMeta.derivedProduct.imageUID.Text);
%% Non guaranteed parameters
% These parameters are not always found. In this case, with a for loop the
% element matching the name of the parameter is found. I that is the case,
% the value will be changed from its default (-1).

%% MMSE, GDS, CDR
MMSE=-1;
GDS=-1;
CDR=-1;
FAQ=-1;
for i=1:numel(data1.visit.assessment)
    % make sure the field is not empty
    Attr = data1.visit.assessment{1,i}.Attributes.name;
    if isempty(Attr)
        continue;
    end
    % if the field is not empty, check for the value (name)
    if strcmp(Attr , 'MMSE')
        MMSE=str2double(data1.visit.assessment{1,i}.component.assessmentScore.Text);
    elseif strcmp(Attr , 'GDSCALE')
        GDS=str2double(data1.visit.assessment{1,i}.component.assessmentScore.Text);
    elseif strcmp(Attr , 'CDR')
        CDR=str2double(data1.visit.assessment{1,i}.component.assessmentScore.Text);
    elseif strcmp(Attr , 'Functional Assessment Questionnaire')
        FAQ=str2double(data1.visit.assessment{1,i}.component.assessmentScore.Text);
    end    
end

%% APOE_A1, APOE_A2
APOE_A1=-1;
APOE_A2=-1;
for i=1:numel(data1.subjectInfo)
    % make sure the field is not empty
    Attr = data1.subjectInfo{1,i}.Attributes.item;
    if isempty(Attr)
     continue;
    end

    % if the field is not empty, check for the value (name)
    if strcmp(Attr, 'APOE A1')
        APOE_A1 = str2double(data1.subjectInfo{1,i}.Text);
    elseif strcmp(Attr, 'APOE A2')
         APOE_A2 = str2double(data1.subjectInfo{1,i}.Text);
    end    
end
end
