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
INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm1-Canu/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm1-Canu/purge_dups/
PURGE_DUPS=/nesi/nobackup/ga03186/purge_dups/bin/
##########

cd $OUTDIR

# Step 02
${PURGE_DUPS}purge_dups -2 -T cutoffs -c PB.base.cov \
${OUTDIR}kaki-asm.contigs.split.self.paf.gz > dups.bed 2> purge_dups.log

# Step 03
${PURGE_DUPS}get_seqs -e dups.bed ${INDIR}kaki-asm.contigs.fasta 
