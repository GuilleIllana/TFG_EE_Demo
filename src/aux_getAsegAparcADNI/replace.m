function replace(name_dat,S1,S2)
    % This function is charged of replacing a string S1 with a string S2 in
    % a file called name_dat. First its content is stored by reading the
    % file.
    fid = fopen(name_dat,'rt') ;
    X = fread(fid) ;
    fclose(fid) ;    
    X = char(X.') ;
    
    % Later S1 is replaced by S2 and all of it is stored into the file.
    Y = strrep(X, S1, S2) ;
    fid2 = fopen(name_dat,'wt') ;
    fwrite(fid2,Y) ;
    fclose (fid2) ;
    
end