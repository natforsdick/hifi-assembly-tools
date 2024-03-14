#!/bin/bash -e 
#SBATCH -A ga03186
#SBATCH -J meryl-merge
#SBATCH -c 28
#SBATCH --mem=4G
#SBATCH --time=00:05:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

##########
# PARAMS #
##########
genome=kaki
outdir=/nesi/nobackup/ga03048/kaki-hifi-asm/asm-stats/merqury/
##########

ml purge
ml Merqury/1.3-Miniconda3

cd $outdir

echo "merging"
date
# 2. Merge
meryl union-sum threads=$SLURM_CPU_PER_TASK memory=$SLURM_MEM_PER_NODE output ${genome}.meryl ${outdir}H0*.meryl

