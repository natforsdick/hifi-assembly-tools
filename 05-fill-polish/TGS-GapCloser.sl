#!/bin/bash -e
#SBATCH -A ga03048
#SBATCH -J TGSGapClose
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=300G
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err
#SBATCH --profile=task

# TGS-GapCloser.sl
# Nat Forsdick, 2022-08-18
# Running TGS-GapCloser for weta

TGSGapCloser=/nesi/project/ga03048/modules/TGS-GapCloser/TGS-GapCloser.sh
CONTIGS=/nesi/project/ga03048/results/redbean/weta-asm1-cns/weta-asm1-wtdbg.cns.fa
ASM=/nesi/nobackup/ga03048/assemblies/hifiasm/02-purge-dups/01-weta-hic-hifiasm-p_ctg-purged.fa
OUTDIR=/nesi/nobackup/ga03048/assemblies/hifiasm/06-GapClose/

$TGSGapCloser \
        --scaff $ASM \
        --reads $CONTIGS \
        --output ${OUTDIR}01-pur-wtdbg  \
        --ne #no error correction\
        --thread 32 \
        >${OUTDIR}pipe.log 2>${OUTDIR}pipe.err

