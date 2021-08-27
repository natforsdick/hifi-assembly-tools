#!/bin/bash -e

#SBATCH --job-name=self-self
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=00:05:00
#SBATCH --mem=12G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=12

# Purge_dups pipeline
# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# step 03: do a self-self alignment

#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 
#########

#########
# PARAMS
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/purge_dups/
PRE=asm2-hifiasm-p- # PREFIX
PRI=p_ctg
ALT=a_ctg
R1=01P- # Designate cutoffs round - either default (01) or modified (02) and whether Primary or Alternate assembly
R2=02P-
#########

cd $OUTDIR
# -x asm5: intra-specific asm-to-asm alignment
if [ "$1" == "PRI" ]; then 
  minimap2 -x asm5 -t $SLURM_CPUS_PER_TASK -DP ${R1}${PRE}${PRI}.split ${R1}${PRE}${PRI}.split |\
  gzip -c - > ${R1}${PRE}${PRI}.split.self.paf.gz
elif [ "$1" == "ALT" ]; then
  minimap2 -x asm5 -t $SLURM_CPUS_PER_TASK -DP ${R1}${PRE}${ALT}.split ${R1}${PRE}${ALT}.split |\
  gzip -c - > ${R1}${PRE}${ALT}.split.self.paf.gz
fi 
