function [WT] = MaxWTgen15R1Para(Wspeed, WT_type, T_str, StrInfo)
% WT_type = 1; % CA-WT 1.5MW 80m  
% WT_type = 2; % Goldwind 1.5MW 80m

NT = length(Wspeed);
WTgen = zeros(NT,1);

Pstr = StrInfo.Pstr;
Pstr = Pstr*1e6; % W

v_cut_in = 3.0; 
v1_rated = 11; 
v_cut_out = 22;
   
R_WT = 77/2; % radius
R_WT = R_WT*(1+StrInfo.Blade);

% A = 4649; % swept area
A = pi*R_WT^2;

rho = 1.225;  % air density

etaG = 1; 
etaVc = 0.75;
etaVp = 0.75;
etaX = 1;

Pgen_rated = 1500*1000; % W
%   Pvdmin_rated = Pgen_rated/etaG/etaX/etaVc; % VDM rated power
Pvdmin_rated = Pstr; % VDM rated power
Pblade_rated = Pgen_rated/etaG/etaX + Pvdmin_rated; % mechanical rated power

aai = Pgen_rated/(v1_rated^3-v_cut_in^3); %aii=0.5*rho*Cp*AW
bbi = aai*v_cut_in^3; % floss, i.e., cut-in speed

if Pstr == 1*1e6
   % v2_rated = ((Pblade_rated + bbi)/aai)^(1/3); %  14.95
    v2_rated = 13;  % mech-rated speed 
else
    v2_rated = 15;
end
% Cp_rated = 2*(1500*1e3+bbi)/rho/A/v1_rated^3; % 0.4040
Cp_rated = 0.4040;

%% WT look-up table (no use)
ReliPower = 1e3*[0   0    27   90   183  323  519  779  1087 1416 ...
                1500 1956 2496 3125 3851 3851 3851 3851 3851 3851 ...
                3851 3851 0    0    0    0    0    0    0    0];
GWPower = 1e3*[  0    0    27   90   183  323  519  779  1087 1416 ...
            1500 1500 1500 1500 1500 1500 1500 1500 1500 1500 ...
            1500 1500 0    0    0    0    0    0    0    0]; % W

if WT_type == 2  
    WTAva = zeros(NT,1);
     for ispeed = 1:NT
            if  Wspeed(ispeed) < v_cut_in
                WTgen(ispeed) = 0;
                WTAva(ispeed) = 0;
            end
            if  v_cut_in <= Wspeed(ispeed) &&  Wspeed(ispeed) <= v1_rated
                WTgen(ispeed) = 0.5*rho*A*Cp_rated*(Wspeed(ispeed)^3-v_cut_in^3); % A = 3.14*R_WT^2;
                if WTgen(ispeed) > Pgen_rated 
                    WTgen(ispeed) = Pgen_rated;
                end
                WTAva(ispeed) = WTgen(ispeed); % Available wind energy
            end
            if  v1_rated < Wspeed(ispeed) && Wspeed(ispeed) <= v_cut_out
                WTgen(ispeed) = Pgen_rated;
                WTAva(ispeed) = 0.5*rho*A*Cp_rated*(Wspeed(ispeed)^3-v_cut_in^3); % A = 3.14*R_WT^2;
            end
            if  Wspeed(ispeed) > v_cut_out
                WTgen(ispeed) = 0;
                WTAva(ispeed) = 0;
            end
     end
     WT.gen = WTgen/1e6; % MW
     WT.Ava = WTAva/1e6; % MW
     WT.type = WT_type;
     WT.Info = ['GW 70/1500'];
end

if WT_type == 1 
    PBAva = zeros(NT,1);
    
    for ispeed = 1:NT
        if  Wspeed(ispeed) < v_cut_in
            PBAva(ispeed) = 0;
        end
        if  v_cut_in <= Wspeed(ispeed) && Wspeed(ispeed) <= v2_rated 
            PBAva(ispeed) = 0.5*rho*A*Cp_rated*(Wspeed(ispeed)^3-v_cut_in^3); % A = 3.14*R_WT^2;
%             if  PBAva(ispeed) > Pgen_rated
%                 PBAva(ispeed) = Pgen_rated; % There is a huge mistake
%             end
        end
        if  v2_rated < Wspeed(ispeed) &&  Wspeed(ispeed) <= v_cut_out
            PBAva(ispeed) = 0.5*rho*A*Cp_rated*(v2_rated^3-v_cut_in^3);% A = 3.14*R_WT^2;
        end
        if  v_cut_out < Wspeed(ispeed)
            PBAva(ispeed) = 0;          
        end
    end
     
    Pg_CA_max = Pgen_rated; % W
    Pg_CA_min = 0; % W
    PVDM_rated = Pvdmin_rated;
    PB_rated = Pblade_rated;
    Estr_u = Pvdmin_rated*T_str;  % W.h
    Estr_l = 0; %     Estr_l = 0.05*Estr_u; % W.h  % 
    P_Vc_max = PVDM_rated; % 
    P_Vp_max = PVDM_rated*etaVp; % !!! etaVp 
    
   %% CA_WT Variables
    Pg_CA = sdpvar(1,NT); % Power output of CA-WT
    P_Vc = sdpvar(1,NT);  % VDM compression power
    P_Vp = sdpvar(1,NT);  % VDM expansion power
    
    Estr = sdpvar(1,NT); 
    Estr0 = sdpvar(1,1); 
    P_B = sdpvar(1,NT);   % captured energy by the blade

