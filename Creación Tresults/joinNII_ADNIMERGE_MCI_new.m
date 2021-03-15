function [Tresults,Tdelete,ni]=joinNII_ADNIMERGE_MCI_new

% New Tresults
addpath('./external/lme/Qdec/');
addpath('./aux_joinNII/');


%% data
Tdec=joint_AsegAparc_MCI_new;
% load('./data/ADNIMERGE_14036v_2175s.mat');
% load('./data/ADNIMERGE_201123_CSF.mat','ADNI');
load('./data/ADNIMERGE_201123.mat','ADNI');

resultsDir_new='./Tresults_new/';
resultsDir='./Tresults/';

out_name_new='Tresults_new_1844v_501s';
out_name='Tresults_1844v_501s';

%% RID & UID
numImgs=size(Tdec,1);
RID=zeros(numImgs,1);
UID=zeros(numImgs,1);
Tdec_IMAGEUID=table2array(Tdec(:,{'IMAGEUID'}));
for i=1:numImgs
    nameFiles=char(Tdec.fsid(i));
    RID(i)=str2double(nameFiles(7:10));
    IMAGEUID=nameFiles(18:end);
    if(IMAGEUID(1)=='I')
        IMAGEUID=str2double(IMAGEUID(2:end));
    elseif(IMAGEUID(1)=='_')
        IMAGEUID=str2double(IMAGEUID(3:end));
    else
        IMAGEUID=str2double(IMAGEUID);
    end
    IMAGE=Tdec_IMAGEUID(i);
    if (IMAGE-IMAGEUID)==0
        UID(i)=IMAGEUID;
    else
        printf(2, 'ERROR: Tdec_IMAGEUID: %f and File_IMAGEUID: %f\n',Tdec_IMAGEUID(i),IMAGEUID);
        error('Revise IMAGEUID in XML files');
    end
end


%% Matches
subjs=unique(RID); % RID Tdec
index_ADNI=[];
index_Tdec=[];
index_delete=[];
index_MERG=[];

for j=1:length(subjs)
    index_MERG=[index_MERG;find(ADNI.RID==subjs(j))];
end

% New ADNI table with only subjects with processed images
ADNI=ADNI(index_MERG,:);

%% Creation of Tdec_zero


% Every column must be taken separately to keep their data type
zero_1=Tdec{:,1};
zero_2=Tdec{:,2};
zero_3=Tdec{:,3};
zero_4=Tdec{:,4};
zero_5=Tdec{:,5};
zero_6=Tdec{:,6};
zero_7=Tdec{:,7};
zero_8=Tdec{:,8};
zero_9=Tdec{:,9};
zero_10=Tdec{:,10};
zero_11=Tdec{:,11};
zero_12=Tdec{:,12};
zero_13=Tdec{:,13};
zero_14=Tdec{:,14};
zero_15=Tdec{:,15};
zero_16=Tdec{:,16:end};

% NaN is written in every array
for i=1:size(ADNI,1)
    zero_1(i)=missing;
    zero_2(i)=missing;
    zero_3(i)=missing;
    zero_4(i)=missing;
    zero_5(i)=missing;
    zero_6(i)=missing;
    zero_7(i)=missing;
    zero_8(i)=missing;
    zero_9(i)=missing;
    zero_10(i)=missing;
    zero_11(i)=missing;
    zero_12(i)=missing;
    zero_13(i)=missing;
    zero_14(i)=missing;
    zero_15(i)=missing;
    for j=1:size(zero_16,2)
        zero_16(i,j)=missing;
    end
end


Variables=Tdec.Properties.VariableNames;
Tdec_zero=table(zero_1,zero_2,zero_3,zero_4,zero_5,zero_6,zero_7,...
    zero_8,zero_9,zero_10,zero_11,zero_12,zero_13,zero_14,zero_15);
zero_16=array2table(zero_16);
Tdec_zero=[Tdec_zero, zero_16];
Tdec_zero.Properties.VariableNames=Variables;

