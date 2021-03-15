function samples_by_visits

% load('../Generate_Tresults/Data_413v_122s_sMCI_pMCI/Tresults_413v_122s.mat', 'Tresults');
% load('../Generate_Tresults/Data_106v_44s_AD/Tresults_106v_44s_AD.mat', 'Tresults');
load('./data/2021/Tresults_413v_122s.mat', 'Tresults');
viscode_num=zeros(size(Tresults,1),1);
for i=1:size(Tresults,1)
    viscode_num(i)=visit2num(Tresults.VISCODE(i));    
end

%% Not sure about this
Convert=zeros(size(Tresults,1),1);
Tresults=addvars(Tresults,Convert);
type_visit=unique(viscode_num);
for i=1:length(type_visit)
    fprintf('Visit %d: %d (sMCI) %d (pMCI)\n',type_visit(i),...
        sum(viscode_num==type_visit(i) & Tresults.Convert==0),...
        sum(viscode_num==type_visit(i) & Tresults.Convert==1));
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

