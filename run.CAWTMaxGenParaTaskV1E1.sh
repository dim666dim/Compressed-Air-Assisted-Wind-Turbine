#!/bin/bash
#SBATCH -J CAWT_MaxgenParaTaskV1E1
#SBATCH -o CAWT_MaxgenParaTaskV1E1.out
#SBATCH -e CAWT_MaxgenParaTaskV1E1.err
#SBATCH -p shared
#SBATCH -N 1
#SBATCH -c 10
#SBATCH -t 0-12:00
#SBATCH --mem-per-cpu=6000

# Load required software modules
source new-modules.sh
module load gurobi/8.0.1-fasrc01 
cp -a $GUROBI_HOME/matlab/. $HOME/CAWT/Gurobi/
module load matlab/R2016a-fasrc02
srun -n 1 -c 10 matlab-default -nosplash -nodesktop -nodisplay -r "MainRunParaTaskV1E1"