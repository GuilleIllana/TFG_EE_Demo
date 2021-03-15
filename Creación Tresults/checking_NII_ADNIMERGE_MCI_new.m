function checking_NII_ADNIMERGE_MCI_new(onlyMRI)
clc; 
%% Read Tresults
%[Tresults,~,~]=joinNII_ADNIMERGE_MCI;

load('./Tresults_new/Tresults_new_1843v_500s', 'Tresults');

onlyMRI=false;

if(onlyMRI==true)
    Tresults=Tresults(~isnan(Tresults.years),:);
end

clc;

%% All visits from a subject
RID=Tresults.RID;
RID_subjs=unique(RID);

err_images=[];%new code
for i=1:length(RID_subjs)
    %% Coherence Tmarkers
    index=find(Tresults.RID==RID_subjs(i));
    if(issorted(index)==0)
        fprintf('No sorted visits from RID %d\n',RID_subjs(i));
    end
    follow_visit=index(2:end)-index(1:end-1);
    mask_follow_visit=follow_visit~=1;
    if(sum(mask_follow_visit)>0)
        fprintf('There are jumps among visits from RID %d\n',RID_subjs(i));
    end
    
    if(onlyMRI==true)
        years=Tresults.years(index);
        if(issorted(years)==0)
            fprintf(2,'No sorted years from RID %d\n',RID_subjs(i));
        end
        if(years(1)>0)
            fprintf('First visit is not baseline from RID %d\n',RID_subjs(i));
            err_images=[err_images;index];% new code
        end
    end
    
    %% ADNIMERGE matching
    month=Tresults.M(index);
    
    % ADNI month order: problem relation NII+XML
    if(issorted(month)==0)
        fprintf(2,'No sorted years from RID %d\n',RID_subjs(i));
    end
    
    % visit time between abs(Tdec.year-ADNI.M)
    if(onlyMRI==true)
        years_ADNI=month/12;
        years_ADNI=years_ADNI-years_ADNI(1);
        diff_years=abs(years-years_ADNI);
        mask_diff_years=diff_years>1;
        if(sum(mask_diff_years)>0)
            fprintf('Different visits %d from RID %d\n',...
                sum(mask_diff_years),RID_subjs(i));
        end
    end
    
    % DiffExamdate
    if(onlyMRI==true)
    
        diffExamDate_subj=abs(Tresults.EXAMDATE_xml(index)-Tresults.EXAMDATE(index));
        mask_diffExamDate=diffExamDate_subj>200;

        if(sum(mask_diffExamDate)>0)
            fprintf('Different EXAMDATE %d from RID %d\n',...
                sum(mask_diffExamDate),RID_subjs(i));
        end
    
        % diffIMAGEUID
        diffUID_subj=abs(Tresults.IMAGEUID(index)-fsid2IMAGEUID(Tresults.fsid(index)));
        mask_diffUID=diffUID_subj>100000;  
        if(sum(mask_diffUID)>0)
            fprintf('Different IMAGEUID %d from RID %d\n',...
                sum(mask_diffUID),RID_subjs(i));
        end
    
        % NEW CODE

        mask_diffVISCODE=Tresults.CODE(index)~=Tresults.VISCODE(index);
        if(sum(mask_diffVISCODE)>0)
            fprintf('Different VISCODE from RID %d\n',...
                RID_subjs(i));
            idx_error=find(mask_diffVISCODE);
            for j=1:size(idx_error,1)
                fprintf('RID: %d ADNI: %s vs xml: %s\n',...
                RID_subjs(i),Tresults.VISCODE(index(idx_error(j))),...
                Tresults.CODE(index(idx_error(j))));
            end
        end
    end
   
       
end

end


function UID=fsid2IMAGEUID(stringUID)
UID=zeros(length(stringUID),1);
for i=1:length(stringUID)
   image=char(stringUID(i));
   if(image(end-5)=='I')
       UID(i)=str2double(image(end-4:end));
   else
       UID(i)=str2double(image(end-5:end));
   end
end

end
