function [convert,time_conver_cens] = convertTime_MCI(Tadni,group)

ID=Tadni.PTID;
subjects=unique(ID);


convert=false(size(Tadni,1),1);
time_conver_cens=zeros(size(Tadni,1),1);


for i=1:length(subjects)
    index=find(ID==subjects(i));
    time_patient=convert_time(Tadni.VISCODE(index));
    [time_patient,index_time]=sort(time_patient);
    diagn_patient=Tadni.DX(index);
    %new criteria
    diagn_patient=diagn_patient(index_time);
    labels_patient=unique(diagn_patient);
    if((length(labels_patient)==1 && diagn_patient(end)~=group(2)) || diagn_patient(end)~=group(2))%stable
        time_conver_cens(index)=time_patient(end);
    else
        for j=1:length(index)
            if(diagn_patient(j)==group(2)) %dementia
                convert(index)=true;
                time_conver_cens(index)=time_patient(j);
                break;
            end
        end
    end
end

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