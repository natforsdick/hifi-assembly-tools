#!/bin/bash -e

#SBATCH --job-name=minimap-HiFi
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=01:30:00 
#SBATCH --mem=25G # 6G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=32
#SBATCH --profile=task

# align-HiFi.sl
# Align HiFi reads to a reference using minimap
# Nat Forsdick, 2021-10-28
 
# Based on subsamp of 60,000 HiFi reads taking 2 min to map (incl. initial indexing), 
# should take 45 min to map all HiFi data.

#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 
#########

#########
# PARAMS
#########
DIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-minimap/
REFDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/05_kaki_SalsaScaff/yahs/
REF=yahs-asm3_scaffolds_final
HIFIDIR=/nesi/project/ga03186/data/JF_PacBio-kaki-Steeves-Order260/processed/
HIFI=m54349U_210221_005741.fastq.gz
#########

cd $DIR

echo Indexing ${REF}

# To index reference genome the first time you run this - can then just call the index ref.mmi following this
minimap2 -t $SLURM_CPUS_PER_TASK -d ${REF}.mmi ${REFDIR}${REF}.fa

echo Aligning ${HIFI} against ${REF}
# To map HiFi reads to assembly
minimap2 -ax map-hifi -t $SLURM_CPUS_PER_TASK ${REF}.mmi ${HIFIDIR}${HIFI} > ${REF}-pb.sam

echo Converting to bam
ml SAMtools/1.13-GCC-9.2.0
samtools view -bS -@ 12 ${REF}-pb.sam | samtools sort -@ 12 -o ${REF}-pb.bam

echo getting stats
samtools coverage ${REF}-pb.bam -o ${REF}-pb-cov.txt
samtools stats -@ 12 ${REF}-pb.bam > ${REF}-pb-stats.txt

echo plotting stats
plot-bamstats -p ${REF}-pb-stats ${REF}-pb-stats.txt

#echo Collecting stats
#$HOME/bin/k8 /nesi/project/ga03186/kaki-genome-assembly/QC/alignment/paftools.js stat ${REF}-pb.paf > ${REF}-pb-stat.out
