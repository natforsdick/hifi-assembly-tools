#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J liftoff
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G
#SBATCH -t 00:20:00
#SBATCH --out %x.%j.out
#SBATCH --err %x.%j.err

# Liftoff for genome annotation from a reference
# Nat Forsdick, 2024-02-23

# PARAMS
INDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/yahs/
TARGET=asm3-hic-hifiasm-p-p_ctg-purged_rep1_scaffolds_final
OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/annotation/vHimantopus/
REFDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/reference/GCA_013400095.1-himHima-dataset/
REF=himHima_GCA_013400095.1_genomic

ml purge; ml Liftoff/1.6.3.2-gimkl-2022a-Python-3.11.3

mkdir -p $OUTDIR
cd $OUTDIR

# p=threads, -g = reference GFF, -o location of GFF file from reference, then our target assembly, then ref assembly.
# -polish to realign exons for preserving proper CDS annotations
liftoff -p 16 -polish -g ${REFDIR}${REF}.gff \
-o ${TARGET}-${REF}.gff \
${INDIR}${TARGET}.fa ${REFDIR}${REF}.fna

ml purge
