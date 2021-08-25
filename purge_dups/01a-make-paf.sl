#!/bin/bash -e

#SBATCH --job-name=make-paf
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=00:30:00
#SBATCH --mem=10G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=24

# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# Step 01a in purge_dups pipeline
# Mapping input HiFi data to reference genome to create a paf file

#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 
#########

#########
# PARAMS
INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/purge_dups/
DATA=/nesi/project/ga03186/data/JF_PacBio-kaki-Steeves-Order260/processed/
PRI=asm2-hifiasm-p.p_ctg
#########

mkdir -p $OUTDIR
cd $OUTDIR

minimap2 -x map-hifi -t $SLURM_CPUS_PER_TASK ${INDIR}${PRI}.fa ${DATA}m54349U_210221_005741.fastq | gzip -c - > ${PRI}-mapped.paf.gz

