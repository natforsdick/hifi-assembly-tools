#!/bin/bash 
#SBATCH --account=ga03048
#SBATCH --job-name=hic-filter # job name (shows up in the queue)
#SBATCH --cpus-per-task=28
#SBATCH --mem=30G
#SBATCH --time=06:00:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

###################################################
# ARIMA GENOMICS HI-C MAPPING PIPELINE 02/08/2019 #
###################################################

# Modified by Nat Forsdick, 2022-05-31

#Below find the commands used to filter HiC data.

#Replace the variables at the top with the correct paths for the locations of files/programs on your system.

#This bash script will map one paired end HiC dataset (read1 & read2 fastqs). Feel to modify and multiplex as you see fit to work with your volume of samples and system.

##########################################
# PARAMS #
##########################################

SRA='Kaki_HiC_raw_all_R'
LABEL='Kaki-HiC-mapped'
IN_DIR='/nesi/project/ga03048/data/hic/kaki-HiC/'
REF_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/01-purge-dups/'
REF='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/01-purge-dups/01P-asm3-hic-hifiasm-p-p_ctg-purged.fa'
FAIDX='${REF}.fai'
PREFIX='01P-asm3-hic-hifiasm-p-p_ctg-purged'
RAW_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/01_kaki_mapped/'
FILT_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/02_kaki_filtered/'
FILTER='/nesi/project/ga03186/scripts/Hi-C_scripts/filter_five_end.pl'
COMBINER='/nesi/project/ga03186/scripts/Hi-C_scripts/two_read_bam_combiner.pl'
STATS='/nesi/project/ga03186/scripts/Hi-C_scripts/get_stats.pl'
PICARD='/software/picard/picard-2.6.0/build/libs/picard.jar'
TMP_DIR='/nesi/nobackup/ga03186/tmp-${SLURM_JOB_ID}/'
PAIR_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/03_kaki_paired/'
REP_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/04_kaki_dedup/'
REP_LABEL=$LABEL\_rep1
MERGE_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/05_kaki_merged/'
MAPQ_FILTER=10
CPU=24

##########################################
# ENVIRONMENT
##########################################

module purge
module load BWA/0.7.17-GCC-9.2.0 picard/2.21.8-Java-11.0.4 SAMtools/1.13-GCC-9.2.0 samblaster/0.1.26-GCC-9.2.0

##########################################
# COMMANDS
##########################################

echo "### Step 0: Check output directories exist & create them as needed"
[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $FILT_DIR ] || mkdir -p $FILT_DIR
[ -d $TMP_DIR ] || mkdir -p $TMP_DIR
[ -d $PAIR_DIR ] || mkdir -p $PAIR_DIR
[ -d $REP_DIR ] || mkdir -p $REP_DIR
[ -d $MERGE_DIR ] || mkdir -p $MERGE_DIR

echo "### Step 2: Filter 5' end (1st)"
samtools view -h ${RAW_DIR}${SRA}.bam | perl $FILTER | samtools view -Sb - > ${FILT_DIR}${SRA}.bam

echo "### Step 3A: Pair reads & mapping quality filter"
samtools $MAPQ_FILTER ${FILT_DIR}${SRA}.bam | samtools view -bS -t $FAIDX - | samtools sort -@ $CPU -o ${TMP_DIR}${SRA}.bam -

echo "### Step 3.B: Add read group"
java -Xmx28G -Djava.io.tmpdir=temp/ -jar $PICARD AddOrReplaceReadGroups INPUT=${TMP_DIR}${SRA}.bam OUTPUT=${PAIR_DIR}${SRA}.bam ID=$SRA LB=$SRA SM=$LABEL PL=ILLUMINA PU=none

echo "### Step 4: Mark duplicates"
java -Xmx28G -XX:-UseGCOverheadLimit -Djava.io.tmpdir=temp/ -jar $PICARD MarkDuplicates INPUT=${PAIR_DIR}$SRA.bam OUTPUT=${REP_DIR}${REP_LABEL}.bam METRICS_FILE=${REP_DIR}metrics.${REP_LABEL}.txt TMP_DIR=$TMP_DIR ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=TRUE

echo "indexing"
samtools index ${REP_DIR}${REP_LABEL}.bam

echo "collecting stats"
perl $STATS ${REP_DIR}${REP_LABEL}.bam > ${REP_DIR}${REP_LABEL}.bam.stats

echo "Finished Mapping Pipeline through Duplicate Removal"
