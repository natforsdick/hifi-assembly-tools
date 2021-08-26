#!/bin/bash -e

# Purge_dups pipeline
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
PRE=asm2-hifiasm-p # PREFIX
PRI=p_ctg
ALT=a_ctg
R1=01P-
R2=02P- # Designate cutoffs round - either default (01) or modified (02) and whether Primary or Alternate assembly
##########

cd $OUTDIR

# Step 04a: Purge haplotigs and overlaps
${PURGE_DUPS}purge_dups -2 -T ${R2}${PRE}-cutoffs -c ${R1}${PRE}-PB.base.cov \
${ROUND}${PRE}.split.self.paf.gz > ${R2}${PRE}-dups.bed 2> ${R2}${PRE}-purge_dups.log

# Step 04b: Get purged primary and haplotig sequences from draft assembly
${PURGE_DUPS}get_seqs -e ${R2}${PRE}dups.bed ${INDIR}${PRI}.fa

