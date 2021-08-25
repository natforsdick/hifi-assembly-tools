#!/bin/bash -e

# 02-purge-haplotigs-overlaps.sh
# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# Purge_dups pipeline
# Purge haplotigs and overlaps
# Get purged primary and haplotig sequences from draft assembly

##########
# PARAMS
##########
INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/purge_dups/
PURGE_DUPS=/nesi/nobackup/ga03186/purge_dups/bin/
PRI=asm2-hifiasm-p.p_ctg
##########

cd $OUTDIR

# Step 02
${PURGE_DUPS}purge_dups -2 -T cutoffs -c PB.base.cov \
${OUTDIR}${PRI}.split.self.paf.gz > dups.bed 2> purge_dups.log

# Step 03
${PURGE_DUPS}get_seqs -e dups.bed ${INDIR}${PRI}.fa 
