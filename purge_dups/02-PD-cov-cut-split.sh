#!/bin/bash -e

# Purge_dups pipeline
# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# step 02: calculate read depth histogram and base-level read depth, generate default cutoffs, split the assembly
# Takes one argument: PRI or ALT

#########
# PARAMS
INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/purge_dups/
PURGE_DUPS=/nesi/nobackup/ga03186/purge_dups/bin/
PRE=asm2-hifiasm-p # PREFIX
PRI=p_ctg
ALT=a_ctg
R1=01P- # Designate cutoffs round - either default (01) or modified (02) and whether Primary or Alternate assembly
R2=02P-
#########

cd $OUTDIR

if [ "$1" == "PRI" ]; then 
# step 02a: Produce PB.base.cov and PB.stat files
${PURGE_DUPS}pbcstat ${R1}${PRE}-${PRI}-mapped.paf.gz

## step 02b: generate default cutoffs
${PURGE_DUPS}calcuts ${R1}${PRE}-${PRI}-PB.stat > ${R1}${PRE}-${PRI}-cutoffs 2> ${R1}${PRE}-${PRI}-calcults.log

## step 02c: split the assembly 
${PURGE_DUPS}split_fa ${INDIR}${PRE}.${PRI}.fa > ${R1}${PRE}-${PRI}.split

elif [ "$1" == "ALT" ]; then
  ${PURGE_DUPS}pbcstat ${R1}${PRE}-${ALT}-merged-mapped.paf.gz
  
  ${PURGE_DUPS}calcuts ${R1}${PRE}-${ALT}-PB.stat > ${R1}${PRE}-${ALT}-cutoffs 2> ${R1}${PRE}-${ALT}-calcults.log

  ${PURGE_DUPS}split_fa ${INDIR}${R1}${PRE}.${ALT}.fa > ${R1}${PRE}-${ALT}.split
fi
