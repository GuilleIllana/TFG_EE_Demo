function Tdec = readClinicalData(fname)
    
    Qdec = fReadQdec(fname);
    Tdec=cell2table(Qdec(2:end,:));
    varname=cellstr(Qdec(1,:));
    varname{2}='fsidbase';
    Tdec.Properties.VariableNames=varname;
    Tdec.years=str2double(Tdec.years);
    Tdec.Age=str2double(Tdec.Age);
    Tdec.MMSE=str2double(Tdec.MMSE);
    Tdec.GDS=str2double(Tdec.GDS);
    Tdec.CDR=str2double(Tdec.CDR);
    Tdec.APOE_A1=str2double(Tdec.APOE_A1);
    Tdec.APOE_A2=str2double(Tdec.APOE_A2);
end