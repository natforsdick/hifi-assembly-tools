#!/bin/bash -e 
#SBATCH -J bam2fastq   
#SBATCH -A ga03186     
#SBATCH --time=02:00:00                  
#SBATCH --mem=6G              
#SBATCH --cpus-per-task=2
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.out

#########
# PARAMS

INDIR=/nesi/project/ga03186/data/frog-pacbio/AGRF_CAGRF22029573_PacBio/
OUTDIR=/nesi/nobackup/ga03186/frog-genome/01-preprocessing/
HIFI="with_5mC.bam"
#########

#########
# ENV

ml purge
ml Python/2.7.18-gimkl-2020a

conda activate pacbioconda
bam2fastq --version
#########

cd $OUTDIR

bam2fastq -o frog-hifi-cell1 ${INDIR}${HIFI}.bam
