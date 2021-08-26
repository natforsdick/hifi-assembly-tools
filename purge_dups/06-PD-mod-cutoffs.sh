#!/bin/bash -e

# Purge_dups pipeline
# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# step 06: modify cutoffs

##########
# PARAMS
PURGE_DUPS=/nesi/nobackup/ga03186/purge_dups/bin/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm2-hifiasm-p/purge_dups/
PRE=asm2-hifiasm-p # PREFIX
PRI=p_ctg
ALT=a_ctg
ROUND=02P- # Designate cutoffs round - either default (01) or modified (02) and whether Primary or Alternate assembly
##########

${PURGE_DUPS}calcuts -m 16 -u 63 01P-${PRE}-PB.stat > ${ROUND}${PRE}-cutoffs

# Following this, you need to run steps 04-07 with $ROUND modified for new cutoffs.
