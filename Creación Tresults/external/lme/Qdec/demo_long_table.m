% export FREESURFER_HOME=/usr/local/freesurfer
% source /usr/local/freesurfer/SetUpFreeSurfer.sh
% export SUBJECTS_DIR=/home2/cplatero/hipocampo/long_tutorial/long-tutorial
% asegstats2table --qdec-long long.qdec.table.dat --stats aseg.stats --tablefile aseg.table.txt
% Matlab
[aseg, asegrows,asegcols] =  fast_ldtable(['./aseg.table.txt']);