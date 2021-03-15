function [Tresults,ni,corr_QC,vol_QC]=addTresults_QC

%% data
% load('./data/Tresults_T1DTI_274v_86s', 'Tresults','ni');
% load('./data/QC_long_T1DTI_274v_86s','corr_QC','vol_QC');

load('./data/Tresults_T1DTI_272v_86s', 'Tresults','ni');
load('./data/QC_long_T1DTI_272v_86s','corr_QC','vol_QC');

Taux=Tresults;
ni_aux=ni;
corr_QC_aux=corr_QC;
vol_QC_aux=vol_QC;

load('./data/Tresults_T1DTI_110v_31s', 'Tresults','ni');
load('./data/QC_long_T1DTI_110v_31s','corr_QC','vol_QC');

%% Check unique subjects
ID_1=string(unique(Taux.fsidbase));
ID_2=string(unique(Tresults.fsidbase));
bExist=false;
for i=1:length(ID_1)
    index=find(strcmp(ID_2,ID_1(i)));
    if(isempty(index)==0)
        bExist=true;
        fprintf('%s in table 1 %d and table 2 %d\n',ID_1(i),i,index);
    end
end

if(bExist)
    Tresults=[];
    ni=[];
    corr_QC=[];
    vol_QC=[];
else
    Tresults=[Taux;Tresults];
    ni=[ni_aux;ni];
    corr_QC=[corr_QC_aux;corr_QC];
    vol_QC=[vol_QC_aux;vol_QC];
end

end