%     z_char = binvar(1,NT); % char  
%     z_disc = binvar(1,NT); % disc 
%     h1 = sdpvar(1,NT); % Linearize z_char*P_Vc
%     h2 = sdpvar(1,NT); % Linearize z_disc*P_Vp
    
    %% CA-WT Constraints
    HM = 1e10; % big M
    gamma = 1.00;

    F_CA = [];
    F_CA = [F_CA, P_B + P_Vp == Pg_CA + P_Vc]; 
    F_CA = [F_CA, 0 <= P_B <= PB_rated, 0 <= P_B <= PBAva'];
    F_CA = [F_CA, 0 <= P_Vc <= P_Vc_max, P_Vc <= PVDM_rated];
    F_CA = [F_CA, 0 <= P_Vp <= P_Vp_max, P_Vp <= etaVp*PVDM_rated]; % !!! eatVp
    F_CA = [F_CA, 0 <= Pg_CA <= Pg_CA_max];
    
    F_CA = [F_CA, Estr(1,1) == gamma*Estr0(1,1) + etaVc*P_Vc(1,1) - P_Vp(1,1)/etaVp];
    F_CA = [F_CA, Estr(1,2:NT) == gamma*Estr(1,1:NT-1) + etaVc*P_Vc(1,2:NT) - P_Vp(1,2:NT)/etaVp];
    F_CA = [F_CA, Estr(1,NT) == Estr0(1,1)];
    F_CA = [F_CA, Estr_l <= Estr <= Estr_u];
    F_CA = [F_CA, Estr_l <= Estr0 <= Estr_u];
    
%     F_CA_bin = [];
%     F_CA_bin = [F_CA_bin, 0 <= z_char + z_disc <= 1];
%     F_CA_bin = [F_CA_bin, Estr(1,1) == gamma*Estr0(1,1) + etaVc*h1(1,1) - h2(1,1)/etaVp];
%     F_CA_bin = [F_CA_bin, Estr(1,2:NT) == gamma*Estr(1,1:NT-1) + etaVc*h1(1,2:NT) - h2(1,2:NT)/etaVp];
%     F_CA_bin = [F_CA_bin, -HM*z_char(1,1:NT) <= h1(1,1:NT) <= HM*z_char(1,1:NT)]; % linearization
%     F_CA_bin = [F_CA_bin, -HM*z_disc(1,1:NT) <= h2(1,1:NT) <= HM*z_disc(1,1:NT)]; % linearization 
%     F_CA_bin = [F_CA_bin, -HM*(1-z_char(1,1:NT)) <= P_Vc(1,1:NT) - h1(1,1:NT) <= HM*(1-z_char(1,1:NT))]; % linearization
%     F_CA_bin = [F_CA_bin, -HM*(1-z_disc(1,1:NT)) <= P_Vp(1,1:NT) - h2(1,1:NT) <= HM*(1-z_disc(1,1:NT))]; % linearization
% 
%     F_CA_bin = [F_CA_bin, 0 <= P_Vc <= z_char*P_Vc_max, P_Vc <= P_VDM_rated];
%     F_CA_bin = [F_CA_bin, 0 <= P_Vp <= z_disc*P_Vp_max, P_Vp <= etaVp*P_VDM_rated]; % !!! eatVp

%     F_WT = [F_CA, F_CA_bin];
    F_WT = [F_CA];
    
    opt = sdpsettings('solver','gurobi');
    sol = optimize(F_CA, -sum(Pg_CA), opt);  
%       sol = optimize(F_CA, -sum(Pg_CA));  
    
    if sol.problem == 0
        disp('successed!')
        WTgen = value(Pg_CA)/1e6; % MW
        
        E_ini_out = value(Estr0)/1e6; % interface
        
        WTAva = value(PBAva)/1e6;
        WTCap = value(P_B)/1e6;
        
%         WTChar = value(z_char.*P_Vc)/1e6;
%         WTDisc = value(z_disc.*P_Vp)/1e6;
        WTChar = value(P_Vc)/1e6;
        WTDisc = value(P_Vp)/1e6;
        WTStr = value(Estr)/1e6;
        
        WT.gen = WTgen;
        WT.Ava = WTAva;
        WT.Cap = WTCap;
        WT.Char = WTChar;
        WT.Disc = WTDisc;
        WT.Str = WTStr;
        WT.Eini = E_ini_out;
        WT.type = WT_type;
        WT.Info = ['CA 70/1500'];
        WT.err = ['False'];
    else
        display('Hmm, something went wrong!');
        sol.info
        yalmiperror(sol.problem)
        % handle error
        WT.gen = zeros(1,NT);
        WT.Ava = zeros(1,NT);
        WT.Cap = zeros(1,NT);
        WT.Char = zeros(1,NT);
        WT.Disc = zeros(1,NT);
        WT.Str = zeros(1,NT);
        WT.Eini = 0;
        WT.type = WT_type;
        WT.Info = ['CA 70/1500'];
        WT.err = ['True'];
    end
end
WTCF = sum(WT.gen)/(NT*1.5);
WT.speed = Wspeed;
WT.CF = WTCF;
