#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=BamToBedKaki-asm3
#SBATCH --cpus-per-task=10
#SBATCH --mem=40GB
#SBATCH --time=01:00:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

################################
# Created 2020-11-26 by Nat Forsdick
# For preparing HiC data for input to SALSA
################################

module purge
module load BEDTools/2.29.2-GCC-9.2.0

LABEL='Kaki_HiCmapped'
REP_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/04_kaki_dedup/'
REF_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/01-purge-dups/'
REF='01P-asm3-hic-hifiasm-p-p_ctg-purged.fa'

mkdir /nesi/nobackup/ga03186/tmp-${SLURM_JOB_ID}

echo “Converting ${LABEL}\_rep1.bam to bed file”
date
bamToBed -i ${REP_DIR}${LABEL}\_rep1.bam > ${REP_DIR}${LABEL}\_rep1.bed
echo “converted”
date
echo “Sorting ${LABEL}\_rep1.bed”
sort -k 4 ${REP_DIR}${LABEL}\_rep1.bed > /nesi/nobackup/ga03186/tmp-${SLURM_JOB_ID}/tmp_bed${LABEL} && cp /nesi/nobackup/ga03186/tmp-${SLURM_JOB_ID}/tmp_bed${LABEL} ${REP_DIR}${LABEL}\_rep1-sorted.bed
echo “sorted”
date

# Need the .fai index file of the assembly - SALSA needs this to get the contig lengths.
#module purge
#module load SAMtools/1.10-GCC-9.2.0
#echo “Making FAI from reference assembly”
#cd $REF_DIR
#samtools faidx ${REF_DIR}${REF}
#echo “made”
#date