%% Tresults
aux_Tdec=[];
aux_ADNI=[];
for i=1:length(subjs)
    
    % Without baseline
    if(subjs(i)==2360)
        continue;
    end
    
    idx=find(RID==subjs(i));
    idx_MERG=find(ADNI.RID==subjs(i));
    [val,ind]=sort(Tdec.years(idx));
    
    if(val(1)>0)
        fprintf(2,'Subject %d without baseline visit.\n',subjs(i));
    end

    idx=idx(ind);
    UID_subj=UID(idx);
    UID_MERG=ADNI.IMAGEUID(idx_MERG);
    DATE_subj=Tdec.EXAMDATE(idx);
    DATE_MERG=datetime(ADNI.EXAMDATE(idx_MERG));
    DATE_MERG.Format='dd-MMM-yyyy';
    
    VISCODE_subj=Tdec.CODE(idx);
    VISCODE_MERG=ADNI.VISCODE(idx_MERG);
     
    DATE_top=DATE_MERG+calmonths(6);
    DATE_bottom=DATE_MERG-calmonths(6);
    
    for j=1:length(idx)
        bMatch=false;
        
        % Double visit in baseline
        if(UID_subj(j)==37034 || UID_subj(j)==80930)
            continue;
        end
        
        [diffUID,index_tmp]=min(abs(UID_subj(j)-UID_MERG)); 
        index_date_tmp = find(isbetween(DATE_subj(j),DATE_bottom,DATE_top));  
        index_date=0; 
        aux_CODE=0;
        
        if(size(index_date_tmp,1)>1)
            num_days=[];
            for k=1:size(index_date_tmp,1)
                num_days=[num_days;abs(daysact(DATE_subj(j),DATE_MERG(index_date_tmp(k))))];
            end
            [~,index_date]=min(num_days);
            index_date=index_date_tmp(index_date); 
            aux_CODE=VISCODE_subj(j)==VISCODE_MERG(index_date);
            
        elseif(size(index_date_tmp,1)==1)
            index_date=index_date_tmp;
            aux_CODE=VISCODE_subj(j)==VISCODE_MERG(index_date);
        end
        
        if(diffUID==0) % Same UID
            aux_Tdec=[aux_Tdec;idx(j)];
            aux_ADNI=[aux_ADNI;idx_MERG(index_tmp)];
            bMatch=true;
            
        elseif(~isempty(index_date)) % Same EXAMDATE (+- 6 months)                 
            if (aux_CODE) % Same VISCODE
                aux_Tdec=[aux_Tdec;idx(j)];
                aux_ADNI=[aux_ADNI;idx_MERG(index_date)];
                bMatch=true;
            else
                fprintf('UID: %d, RID: %d, WITH NO VISIT IN THIS INTERVAL\n',...
                    UID_subj(j),subjs(j));
                bMatch=false;
            end
        else
            fprintf('UID: %d, RID: %d, WITH NO VISIT IN THIS INTERVAL\n',...
                    UID_subj(j),subjs(j));
        end
        if(~bMatch)
            index_delete=[index_delete;idx(j)];                                   
        end
    end
end

Tdec_zero.Properties.VariableNames{'EXAMDATE'}='EXAMDATE_xml';
Tdec_zero.Properties.VariableNames{'ICV'}='ICV_xml';
Tdec_zero.Properties.VariableNames{'MMSE'}='MMSE_xml';
Tdec_zero.Properties.VariableNames{'IMAGEUID'}='IMAGEUID_xml';
Tdec_zero.Properties.VariableNames{'FAQ'}='FAQ_xml';

% ADNI.Properties.VariableNames{'EXAMDATE'}='EXAMDATE_ADNI';
% ADNI.Properties.VariableNames{'ICV'}='ICV_ADNI';
% ADNI.Properties.VariableNames{'MMSE'}='MMSE_ADNI';
% ADNI.Properties.VariableNames{'FAQ'}='FAQ_ADNI';

Tdec_zero(aux_ADNI,:)=Tdec(aux_Tdec,:);
Tresults=[ADNI,Tdec_zero];
Tdelete=Tdec(index_delete,:);

%% Convert
Tresults=getConvert(Tresults);

%% Deleting subjects with no processed visits
subjects=unique(Tresults.RID);
idx_RID_delete=[];
for i=1:size(subjects)
    index_RID=find(Tresults.RID==subjects(i));
    index_NaN=find(isnan(Tresults.years(index_RID)));
    if(size(index_NaN,1)==size(index_RID,1))
        idx_RID_delete=[idx_RID_delete;index_RID];
    end
end

Tresults(idx_RID_delete,:)=[];

%% Number of images
ni=get_ni(Tresults.years,length(unique(Tresults.RID)));

%% Save files
out_file_new=strcat(resultsDir_new,out_name_new);
save(out_file_new,'Tresults','ni');

Tresults=Tresults(isnan(Tresults.years)==0,:);

out_file=strcat(resultsDir,out_name);
save(out_file,'Tresults','ni');

%% delete
rmpath('./external/lme/Qdec/');
rmpath('./aux_joinNII/');

end



function ni = get_ni(time_visit,numIDs)
   
    %% Calculating number of images
    
    % Initialization
    time_visit=time_visit(~isnan(time_visit));
    baseline=find(time_visit==0);
    numScans=length(time_visit);
    
    % Calculating ni
    ni=baseline([2:end,end])-baseline;
    ni(end)=numScans-baseline(end)+1;
    
    %% Checking errors
    if(length(ni)~=numIDs)
        warning('Error calculating ni: There are more scans in baseline than subjects');
    end
    if(sum(ni)~=numScans)
        warning('Error calculating ni');
    end    
end