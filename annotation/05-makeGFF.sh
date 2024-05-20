#!/bin/bash

# converting masked outputs to GFF3 format
toGFF=/nesi/project/ga03186/kaki-genome-assembly/annotation/
cd /nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/annotation/repeats/masking/05_full_out/
REF=asm3-hic-hifiasm-p-p_ctg-purged_rep1_scaffolds_final.contam-excl

# use Daren's custom script to convert .out to .gff3 for all repeats, simple repeats only, and complex repeats only
${toGFF}rmOutToGFF3custom -o ${REF}.full_mask.out > ${REF}.full_mask.gff3
${toGFF}rmOutToGFF3custom -o ${REF}.simple_mask.out > ${REF}.simple_mask.gff3
${toGFF}rmOutToGFF3custom -o ${REF}.complex_mask.out > ${REF}.complex_mask.gff3
