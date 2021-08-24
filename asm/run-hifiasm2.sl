#!/bin/bash -e

#SBATCH --account ga03186
#SBATCH --job-name hifiasm2
#SBATCH --cpus-per-task 12
#SBATCH --mem 48G
#SBATCH --time 01-03:00:00
#SBATCH --output hifiasm2.%j.out
#SBATCH --error hifiasm2.%j.err
#SBATCH --profile=task
#SBATCH --acctg-freq=300 # Collect data every 5 mins

##############
# HIFIASM WITH HI-C
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
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/
OUTPRE=asm2-hic-hifiasm-p
date=$(date)
##############

mkdir -p $OUTDIR
cd $OUTDIR

echo "Starting hifiasm assembly for ${DATA} at " $date

# Hi-C phasing with paired-end short reads in two FASTQ files
hifiasm --primary -o ${OUTPRE}.asm --h1 ${INHIC}${DATAHIC}R1.fastq.gz --h2 ${INHIC}${DATAHIC}R2.fastq.gz ${INDIR}${DATA} 2> ${OUTPRE}.log
echo "Finished at " $date

awk '/^S/{print ">"$2;print $3}' ${OUTPRE}.asm.hic.p_ctg.gfa > ${OUTPRE}.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ${OUTPRE}.asm.hic.a_ctg.gfa > ${OUTPRE}.a_ctg.fa
