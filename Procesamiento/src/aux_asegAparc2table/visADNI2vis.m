function [Tresults]=visADNI2vis(Tresults,MCItoAD,preAD)

load('./Data/ADNI_clinicalDemogr','ADNIMERGE');
viscode_set=unique(ADNIMERGE.VISCODE);
group_DX=unique(ADNIMERGE.DX);

mask_bls_middleTime= (Tresults.years==0) & (Tresults.VISCODE~=viscode_set(1));
fsidbase=string(Tresults.fsidbase);
fsid_bls_middleTime=fsidbase(mask_bls_middleTime);
VISCODE_AUX=Tresults.VISCODE;
for i=1:numel(fsid_bls_middleTime)
    index_middle=find(strcmp(fsidbase,fsid_bls_middleTime(i)));
    time_visits=zeros(length(index_middle),1);
    for j=1:length(index_middle)
        time_visits(j)= convert_time(Tresults.VISCODE(index_middle(j)));
    end
    
    code_visits=discretize_time(time_visits-min(time_visits),viscode_set);
    VISCODE_AUX(index_middle)=code_visits;
    
end

Tresults.Properties.VariableNames{'VISCODE'}='VISCODE_ADNI';
Tresults=[Tresults(:,(1:5)),table(VISCODE_AUX,'VariableNames',{'VISCODE'}),...
        Tresults(:,(6:end))];
    
%% Convert and censoring times
if(MCItoAD)
    [convert,time_conver_cens] = convertTime_MCI(Tresults,group_DX);
elseif(preAD)
    [convert,time_conver_cens] = convertTime_NC(Tresults,group_DX);

end

Tresults=[Tresults,table(convert,time_conver_cens,'VariableNames',...
    {'Convert','ConvertTime'})];
   
end


function time_patient=convert_time(visits)
time_patient=zeros(length(visits),1);
for i=1:length(visits)
   %time_patient(i)=visit2double(visits(i),code); 
   time_patient(i)=visit2num(visits(i)); 
   
end

end

function visit=visit2num(VISCODE)
vis=char(VISCODE);
if(vis(1)=='b')
    visit=0;
else
    visit=str2double(vis(2:end));
end

end
