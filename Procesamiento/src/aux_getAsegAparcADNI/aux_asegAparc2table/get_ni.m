function ni = get_ni(time_visit,numIDs)
    % This function is charged of getting the number of images (ni) for
    % each subject given the time for each visit. 
    
    % Initialization
    baseline = find(time_visit==0);
    numScans = length(time_visit);
    
    % Calculating ni
    ni = baseline([2:end,end])-baseline;
    ni(end) = numScans-baseline(end)+1;
    
    % Warnings
    if(isempty(numIDs)==0)
        if(length(ni)~=numIDs)
            warning('Error calculating ni: There are more scans in baseline than subjects');
        end
    end
    if(sum(ni)~=numScans)
        warning('Error calculating ni');
    end
    
end