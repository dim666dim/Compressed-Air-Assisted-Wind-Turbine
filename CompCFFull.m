close all
clear all

% cd ..
% addpath('J:\GWVDM1E')
% addpath('J:\GWVDM1N')
% addpath('J:\GWVDM2E')
% addpath('J:\GWVDM2N')
% addpath('J:\GWVDM1ER')
% addpath('J:\GWVDM2ER')
% cd F:\Dropbox\Code\HarvardServer\Research\MaxGenGW15

%% Draw Option
DrawOption.GenCFI24 = 0;    % General CF improvement with 24h storage;
DrawOption.CFIPattern = 1;  % CF improvement pattern with capacity in TstrPool;
DrawOption.DetailLoc = 0;   % Information of detailed location 
DrawOption.MaxStr = 0;
DrawOption.CFIStat = 0;
DrawOption.StrSen = 0;
DrawOption.Lang = 'zh'; % 'en' 

%% Data Scope
AnaLocPool = 1:6862; 
TstrPool = [6:6:24];
SortPool = 1:6862; % Pool for pattern
DetailLocPool = [105 211]; % Location require detail Information
DetailTimeScope = 1008:1.5*1008; % Specific time scope for detail information
WholeTimeScope = 1:8760; 

%% Read Data
disp('... loading data ...')
sheet = 1;
[numVDM1, txt, raw] = xlsread('ResultCAMaxGen.xlsx', sheet);
CFVDM1Pool = numVDM1(2:end,2:end-1);% 0-72h  13 colum
BaseCF1 = numVDM1(2:end,end); % Gold wind
CFVDM1ImproveAbs = CFVDM1Pool(:,2:end) - repmat(BaseCF1,1,12); % 6-72
CFVDM1ImproveRel = 100*CFVDM1ImproveAbs./repmat(BaseCF1,1,12); % 6-72
Temp1 = CFVDM1Pool(:,2:end);
[ValueVDM1, IndexVDM1] = max(CFVDM1ImproveRel);

save CFVDM1ImproveRel.mat CFVDM1ImproveRel CFVDM1ImproveAbs BaseCF1

sheet = 2;
[numVDM1E, txt, raw] = xlsread('ResultCAMaxGen.xlsx', sheet);
BaseCF1E = numVDM1E(2:end,end); % Gold wind with extended blade
CFVDM1EPool = numVDM1E(2:end,2:end-1); % 0-72h  13 colum
CFVDM1EImproveAbs = CFVDM1EPool(:,2:end) - repmat(BaseCF1,1,12); % 6-72  wrt GW
CFVDM1EImproveRel = 100*CFVDM1EImproveAbs./repmat(BaseCF1,1,12); % 6-72  wrt GW
CFVDM1EImproveAbsE = CFVDM1EPool(:,2:end) - repmat(BaseCF1E,1,12); % 6-72 wrt GW-E
CFVDM1EImproveRelE = 100*CFVDM1EImproveAbs./repmat(BaseCF1E,1,12); % 6-72 wrt GW-E
[ValueVDM1E, IndexVDM1E] = max(CFVDM1EImproveRel);

save CFVDM1EImproveRelE.mat CFVDM1EImproveRelE CFVDM1EImproveRel BaseCF1E

sheet = 3;
[numVDM2, txt, raw] = xlsread('ResultCAMaxGen.xlsx', sheet);
BaseCF2 = numVDM2(2:end,end); % Gold wind
CFVDM2Pool = numVDM2(2:end,2:end-1); % 0-72h  13 colum
CFVDM2ImproveAbs = CFVDM2Pool(:,2:end) - repmat(BaseCF2,1,12); % 6-72
CFVDM2ImproveRel = 100*CFVDM2ImproveAbs./repmat(BaseCF2,1,12); % 6-72
[ValueVDM2, IndexVDM2] = max(CFVDM2ImproveRel);

save CFVDM2ImproveRel.mat CFVDM2ImproveRel CFVDM2ImproveAbs CFVDM2Pool BaseCF2

