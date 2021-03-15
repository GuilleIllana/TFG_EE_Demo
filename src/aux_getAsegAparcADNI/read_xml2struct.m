function [sex,Age,MMSE,GDS,CDR,FAQ,diagnose,ID,APOE_A1,APOE_A2,CODE,EXAMDATE]=read_xml2struct(filename)
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
Age=str2double(data1.study.subjectAge.Text);
EXAMDATE=data1.study.series.dateAcquired.Text;
fsid_1 = data1.subjectIdentifier.Text;
fsid_2 = data1.study.series.seriesIdentifier.Text(3:end);
fsid = strcat(fsid_1,'_', fsid_2,'_I',num2str(ID));
%VISCODE = data1.visit.visitIdentifier.Text;
diagnose= data1.researchGroup.Text;
%diagnose= data1.subjectInfo{1,1}.Text;
if strcmp(diagnose,'Patient')
    for i=1:numel(data1.subjectInfo)
        % make sure the field is not empty
        Attr = data1.subjectInfo{1,i}.Attributes.item;
        if isempty(Attr)
         continue;
        end
        % if the field is not empty, check for the value (name)
        if strcmp(Attr, 'DX Group')
            diagnose = data1.subjectInfo{1,i}.Text;
        end
    end
end
%imageUID=str2double(data1.study.series.seriesLevelMeta.derivedProduct.imageUID.Text);
%% Non guaranteed parameters
% These parameters are not always found. In this case, with a for loop the
% element matching the name of the parameter is found. I that is the case,
% the value will be changed from its default (-1).

%% MMSE, GDS, CDR, FAQ

MMSE=-1;
GDS=-1;
CDR=-1;
FAQ=-1;
if length(fieldnames(data1.visit))==2
    for i=1:numel(data1.visit.assessment)
        % make sure the field is not empty
        if iscell(data1.visit.assessment)
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
        else 
            Attr = data1.visit.assessment(1,i).Attributes.name;
            if isempty(Attr)
                continue;
            end
            % if the field is not empty, check for the value (name)
            if strcmp(Attr , 'MMSE')
                MMSE=str2double(data1.visit.assessment(1,i).component.assessmentScore.Text);
            elseif strcmp(Attr , 'GDSCALE')
                GDS=str2double(data1.visit.assessment(1,i).component.assessmentScore.Text);
            elseif strcmp(Attr , 'CDR')
                CDR=str2double(data1.visit.assessment(1,i).component.assessmentScore.Text);
            elseif strcmp(Attr , 'Functional Assessment Questionnaire')
                FAQ=str2double(data1.visit.assessment(1,i).component.assessmentScore.Text);
            end
        end
    end
end
%% VISCODE
CODE=string(data1.visit.visitIdentifier.Text);
for i=1:length(CODE)  
    if ID==296808
        1;
    end
    if strcmp(CODE,'ADNI2 Screening MRI-New Pt')
        CODE(i)='bl';
    elseif strcmp(CODE,'ADNI Screening')||strcmp(CODE,'ADNI1 Screening')
        CODE(i)='bl';
    elseif strcmp(CODE,'ADNI2 Month 3 MRI-New Pt')
        CODE(i)='m03';    
    elseif strcmp(CODE,'ADNI2 Month 6-New Pt') || strcmp(CODE,'ADNI1/GO Month 6')
        CODE(i)='m06';
    elseif strcmp(CODE,'ADNI2 Year 1 Visit') || strcmp(CODE,'ADNI1/GO Month 12')
        CODE(i)='m12';
    elseif strcmp(CODE,'ADNI2 Year 2 Visit') || strcmp(CODE,'ADNI1/GO Month 24')
        CODE(i)='m24';
    elseif strcmp(CODE,'ADNI2 Year 3 Visit') || strcmp(CODE,'ADNI1/GO Month 36')
        CODE(i)='m36';
    elseif strcmp(CODE,'ADNI2 Year 4 Visit') || strcmp(CODE,'ADNI1/GO Month 48')
        CODE(i)='m48';
    elseif strcmp(CODE,'ADNIGO Month 60')|| strcmp(CODE,'ADNI2 Initial Visit-Cont Pt')
        CODE(i)='m60';
    elseif strcmp(CODE,'ADNIGO Month 72')
        CODE(i)='m72';
    elseif strcmp(CODE,'No Visit Defined')
        CODE(i)='No_visit_defined';
    else
        CODE(i)='NaN';
    end
end
%% APOE_A1, APOE_A2

APOE_A1=-1;
APOE_A2=-1;
try
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
catch
     warning('APOE field not found');
end

end