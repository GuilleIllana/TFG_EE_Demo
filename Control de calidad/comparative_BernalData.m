 function comparative_BernalData
addpath('./external/lme/univariate'); %lme_lowessPlot
close all;

%% data

%MCItoAD T1
% load('./data/Tresults_MCItoAD_1330v', 'Tresults');


% T1+DTI idelacalle
% load('./data/Tresults_T1DTI_110v_31s', 'Tresults');

% T1+DTI Yuzhi
% load('./data/Tresults_T1DTI_274v_86s', 'Tresults');
% load('./data/Tresults_T1DTI_272v_86s', 'Tresults');


% T1+DTI Yuzhi+idelacalle
% load('./data/Tresults_T1DTI_384v_117s', 'Tresults');
load('./data/Tresults_1843v_500s.mat', 'Tresults');
load('./data/ADNI791_Hipp_and_Entorh.mat','X_Hipp','Y','group','ni');

sMCI_check=true;
pMCI_check=true;
AD_check=true;

%% Checking NHV and ECT in relation to Bernal data
NHV_all=(Y(:,1)+Y(:,2))./Y(:,3)*1e3;
ECT_all=(Y(:,4)+Y(:,5))/2;
group_all=group;

mask_MCI_Bernal=(group==2) | (group==3) | (group==4);

NHV=NHV_all(mask_MCI_Bernal);
ECT=ECT_all(mask_MCI_Bernal);
group=group_all(mask_MCI_Bernal);
time_BS_Bernal=X_Hipp(mask_MCI_Bernal,2);

NHV_Check =(Tresults.LHippVol+Tresults.RHippVol)./Tresults.ICV_xml*1e3;
ECT_Check =(Tresults.L_ECT+Tresults.R_ECT)/2;

gr_check=double(Tresults.Convert);

figure(1);
subplot(1,2,1);lme_lowessPlot([Tresults.years;time_BS_Bernal],[NHV_Check;NHV],...
    .95,[gr_check;group]);
title('Smoothed mean measurement trajectories');
ylabel('Normalized hippocampal volume');
xlabel('Time from baseline (in years)');
legend('sMCI_{our}','pMCI_{our}','AD_{our}','pMCI_{Bernal}','sMCI_{Bernal}', 'AD_{Bernal}');

subplot(1,2,2);lme_lowessPlot([Tresults.years;time_BS_Bernal],[ECT_Check;ECT],...
    .8,[gr_check;group]);
title('Smoothed mean measurement trajectories');
ylabel('ECT [mm]');
xlabel('Time from baseline (in years)');
legend('sMCI_{our}','pMCI_{our}','AD_{our}','pMCI_{Bernal}','sMCI_{Bernal}', 'AD_{Bernal}');


%% Testing atrophy
mask_MCI_Bernal= (group_all==3); % sMCI

time_BS_Bernal=X_Hipp(mask_MCI_Bernal,2);
ni_Bernal=get_ni(time_BS_Bernal,[]);
BlAge=X_Hipp(mask_MCI_Bernal,12);
atrophy_Bernal_NHV_sMCI=getAtrophy([time_BS_Bernal,BlAge],ni_Bernal,...
    NHV_all(mask_MCI_Bernal));
atrophy_Bernal_ECT_sMCI=getAtrophy([time_BS_Bernal,BlAge],ni_Bernal,...
    ECT_all(mask_MCI_Bernal));

%sMCI check
if(sMCI_check)
    mask_MCI_Check= gr_check==0; 
    time_BS_Check=Tresults.years(mask_MCI_Check);
    ni_Check=get_ni(time_BS_Check,[]);
    BlAge=Tresults.Age(mask_MCI_Check)-time_BS_Check;
    atrophy_Check_NHV_sMCI=getAtrophy([time_BS_Check,BlAge],ni_Check,...
        NHV_Check(mask_MCI_Check));
    atrophy_Check_ECT_sMCI=getAtrophy([time_BS_Check,BlAge],ni_Check,...
        ECT_Check(mask_MCI_Check));
end

%pMCI Bernal
mask_MCI_Bernal= (group_all==2);

