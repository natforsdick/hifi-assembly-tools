#!/bin/bash -e

#SBATCH --account ga03186
#SBATCH --job-name hifiasm_test
#SBATCH --cpus-per-task 32
#SBATCH --mem 36G
#SBATCH --time 02:35:00
#SBATCH --output hifiasm.%j.out
#SBATCH --error hifiasm.%j.err

##############
# HIFIASM TEST
# 2021-08-16
# Nat Forsdick
##############

##############
# MODULES
module purge
module load hifiasm/0.15.5-GCC-9.2.0
##############

##############
INDIR=/nesi/project/ga03186/data/JF_PacBio-kaki-Steeves-Order260/processed/
DATA=m54349U_210221_005741.fastq
INHIC=/nesi/nobackup/ga03048/data/HiC/
DATAHIC=Kaki_Hi_C_J42W3_GAGCGCCA_L001_  # suffix is _R1.fastq.gz, _R2.fastq.gz
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm/
OUTPRE=kaki-hifiasm
date=$(date)
##############

cd $OUTDIR
echo "Starting hifiasm assembly for ${DATA} at " $date
# Used -f0 for testing - used for small genomes to disable inital Bloom filters requiring 16 GB mem.
hifiasm -o ${OUTPRE} -t $SLURM_CPUS_PER_TASK ${INDIR}${DATA} 2> ${OUTPRE}.log
awk '/^S/{print ">"$2;print $3}' ${OUTPRE}.bp.p_ctg.gfa > ${OUTPRE}.p_ctg.fa  # get primary contigs in FASTA format
echo "Completed at " $date

# Hi-C phasing with paired-end short reads in two FASTQ files
#hifiasm -o ${OUTPRE}-HiC.asm --h1 ${INHIC}${DATAHIC}_R1.fastq.gz --h2 ${INHIC}${DATAHIC}_R2.fastq.gz ${INDIR}${DATA}