sheet = 4;
[numVDM2E, txt, raw] = xlsread('ResultCAMaxGen.xlsx', sheet);
BaseCF2E= numVDM2E(2:end,end); % Gold wind
CFVDM2EPool = numVDM2E(2:end,2:end-1); % 0-72h  13 colum
CFVDM2EImproveAbs = CFVDM2EPool(:,2:end) - repmat(BaseCF2,1,12); % 6-72 wrt GW
CFVDM2EImproveRel = 100*CFVDM2EImproveAbs./repmat(BaseCF2,1,12); % 6-72 wrt GW
CFVDM2EImproveAbsE = CFVDM2EPool(:,2:end) - repmat(BaseCF2E,1,12); % 6-72 wrt GW-E
CFVDM2EImproveRelE = 100*CFVDM2EImproveAbs./repmat(BaseCF2E,1,12); % 6-72 wrt GW-E
[ValueVDM2E, IndexVDM2E] = max(CFVDM2EImproveRel);

save CFVDM2EImproveRelE.mat CFVDM2EImproveRelE CFVDM2EImproveRel BaseCF2E

sheet = 5;
[numVDM1ER, txt, raw] = xlsread('ResultCAMaxGen.xlsx', sheet);
BaseCF1ER = numVDM1ER(2:end,end); % Gold wind with extended blade
CFVDM1ERPool = numVDM1ER(2:end,2:end-1); % 0-72h  13 colum
CFVDM1ERImproveAbs = CFVDM1ERPool(:,2:end) - repmat(BaseCF1,1,12); % 6-72  wrt GW
CFVDM1ERImproveRel = 100*CFVDM1ERImproveAbs./repmat(BaseCF1,1,12); % 6-72  wrt GW
CFVDM1ERImproveAbsE = CFVDM1ERPool(:,2:end) - repmat(BaseCF1ER,1,12); % 6-72 wrt GW-E
CFVDM1ERImproveRelE = 100*CFVDM1ERImproveAbsE./repmat(BaseCF1ER,1,12); % 6-72 wrt GW-E
[ValueVDM1ER, IndexVDM1ER] = max(CFVDM1ERImproveRel);
% 

save CFVDM1ERImproveRelE.mat CFVDM1ERImproveRelE CFVDM1ERImproveRel BaseCF1ER

sheet = 6;
[numVDM2ER, txt, raw] = xlsread('ResultCAMaxGen.xlsx', sheet);
BaseCF2ER= numVDM2ER(2:end,end); % Gold wind
CFVDM2ERPool = numVDM2ER(2:end,2:end-1); % 0-72h  13 colum
CFVDM2ERImproveAbs = CFVDM2ERPool(:,2:end) - repmat(BaseCF2,1,12); % 6-72 wrt GW
CFVDM2ERImproveRel = 100*CFVDM2ERImproveAbs./repmat(BaseCF2,1,12); % 6-72 wrt GW
CFVDM2ERImproveAbsE = CFVDM2ERPool(:,2:end) - repmat(BaseCF2ER,1,12); % 6-72 wrt GW-E
CFVDM2ERImproveRelE = 100*CFVDM2ERImproveAbs./repmat(BaseCF2ER,1,12); % 6-72 wrt GW-E
[ValueVDM2ER, IndexVDM2ER] = max(CFVDM2ERImproveRel);

save CFVDM2ERImproveRelE.mat CFVDM2ERImproveRelE CFVDM2ERImproveRel BaseCF2ER

%% Check the correctness of the data
disp('... checking data ...')
errbaseCF = BaseCF1 - BaseCF2;
errbaseCFE = BaseCF1E - BaseCF2E; % double check 5000-6000
errbaseCFER = BaseCF1ER - BaseCF2ER;

errtolerance = 1e-10;

if sum(errbaseCF) <= errtolerance
    BaseCF = BaseCF1;
else
    warning('Inconsistent BaseCF1 & BaseCF2')
end

if sum(errbaseCFE) <= errtolerance
    BaseCFE = BaseCF1E;
else
    warning('Inconsistent BaseCFE1 & BaseCFE2')
end

if sum(errbaseCFER) <= errtolerance
    BaseCFER = BaseCF1ER;
else
    warning('Inconsistent BaseCFE1R & BaseCFE2R')
end