time_BS_Bernal=X_Hipp(mask_MCI_Bernal,2);
ni_Bernal=get_ni(time_BS_Bernal,[]);
ni_Bernal(end)=[];
BlAge=X_Hipp(mask_MCI_Bernal,12);
atrophy_Bernal_NHV_pMCI=getAtrophy([time_BS_Bernal,BlAge],ni_Bernal,...
    NHV_all(mask_MCI_Bernal));
atrophy_Bernal_ECT_pMCI=getAtrophy([time_BS_Bernal,BlAge],ni_Bernal,...
    ECT_all(mask_MCI_Bernal));

%pMCI check
if(pMCI_check)
    mask_MCI_Check= gr_check==1; 
    time_BS_Check=Tresults.years(mask_MCI_Check);
    ni_Check=get_ni(time_BS_Check,[]);
    BlAge=Tresults.Age(mask_MCI_Check)-time_BS_Check;
    atrophy_Check_NHV_pMCI=getAtrophy([time_BS_Check,BlAge],ni_Check,...
        NHV_Check(mask_MCI_Check));
    atrophy_Check_ECT_pMCI=getAtrophy([time_BS_Check,BlAge],ni_Check,...
        ECT_Check(mask_MCI_Check));
end


clc;
fprintf('NHV\n');
fprintf('Baseline Bernal NHV: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
    mean(atrophy_Bernal_NHV_sMCI{1}),std(atrophy_Bernal_NHV_sMCI{1}),...
    mean(atrophy_Bernal_NHV_pMCI{1}),std(atrophy_Bernal_NHV_pMCI{1}));
if(sMCI_check && pMCI_check)
    fprintf('Baseline Check  NHV: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_NHV_sMCI{1}),std(atrophy_Check_NHV_sMCI{1}),...
        mean(atrophy_Check_NHV_pMCI{1}),std(atrophy_Check_NHV_pMCI{1}));
elseif(sMCI_check)
    fprintf('Baseline Check  NHV:  %.2f %.2f(sMCI)    (pMCI)\n',...
        mean(atrophy_Check_NHV_sMCI{1}),std(atrophy_Check_NHV_sMCI{1}));
