#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J repmask1
#SBATCH --cpus-per-task=16
#SBATCH --mem=12G
#SBATCH -t 04:00:00
#SBATCH --out %x.%j.out
#SBATCH --err %x.%j.err

# round 1: annotate/mask simple repeats
OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/annotation/repeats/masking/
REFDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/yahs/
REF=asm3-hic-hifiasm-p-p_ctg-purged_rep1_scaffolds_final.contam-excl.fa

cd $OUTDIR

ml purge
ml RepeatMasker/4.1.0-gimkl-2020a
date
RepeatMasker -pa 16 -a -e ncbi -dir ${OUTDIR}01_simple_out/ -noint -xsmall ${REFDIR}${REF} 2>&1 | tee ${OUTDIR}logs/01_simplemask.log
date
ml purge
