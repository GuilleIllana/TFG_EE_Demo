function [sX] = getyear(sX,ni)
    % This function fulfills the 'year' column taking age and the number of
    % images (ni) for each subject.
    suj=0;
    for i=1:numel(ni)
        for v=1:ni(i)
            if v==1
                basetime=sX{suj+v,3};
            end
            sX{suj+v,2}=sX {suj+v,3}-basetime;
        end
        suj=suj+ni(i);
    end
    
end