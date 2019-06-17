function [WT1, WT2] = CompWTGenFunPara(run, Nloc, TotalLoc, StrInfo)
cd ..
cd Data
load ChinaWind80.mat
cd ..
cd ParaTaskV1E1
Wspeed_80 = ChinaWind80;

NT = size(Wspeed_80,1);
N_sub = 1; % No. Subproblem 
NT_sub = NT/N_sub; 

Tstr = StrInfo.Tstr;
Pstr = StrInfo.Pstr;

for loc = 1: Nloc 
    if  (run-1)*Nloc + loc <= TotalLoc
    %% Type 1 CA-WT 1.5
        for tt = 1: length(Tstr)
            WTCF_Temp = zeros(N_sub,1);
            for sub = 1:N_sub
                 if sub == 1
                    [WT] = MaxWTgen15R1Para(Wspeed_80(1:NT_sub, (run-1)*Nloc+loc), 1, Tstr(tt), StrInfo);
                    WT1.Speed_80(loc,1:NT_sub,tt) = WT.speed;
                    WT1.Gen_80(loc,1:NT_sub,tt) = WT.gen;
                    WT1.Ava_80(loc,1:NT_sub,tt) = WT.Ava;
                    WT1.Cap_80(loc,1:NT_sub,tt) = WT.Cap;
                    WT1.Char_80(loc,1:NT_sub,tt) = WT.Char;
                    WT1.Disc_80(loc,1:NT_sub,tt) = WT.Disc;
                    WT1.Str_80(loc,1:NT_sub,tt) = WT.Str;
                    WT1.type = WT.type;
                    WT1.Info = WT.Info;

                    WTCF_Temp(sub,1) = WT.CF;
                end
            end
            WT1.CF_80(loc,tt) = mean(WTCF_Temp);

        end
        WT1.CFMax_80(loc) = sum(WT1.Ava_80(loc,:,tt))/(1.5*NT); 
        
      %% Type 2 WT 1.5
        [WT] = MaxWTgen15R1Para(Wspeed_80(1:NT, (run-1)*Nloc+loc), 2, Tstr(tt), StrInfo);
        WT2.Gen_80(loc,:) = WT.gen;
        WT2.CF_80(loc) = WT.CF;
        WT2.type = WT.type;
        WT2.Info = WT.Info;
        WT2.Ava(loc,:) = WT.Ava;
      end
end

filenm = ['ResultParaVDM' num2str(StrInfo.Pstr) 'RunE' num2str(run)  '.mat' ];
cd ..
cd ResultV1E
save(filenm, 'WT1', 'WT2', '-mat');
cd ..
cd ParaTaskV1E1