%% Plot CF improvement with str = 24h
if DrawOption.GenCFI24
    figure
    subplot(4,1,1)
    hold on 
    plot(AnaLocPool, 100*BaseCF(AnaLocPool), 'b-')
    plot(AnaLocPool, 100*BaseCFE(AnaLocPool), 'g-')
    plot(AnaLocPool, 100*BaseCFER(AnaLocPool), 'r-')
    if strcmp(DrawOption.Lang, 'en')
        xlabel('Sample ID')
        ylabel('CF (%)')
        legend('GW', 'GW-E-10', 'GW-E-5')
        %     legend('GW', 'GW-E-10')
        title('CF of GoldWind')
    else
        xlabel('样本 ID')
        ylabel('容量因子 (%)')
        legend('GW', 'GW-E-10', 'GW-E-5')
        %     legend('GW', 'GW-E-10')
        title('金风风机')
    end

    subplot(4,1,2)
    hold on
    plot(AnaLocPool, 100*CFVDM1Pool(AnaLocPool,4), 'g-')
    plot(AnaLocPool, 100*CFVDM2Pool(AnaLocPool,4), 'b-')
    plot(AnaLocPool, 100*CFVDM1EPool(AnaLocPool,4), 'r-')
    plot(AnaLocPool, 100*CFVDM2EPool(AnaLocPool,4), 'm-')
    plot(AnaLocPool, 100*CFVDM1ERPool(AnaLocPool,4), 'g-.')
    plot(AnaLocPool, 100*CFVDM2ERPool(AnaLocPool,4), 'b-.')
    
    if strcmp(DrawOption.Lang, 'en')
        xlabel('Sample ID')
        ylabel('CF (%)')
        legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10', 'VDM1-E-5', 'VDM2-E-5')
        %     legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10')
        title('CF of CA-WT (24h)')
    else
        xlabel('样本 ID')
        ylabel('容量因子 (%)')
        legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10', 'VDM1-E-5', 'VDM2-E-5')
        %     legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10')
        title('CA-WT (24h)')
    end
    
    subplot(4,1,3)
    hold on
    plot(AnaLocPool, CFVDM1ImproveRel(AnaLocPool,4),'g-')
    plot(AnaLocPool, CFVDM2ImproveRel(AnaLocPool,4),'b-')
    plot(AnaLocPool, CFVDM1EImproveRel(AnaLocPool,4),'r-')
    plot(AnaLocPool, CFVDM2EImproveRel(AnaLocPool,4),'m-')
    plot(AnaLocPool, CFVDM1ERImproveRel(AnaLocPool,4),'g-.')
    plot(AnaLocPool, CFVDM2ERImproveRel(AnaLocPool,4),'b-.')
    
    if strcmp(DrawOption.Lang, 'en')
        xlabel('Sample ID')
        ylabel('CF Increment (%)')
        legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10', 'VDM1-E-5', 'VDM2-E-5')
        %     legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10')
        title('CA-WT (24h) v.s. GW')
    else
        xlabel('样本 ID')
        ylabel('CF 提升率 (%)')
        legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10', 'VDM1-E-5', 'VDM2-E-5')
        %     legend('VDM1', 'VDM2', 'VDM1-E-10', 'VDM2-E-10')
        title('CA-WT(24h) v.s. GW')
    end

    subplot(4,1,4)
    hold on
    plot(AnaLocPool, CFVDM1EImproveRelE(AnaLocPool,4),'r-')
    plot(AnaLocPool, CFVDM2EImproveRelE(AnaLocPool,4),'m-')
    plot(AnaLocPool, CFVDM1ERImproveRelE(AnaLocPool,4),'g-')
    plot(AnaLocPool, CFVDM2ERImproveRelE(AnaLocPool,4),'b-')
    if strcmp(DrawOption.Lang, 'en')
        xlabel('Sample ID')
        ylabel('CF Increment Ratio (%)')
        legend('VDM1-E-10', 'VDM2-E-10', 'VDM1-E-5', 'VDM2-E-5')
        %     legend('VDM1-E-10', 'VDM2-E-10')
        title('CA-WT (24h) v.s. GW-E ')
    else
        xlabel('样本 ID')
        ylabel('CF 提升率 (%)')
        legend('VDM1-E-10', 'VDM2-E-10', 'VDM1-E-5', 'VDM2-E-5')
        %     legend('VDM1-E-10', 'VDM2-E-10')
        title('CA-WT(24h) v.s. GW-E')
    end

