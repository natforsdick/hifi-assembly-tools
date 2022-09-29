#!/bin/bash -e

#SBATCH --job-name=minimap-HiSeq
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=01:30:00
#SBATCH --mem=12G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=32

# align-HiSeq.sl
# Align HiSeq reads to a reference using minimap
# Nat Forsdick, 2021-10-28
 
#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 SAMtools/1.13-GCC-9.2.0
#########

#########
# PARAMS
#########
DIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-minimap/
REFDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/05_kaki_SalsaScaff/yahs/
REF=yahs-asm3_scaffolds_final
HISEQDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/genome-to-genome/results/trimmed/
HISEQ=H01392-L1_S7_L005
R1=_R1_001_val_1.fq.gz
R2=_R2_001_val_2.fq.gz
#########

cd $DIR

echo Aligning ${HISEQ} against ${REF}

# To index reference genome the first time you run this - can then just call the index ref.mmi following this
#minimap2 -t 4 -d ${REF}.mmi ${REFDIR}${REF}.fa

# To map HiSeq reads to assembly
echo Aligning HiSeq
minimap2 -ax sr -t 12 ${REF}.mmi ${HISEQDIR}${HISEQ}${R1} ${HISEQDIR}${HISEQ}${R2} > ${REF}-HiSeq.sam 
samtools view -bS -@ 12 ${REF}-HiSeq.sam | samtools sort -@ 12 -o ${REF}-HiSeq.bam

echo Getting stats
samtools coverage ${REF}-HiSeq.bam -o ${REF}-HiSeq-cov.txt
samtools stats -@ 12 ${REF}-HiSeq.bam -o ${REF}-HiSeq-stats.txt

echo Plotting stats
plot-bamstats -p ${REF}-HiSeq-stats ${REF}-HiSeq-stats.txt 

#$HOME/bin/k8 /nesi/project/ga03186/kaki-genome-assembly/QC/alignment/paftools.js stat ${REF}-HiSeq.paf > ${REF}-HiSeq-stat.out
