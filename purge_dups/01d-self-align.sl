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

# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# Step 01d in purge_dups pipeline
# Self-self alignment of assembly


#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 
#########

#########
# PARAMS
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/purge_dups/
PRI=asm2-hifiasm-p.p_ctg
#########

cd $OUTDIR
# -x asm5: intra-specific asm-to-asm alignment
minimap2 -x asm5 -t $SLURM_CPUS_PER_TASK -DP ${PRI}.split ${PRI}.split | gzip -c - > ${PRI}.split.self.paf.gz