end

%% Sort & find the pattern
if DrawOption.CFIPattern 
    for TstrIndex = 1:length(TstrPool)
        figure
        subplot(3,2,1)
        [TempSortV, SortIndex] = sort(CFVDM1ImproveRel(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCF(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM1 Pattern (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['采用VDM1的CA-WT (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end


        subplot(3,2,2)
        [TempSortV, SortIndex] = sort(CFVDM2ImproveRel(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCF(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM2 Pattern (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['采用VDM2的CA-WT (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end

        subplot(3,2,3)
        [TempSortV, SortIndex] = sort(CFVDM1EImproveRel(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCF(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM1E-10 Pattern (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['采用VDM1E-10的CA-WT (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
        
        subplot(3,2,4)
        [TempSortV, SortIndex] = sort(CFVDM2EImproveRel(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCF(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM2E-10 Pattern (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['采用VDM2E-10的CA-WT(' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
        
        subplot(3,2,5)
        [TempSortV, SortIndex] = sort(CFVDM1ERImproveRel(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCF(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM1E-5 Pattern (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['采用VDM1E-5的CA-WT(' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
        
        subplot(3,2,6)
        [TempSortV, SortIndex] = sort(CFVDM2ERImproveRel(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCF(SortIndex(SortPool))', 'g-')        
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM2E-5 Pattern (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['VDM2E-5 Pattern (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
        
        figure
        subplot(2,2,1)
        [TempSortV, SortIndex] = sort(CFVDM1EImproveRelE(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCFE(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM1E-10 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['VDM1E-10 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
                
        subplot(2,2,2)
        [TempSortV, SortIndex] = sort(CFVDM2EImproveRelE(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCFE(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM2E-10 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['VDM2E-10 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
        
        subplot(2,2,3)
        [TempSortV, SortIndex] = sort(CFVDM1ERImproveRelE(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCFER(SortIndex(SortPool))', 'g-')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM1E-5 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['VDM1E-5 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
                
        subplot(2,2,4)
        [TempSortV, SortIndex] = sort(CFVDM2ERImproveRelE(:,TstrIndex));
        TempSortV = fliplr(TempSortV');
        SortIndex = fliplr(SortIndex');
        plot(SortPool, TempSortV(SortPool), 'r-')
        hold on
        plot(SortPool, 100*BaseCFER(SortIndex(SortPool))', 'g-')        
        if strcmp(DrawOption.Lang, 'en')
            xlabel('Sorted Location ID')
            ylabel('Value (%)')
            legend('CF Increment (%)', ' CF (%)')
            titInfo = ['VDM2E-5 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        else
            xlabel('排序后的样本ID')
            ylabel('数值(%)')
            legend('CF 提升率(%)', 'CF(%)')
            titInfo = ['VDM2E-5 v.s. GW-E (' num2str(TstrPool(TstrIndex)) 'h)'];
            title(titInfo)
        end
    end
end

%% Detail Information of one specific location with 24h
if  DrawOption.DetailLoc
    for loc = 1:length(DetailLocPool)
        fileIndex = ceil(DetailLocPool(loc)/10);
        locIndex = DetailLocPool(loc)-(fileIndex-1)*10;

        figure
        VDM = 1;
        filename = ['ResultParaVDM' num2str(VDM) 'RunN' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');

        subplot(2,2,1)
        plot(WholeTimeScope, WT1.Speed_80(locIndex, WholeTimeScope, 4)', 'r-')
        xlabel('time (h)')
        ylabel('wind speed (m/s)')
        titlestr = ['yearly wind speed at loc' num2str(DetailLocPool(loc))];
        title(titlestr)

        subplot(2,2,3)
        plot(WholeTimeScope, WT2.Gen_80(locIndex, WholeTimeScope)', 'g-')
        hold on
        plot(WholeTimeScope, WT1.Gen_80(locIndex, WholeTimeScope, 4)', 'r-'); % 24h

        VDM = 2;
        filename = ['ResultParaVDM' num2str(VDM) 'RunN' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');
        plot(WholeTimeScope, WT1.Gen_80(locIndex, WholeTimeScope, 4)', 'b-'); % 24h

        VDM = 1;
        filename = ['ResultParaVDM' num2str(VDM) 'RunE' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');
        plot(WholeTimeScope, WT1.Gen_80(locIndex, WholeTimeScope, 4)', 'r-.'); % 24h
        
        VDM = 2;
        filename = ['ResultParaVDM' num2str(VDM) 'RunE' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');
        plot(WholeTimeScope, WT1.Gen_80(locIndex, WholeTimeScope, 4)', 'b-.'); % 24h
        plot(WholeTimeScope, WT2.Gen_80(locIndex, WholeTimeScope)', 'g-.')

        xlabel('time (h)')
        ylabel('generation (MW)')
        legend( 'GW', 'VDM1', 'VDM2', 'VDM1E', 'VDM2E', 'GWE')
%         legend( 'GW', 'VDM1', 'VDM2')


        titlestr = ['yearly generation at loc' num2str(DetailLocPool(loc))];
        title(titlestr)

        subplot(2,2,2)
        plot(DetailTimeScope, WT1.Speed_80(locIndex, DetailTimeScope, end)', 'r-')
        xlabel('time (h)')
        ylabel('wind speed (m/s)')
        titlestr = ['local wind speed at loc' num2str(DetailLocPool(loc))];
        title(titlestr)


        subplot(2,2,4)
        VDM = 1;
        filename = ['ResultParaVDM' num2str(VDM) 'RunN' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');
        plot(DetailTimeScope, WT2.Gen_80(locIndex, DetailTimeScope)', 'g-')
        hold on
        plot(DetailTimeScope, WT1.Gen_80(locIndex, DetailTimeScope, 4)', 'r-'); % 24h

        VDM = 2;
        filename = ['ResultParaVDM' num2str(VDM) 'RunN' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');
        plot(DetailTimeScope, WT1.Gen_80(locIndex, DetailTimeScope, 4)', 'b-'); % 24h
    %     
        VDM = 1;
        filename = ['ResultParaVDM' num2str(VDM) 'RunE' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');
        plot(DetailTimeScope, WT1.Gen_80(locIndex, DetailTimeScope, 4)', 'r-.'); % 24h

        VDM = 2;
        filename = ['ResultParaVDM' num2str(VDM) 'RunE' num2str(fileIndex) '.mat'];
        load(filename,'-mat', 'WT1', 'WT2');
        plot(DetailTimeScope, WT1.Gen_80(locIndex, DetailTimeScope, 4)', 'b-.'); % 24h
        plot(DetailTimeScope, WT2.Gen_80(locIndex, DetailTimeScope)', 'g-.')

        xlabel('time (h)')
        ylabel('generation (MW)')
        legend( 'GW', 'VDM1', 'VDM2', 'VDM1E', 'VDM2E', 'GWE')
%         legend( 'GW', 'VDM1', 'VDM2')

        titlestr = ['local generation at loc' num2str(DetailLocPool(loc))];
        title(titlestr)

    %     figure % charging & discharging figure

    end
end


%% Plot maximal improvement w.r.t storage time
if DrawOption.MaxStr
    figure
    Tstr = 6:6:72;
    subplot(2,1,1)
    plot(Tstr,ValueVDM1,'r-*')
    hold on
    plot(Tstr,ValueVDM1E, 'b-o')
    plot(Tstr,ValueVDM2, 'g-<')
    plot(Tstr,ValueVDM2E, 'b-.>')
    xlabel('storage time (h)')
    ylabel('improvement (%)')
    legend('VDM1', 'VDM1E', 'VDM2', 'VDM2E')
%     legend('VDM1', 'VDM1E')
    title('Maximal CF Improvement (%)')

    subplot(2,1,2)
    TempV1 = CFVDM1Pool(:,2:end);
    TempV2 = CFVDM2Pool(:,2:end);
    TempV1E = CFVDM1EPool(:,2:end);
    TempV2E = CFVDM2EPool(:,2:end);
    
    plot(Tstr,100*BaseCF(IndexVDM1),'b-o')
    hold on
    plot(Tstr,100*TempV1(IndexVDM1), 'g-<')
    plot(Tstr,100*TempV2(IndexVDM2), 'r-*')
    plot(Tstr,100*TempV1E(IndexVDM1E), 'g-.>')
    plot(Tstr,100*TempV2E(IndexVDM2E), 'r-.*')
    xlabel('storage time (h)')
    ylabel('CF(%)')
    legend('Gold Wind', 'VDM1', 'VDM2', 'VDM1E', 'VDM2E')
    title('Abs CF (%)')
end

%% Plot Statistic with 72h& 48h & 24h & 18h & 12h & 6h
CFReference = 19.14; % add a filter
BaseCF = BaseCF1*100;
OnOffIndex = find(BaseCF>=CFReference);

% StrPool = [6:6:72];
StrPool = [6:6:24];
if DrawOption.CFIStat
    for StrIndex = 1:length(StrPool)
        figure % diagram
%         subplot(2,2,1)
        DataPoolN1N2 = [CFVDM1ImproveRel(OnOffIndex,StrIndex) CFVDM2ImproveRel(OnOffIndex,StrIndex)];
        histogram(DataPoolN1N2(:,1), 'Normalization', 'probability')
        hold on
        histogram(DataPoolN1N2(:,2), 'Normalization', 'probability')
        if  strcmp(DrawOption.Lang, 'en')
            xlabel('CF Increment Ratio (%)')
            ylabel('Probability')
            legend('VDM1', 'VDM2')
            titlestr = ['CA-WT with ' num2str(StrPool(StrIndex)) 'h' 'v.s. GW'];
            title(titlestr);
        else
            xlabel('CF 提升率 (%)')
            ylabel('概率')
            legend('VDM1', 'VDM2')
            titlestr = ['CA-WT（' num2str(StrPool(StrIndex)) 'h）' 'v.s. GW'];
            title(titlestr);
        end

        figure
%         subplot(2,2,2)
        DataPoolN1E1 = [CFVDM1ImproveRel(OnOffIndex,StrIndex) CFVDM1EImproveRel(OnOffIndex,StrIndex) CFVDM1ERImproveRel(OnOffIndex,StrIndex)];
%         DataPoolN1E1 = [CFVDM1ImproveRel(:,StrIndex) CFVDM1EImproveRel(:,StrIndex)];
        histogram(DataPoolN1E1(:,1),'Normalization', 'probability')
        hold on
        histogram(DataPoolN1E1(:,2),'Normalization', 'probability')
        histogram(DataPoolN1E1(:,3),'Normalization', 'probability')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('CF Increment Ratio (%)')
            ylabel('Probability')
            legend('VDM1', 'VDM1E-10', 'VDM1E-5')
            %         legend('VDM1', 'VDM1E-10')
            titlestr = ['CA-WT with ' num2str(StrPool(StrIndex)) 'h' 'v.s. GW'];
            title(titlestr);
        else
            xlabel('CF 提升率 (%)')
            ylabel('概率')
            legend('VDM1', 'VDM1E-10', 'VDM1E-5')
            %         legend('VDM1', 'VDM1E-10')
            titlestr = ['CA-WT（' num2str(StrPool(StrIndex)) 'h）' 'v.s. GW'];
            title(titlestr);
        end
        
        figure
%         subplot(2,2,3)
        DataPoolN2E2 = [CFVDM2ImproveRel(OnOffIndex,StrIndex) CFVDM2EImproveRel(OnOffIndex,StrIndex) CFVDM2ERImproveRel(OnOffIndex,StrIndex)];
%         DataPoolN2E2 = [CFVDM2ImproveRel(:,StrIndex) CFVDM2EImproveRel(:,StrIndex)];
        histogram(DataPoolN2E2(:,1),'Normalization', 'probability')
        hold on
        histogram(DataPoolN2E2(:,2),'Normalization', 'probability')
        histogram(DataPoolN2E2(:,3),'Normalization', 'probability')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('CF Increment Ratio (%)')
            ylabel('Probability')
            legend('VDM1', 'VDM1E-10', 'VDM1E-5')
            %         legend('VDM1', 'VDM1E-10')
            titlestr = ['CA-WT with ' num2str(StrPool(StrIndex)) 'h' 'v.s. GW'];
            title(titlestr);
        else
            xlabel('CF 提升率 (%)')
            ylabel('概率')
            legend('VDM2', 'VDM2E-10', 'VDM2E-5')
            %         legend('VDM1', 'VDM1E-10')
            titlestr = ['CA-WT（' num2str(StrPool(StrIndex)) 'h）' 'v.s. GW'];
            title(titlestr);
        end

        figure
%         subplot(2,2,4)
        DataPoolE1E2 = [CFVDM1EImproveRelE(OnOffIndex,StrIndex) CFVDM2EImproveRelE(OnOffIndex,StrIndex) ...
                     CFVDM1ERImproveRelE(OnOffIndex,StrIndex) CFVDM2ERImproveRelE(OnOffIndex,StrIndex)];
%         DataPoolE1E2 = [CFVDM1EImproveRelE(:,StrIndex) CFVDM2EImproveRelE(:,StrIndex)];
        histogram(DataPoolE1E2(:,1),'Normalization', 'probability')
        hold on
        histogram(DataPoolE1E2(:,2),'Normalization', 'probability')
        histogram(DataPoolE1E2(:,3),'Normalization', 'probability')
        histogram(DataPoolE1E2(:,4),'Normalization', 'probability')
        if strcmp(DrawOption.Lang, 'en')
            xlabel('CF Increment Ratio (%)')
            ylabel('Probability')
            legend('VDM1E-10', 'VDM2E-10','VDM1E-5', 'VDM2E-5')
            titlestr = ['CA-WT with ' num2str(StrPool(StrIndex)) 'h' 'v.s. GW-E'];
            title(titlestr);
        else
            xlabel('CF 提升率 (%)')
            ylabel('概率')
            legend('VDM1E-10', 'VDM2E-10','VDM1E-5', 'VDM2E-5')
            titlestr = ['CA-WT（' num2str(StrPool(StrIndex)) 'h）' 'v.s. GW-E'];
            title(titlestr);
        end
    end
end


%% Plot 3D Storage Capacity Sensitivity
if DrawOption.StrSen
    StrPool = [6:6:72];
    BaseCF3D = 10; % CF reference
    DataPoolStr3DN1 = CFVDM1ImproveRel(OnOffIndex,1:length(StrPool));
    DataPoolStr3DN2 = CFVDM2ImproveRel(OnOffIndex,1:length(StrPool));
    DataPoolStr3DN1E1 = CFVDM1EImproveRel(OnOffIndex,1:length(StrPool)); % 10
    DataPoolStr3DN1E1R = CFVDM1ERImproveRel(OnOffIndex,1:length(StrPool)); % 5
    DataPoolStr3DN2E2 = CFVDM2EImproveRel(OnOffIndex,1:length(StrPool)); % 10
    DataPoolStr3DN2E2R = CFVDM2ERImproveRel(OnOffIndex,1:length(StrPool)); % 5

    % NumStr3DN1 = sum(DataPoolStr3DN1 >= BaseCF3D)
    % NumStr3DN1E1 = sum(DataPoolStr3DN1E1 >= (BaseCF3D +5));
    % NumStr3DN1E1R = sum(DataPoolStr3DN1E1R >= (BaseCF3D +10));
    NumStr3DN2 = sum(DataPoolStr3DN2 >= BaseCF3D);
    NumStr3DN2E2R = sum(DataPoolStr3DN2E2R >= (BaseCF3D +5));
    NumStr3DN2E2 = sum(DataPoolStr3DN2E2 >=(BaseCF3D +10));

    figure
    plot(StrPool, 0.5*NumStr3DN2, '-r*')
    hold on
    plot(StrPool, 0.5*NumStr3DN2E2R, '-go')
    plot(StrPool, 0.5*NumStr3DN2E2, '-b^')
    if strcmp(DrawOption.Lang, 'en')
        xlabel('storage time (h)')
        ylabel('No. Sample ID')
        legend('VDM2 with 10% Base','VDM2E-5 with 15% Base','VDM2E-10 with 20% Base')
    else
        xlabel('储能时间(h)')
        ylabel('样本点数(个)')
        legend('VDM2 (10%提升基准线)','VDM2E-5 (15% 提升基准线)','VDM2E-10 (20% 提升基准线)')
    end
end
