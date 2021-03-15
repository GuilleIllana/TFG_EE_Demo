function QdecTableLong(xmlPath, path_subj, name_dat)
    %% Generate QdecTable for LME Mass-univariate
    % Input: Subject dir and xml dir
    % Output: Qdectable (Cross or Long)
    
    % First step is to get patients info stored in xml files. If no
    % subjects_dir is found then an alternative function is run.
    strPatients=getPatientsInfor(path_subj,xmlPath);
    
    % subject id is created with the first 10 characters.
    fsidbase=cell(numel(strPatients),1);
    for i=1:numel(strPatients)
        fsidbase(i)=cellstr(strPatients(i).fsid(1:10));
    end
    
    %strPatients is temporarily converted into a table in order to get the
    %names of the columns.
    strPatients = struct2table(strPatients);
    varName = strPatients.Properties.VariableNames;
    strPatients = table2cell(strPatients);
    
    % Data is sorted according to time
    [sX,~,ni,~] = sortData(strPatients,3,strPatients,fsidbase);
    
    % year column is obtained from ages and the number of images (ni) for
    % each subject.
    [sX] = getyear(sX,ni);
    
    strPatients=cell2table(sX,'VariableNames',varName);
    
    fsidbase=cell2table(fsidbase);
    strPatients=[strPatients(:,1),fsidbase,strPatients(:,2:end)];

    % Matlab does not accept variables or names with symbols like '-'.
    % That's why it is necessary to change it from the raw file.
    %writetable(strPatients,name_dat,'WriteRowNames',true,'delimiter', ' ');
    writetable(strPatients,name_dat,'WriteRowNames',true);
    replace(name_dat,'fsidbase', 'fsid-base');
        
end
