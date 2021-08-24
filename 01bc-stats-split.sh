#!/bin/bash -e

# 01bc-stats-split.sh
# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# Purge_dups pipeline
# Calculate read-depth histogram and base-level read-depth.
# Split the assembly.
# Takes a negligible amount of resource, so can be run without SLURM wrapper.

INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm1-Canu/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm1-Canu/purge_dups
PURGE_DUPS=/nesi/nobackup/ga03186/purge_dups/bin/

cd $OUTDIR

# Produce PB.base.cov and PB.stat files
${PURGE_DUPS}pbcstat ${OUTDIR}kaki-hifi-to-asm1-Canu.paf.gz

${PURGE_DUPS}calcuts ${OUTDIR}PB.stat > cutoffs 2> ${OUTDIR}calcults.log

${PURGE_DUPS}split_fa ${INDIR}kaki-asm.contigs.fasta > ${OUTDIR}kaki-asm.contigs.split
