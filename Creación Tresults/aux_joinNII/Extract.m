% load('./data/temporal.mat');
load('./Tresults_new/Tresults_new.mat');
numImgs=size(Tresults,1);
subjs=unique(Tresults.RID);
size(subjs,1)