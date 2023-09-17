#!/bin/bash -e
# Generating .hic file for visualisation and manual curation

##########
# PARAMS #
#YAHSJUICE=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
JUICER=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
REFDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/

cd $OUTDIR
# -o = output prefix, followed by input review.assembly, input liftover.agp, reference
$JUICER post -o 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahs_out-JBAT 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahs_out-JBAT.review.assembly 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahs_JBAT.liftover.agp ${REFDIR}01P-asm3-hic-hifiasm-p-p_ctg-purged.fa
