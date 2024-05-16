#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J repmod
#SBATCH --cpus-per-task=32
#SBATCH --mem=12G
#SBATCH -t 1-16:00:00
#SBATCH --out %x.%j.out
#SBATCH --err %x.%j.err

OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/annotation/repeats/
species=kaki

date
cd $OUTDIR
ml purge
ml RepeatModeler/2.0.3-Miniconda3

# -pa = parellel search - each pa uses 4 cpu
RepeatModeler -database $species -pa 16 -LTRStruct
wait
date
