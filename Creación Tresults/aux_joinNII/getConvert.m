function [Tresults] = getConvert(Tresults)
    % This function is charged of importing and cleaning the Tresults
    % table, taking only candidate features. However, Tresults is equally
    % returned so cleaned variables are still accessible. Extracted
    % features can be Rois, neuropsycological tests, clusters
    % or all of them.
    %
   Convert=zeros(size(Tresults,1),1);
   convertTime=Convert;
   Convert=table(Convert);
   convertTime=table(convertTime);
   Tresults=[Tresults Convert convertTime];

%% NC
[mask_NC,Convert,convertTime,onset]= convertTime_NC(Tresults);
Tresults_NC=Tresults(mask_NC,:);
Tresults_NC.Convert=Convert;
Tresults_NC.convertTime=convertTime;
% Tresults_NC.onset=onset;


%% MCI
[mask_MCI,Convert,convertTime,onset]= convertTime_MCI(Tresults);
Tresults_MCI=Tresults(mask_MCI,:);
Tresults_MCI.Convert=Convert;
Tresults_MCI.convertTime=convertTime;
% Tresults_MCI.onset=onset;


%% AD
[mask_AD,Convert,convertTime,onset]= convertTime_AD(Tresults);
Tresults_AD=Tresults(mask_AD,:);
Tresults_AD.Convert=Convert;
Tresults_AD.convertTime=convertTime;
% Tresults_AD.onset=onset;


%% Join
Tresults=[Tresults_NC;Tresults_MCI;Tresults_AD];


end

