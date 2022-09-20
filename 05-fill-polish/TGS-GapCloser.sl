#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J TGSGapClose
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=24
#SBATCH --mem=48G
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err
#SBATCH --profile=task

# TGS-GapCloser.sl
# Nat Forsdick, 2022-08-18
# Running TGS-GapCloser for kakī 
# Takes 2 params: 1: full path to assembly, and 2: output directory.
TGSGapCloser=/nesi/nobackup/ga03048/modules/TGS-GapCloser/TGS-GapCloser.sh
HIFIDIR=/nesi/project/ga03186/data/JF_PacBio-kaki-Steeves-Order260/processed/
HIFI=m54349U_210221_005741
HIFIIN=$HIFIDIR${HIFI}.fastq.gz
ASM=$1
OUTDIR=$2

ml purge
ml Racon/1.5.0-GCC-11.3.0

RACON=/opt/nesi/mahuika/Racon/1.5.0-GCC-11.3.0/bin/racon

cd $OUTDIR

# First need to convert HiFi fastq to fasta
if [ ! -e ${HIFI}.fasta ]; then
zcat $HIFIIN | sed -n '1~4s/^@/>/p;2~4p' > ${HIFI}.fasta
fi

$TGSGapCloser \
        --scaff $ASM \
        --reads ${HIFI}.fasta \
        --output ${OUTDIR}tgc-yahs-asm3_scaffolds_final \
        --minmap_arg '-x asm20' \
        --racon $RACON \
        --tgstype pb \
        --thread 32 \
        >${OUTDIR}pipe.log 2>${OUTDIR}pipe.err
