parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))

clc;
clear all;
close all;

cd ..
addpath('./YALMIPR20170921','./YALMIPR20170921/demos', ...
        './YALMIPR20170921/extras', './YALMIPR20170921/modules', ...
        './YALMIPR20170921/operators', './YALMIPR20170921/solvers');
addpath('./Gurobi'); 
addpath('./Data');

load VDM1TaskE1.mat
cd ParaTaskV1E1

TotalLoc = 6862;
Nloc = 10; % no of loc of each run
maxrun = ceil(TotalLoc/Nloc);

StrInfo.Pstr = 1; % 1 MW_w = 0.75 MW_e 
StrInfo.Tstr = 0:6:72; % stoarge h
StrInfo.Blade = 0.1;

tic
% runpool = 1:100;
runpool = UnFinishPool;
parfor run = 1:length(runpool)
    clc;
    WT1 = [];
    WT2 = [];
    [WT1, WT2] = CompWTGenFunPara(runpool(run), Nloc, TotalLoc, StrInfo);
end
toc

delete(gcp);
exit
