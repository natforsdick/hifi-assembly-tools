#!/bin/bash -e

ml purge 
ml SAMtools/1.15.1-GCC-11.3.0 BWA/0.7.17-GCC-11.3.0

INDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/
REF=01P-asm3-hic-hifiasm-p-p_ctg-purged # prefix
OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/

cd $OUTDIR

ln -s ${INDIR}${REF}.fa ${OUTDIR}${REF}.fa

samtools faidx $REF.fa

cut -f1,2 $REF.fa.fai > $REF.genome

bwa index $REF.fa