else
    fprintf('Baseline Check  NHV:  (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_NHV_pMCI{1}),std(atrophy_Check_NHV_pMCI{1}));
end

fprintf('Atrophy  Bernal NHV: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
    mean(atrophy_Bernal_NHV_sMCI{2}),std(atrophy_Bernal_NHV_sMCI{2}),...
    mean(atrophy_Bernal_NHV_pMCI{2}),std(atrophy_Bernal_NHV_pMCI{2}));
if(sMCI_check && pMCI_check)
    fprintf('Atrophy  Check  NHV: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_NHV_sMCI{2}),std(atrophy_Check_NHV_sMCI{2}),...
        mean(atrophy_Check_NHV_pMCI{2}),std(atrophy_Check_NHV_pMCI{2}));
elseif(sMCI_check)
    fprintf('Atrophy Check  NHV:  %.2f %.2f(sMCI)    (pMCI)\n',...
        mean(atrophy_Check_NHV_sMCI{2}),std(atrophy_Check_NHV_sMCI{2}));
else
    fprintf('Atrophy  Check  NHV:  (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_NHV_pMCI{2}),std(atrophy_Check_NHV_pMCI{2}));
end

fprintf('ECT\n');
fprintf('Baseline Bernal ECT: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
    mean(atrophy_Bernal_ECT_sMCI{1}),std(atrophy_Bernal_ECT_sMCI{1}),...
    mean(atrophy_Bernal_ECT_pMCI{1}),std(atrophy_Bernal_ECT_pMCI{1}));
if(sMCI_check && pMCI_check)
    fprintf('Baseline Check  ECT: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_ECT_sMCI{1}),std(atrophy_Check_ECT_sMCI{1}),...
        mean(atrophy_Check_ECT_pMCI{1}),std(atrophy_Check_ECT_pMCI{1}));
elseif(sMCI_check)
    fprintf('Baseline Check  ECT:  %.2f %.2f(sMCI)    (pMCI)\n',...
        mean(atrophy_Check_ECT_sMCI{1}),std(atrophy_Check_ECT_sMCI{1}));    
else
    fprintf('Baseline Check  ECT:  (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_ECT_pMCI{1}),std(atrophy_Check_ECT_pMCI{1}));
end

fprintf('Atrophy  Bernal ECT: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
    mean(atrophy_Bernal_ECT_sMCI{2}),std(atrophy_Bernal_ECT_sMCI{2}),...
    mean(atrophy_Bernal_ECT_pMCI{2}),std(atrophy_Bernal_ECT_pMCI{2}));
if(sMCI_check && pMCI_check)
    fprintf('Atrophy  Check  ECT: %.2f %.2f (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_ECT_sMCI{2}),std(atrophy_Check_ECT_sMCI{2}),...
        mean(atrophy_Check_ECT_pMCI{2}),std(atrophy_Check_ECT_pMCI{2}));
elseif(sMCI_check)
    fprintf('Atrophy Check  ECT:  %.2f %.2f(sMCI)    (pMCI)\n',...
        mean(atrophy_Check_ECT_sMCI{2}),std(atrophy_Check_ECT_sMCI{2}));    
else
    fprintf('Atrophy  Check  ECT:  (sMCI) %.2f %.2f(pMCI)\n',...
        mean(atrophy_Check_ECT_pMCI{2}),std(atrophy_Check_ECT_pMCI{2}));
end


figure(2);
if(sMCI_check)
    subplot(2,2,1);histogram(atrophy_Bernal_NHV_sMCI{1});hold on;
    histogram(atrophy_Check_NHV_sMCI{1});hold off;
    title('Baseline NHV sMCI');
    subplot(2,2,3);histogram(atrophy_Bernal_NHV_sMCI{2});hold on;
    histogram(atrophy_Check_NHV_sMCI{2});hold off;
    title('Atrophy NHV sMCI');
   
end

if(pMCI_check)
    subplot(2,2,2);histogram(atrophy_Bernal_NHV_pMCI{1});hold on;
    histogram(atrophy_Check_NHV_pMCI{1});hold off;
    title('Baseline NHV pMCI');

    subplot(2,2,4);histogram(atrophy_Bernal_NHV_pMCI{2});hold on;
    histogram(atrophy_Check_NHV_pMCI{2});hold off;
    title('Atrophy NHV pMCI');
end

figure(3);
if(sMCI_check)

    subplot(2,2,1);histogram(atrophy_Bernal_ECT_sMCI{1});hold on;
    histogram(atrophy_Check_ECT_sMCI{1});hold off;
    title('Baseline ECT sMCI');

    subplot(2,2,3);histogram(atrophy_Bernal_ECT_sMCI{2});hold on;
    histogram(atrophy_Check_ECT_sMCI{2});hold off;
    title('Atrophy ECT sMCI');
end

if(pMCI_check)

    subplot(2,2,2);histogram(atrophy_Bernal_ECT_pMCI{1});hold on;
    histogram(atrophy_Check_ECT_pMCI{1});hold off;
    title('Baseline ECT pMCI');

    subplot(2,2,4);histogram(atrophy_Bernal_ECT_pMCI{2});hold on;
    histogram(atrophy_Check_ECT_pMCI{2});hold off;
    title('Atrophy ECT pMCI');
end




 end

function ni = get_ni(time_visit,numIDs)
baseline=find(time_visit==0);
numScans=length(time_visit);
ni=baseline([2:end,end])-baseline;
ni(end)=numScans-baseline(end)+1;
if(isempty(numIDs)==0)
    if(length(ni)~=numIDs)
        warning('Error calculating ni: There are more scans in baseline than subjects');
    end
end
if(sum(ni)~=numScans)
   warning('Error calculating ni');
end

end


function atrophy=getAtrophy(X,ni,HippMarker)


time=X(:,1);
BlAge=X(:,2);


BlAge_ni=BlAge(time==0);

atrophy=cell(2,1);
intercept=ones(length(time),1);
X_Hipp=[intercept,time];%,BlAge];
model=lme_fit_FS(X_Hipp,[1 2],HippMarker,ni);

% atrophy{1}=model.Bhat(1)+(model.Bhat(3)*BlAge_ni')+model.bihat(1,:);
% atrophy{2}=(((model.Bhat(2)+model.bihat(2,:)))./...
%     ((model.Bhat(1)+(model.Bhat(3)*BlAge_ni')+model.bihat(1,:)))*100);

atrophy{1}=model.Bhat(1)+model.bihat(1,:);
atrophy{2}=(((model.Bhat(2)+model.bihat(2,:)))./...
    ((model.Bhat(1)+model.bihat(1,:)))*100);


end


