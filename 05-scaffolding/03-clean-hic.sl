#!/bin/bash -e
#SBATCH --account=ga03186
#SBATCH --job-name=fastp 
#SBATCH --cpus-per-task=12 
#SBATCH --mem=8G # 3 GB full data set
#SBATCH --time=00:45:00  #1hr 30 for full data
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

##########
# PARAMS
OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/
ASSEMBLY=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/01P-asm3-hic-hifiasm-p-p_ctg-purged.fa
APREFIX=Kaki-HiC
HIC_DIR=/nesi/project/ga03048/data/hic/kaki-HiC-concatenated/
HIC_RAW1=${HIC_DIR}Kaki_HiC_raw_all_R
READ1=${HIC_RAW1}1.fastq.gz
READ2=${HIC_RAW1}2.fastq.gz
############

ml purge && module load fastp/0.23.2-GCC-11.3.0

### Clean HiC Reads with fastp.###
cd $OUTDIR
echo processing $READ1
fastp \
-i ${READ1} \
-o ${OUTDIR}${APREFIX}_clean_R1.fastq.gz \
-I ${READ2} \
-O ${OUTDIR}${APREFIX}_clean_R2.fastq.gz \
--trim_front1 15 \
--trim_front2 15 \
--qualified_quality_phred 20 \
--length_required 50 \
--thread 12
