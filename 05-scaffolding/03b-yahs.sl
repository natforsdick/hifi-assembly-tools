#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=Kaki-asm5-yahs # job name (shows up in the queue)
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G
#SBATCH --time=00:10:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

################################
# Created 2020-11-26 by Nat Forsdick
# Passing aligned HiC Weta data to YAHS scaffolding genome assemblies
################################

# make output directory prior to running.
YAHS='/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/yahs'
REF_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm5-masurca/01-purge-dups/'
REF='01-primary.genome.scf-purged.fa'
IN_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm5-masurca/SALSA/04_kaki_dedup/'
IN_BAM='Kaki_HiCmapped_rep1-sorted.bed'
OUT_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm5-masurca/SALSA/05_kaki_SalsaScaff/'

if [ ! -e ${OUT_DIR} ]; then
	mkdir -p ${OUT_DIR}
else
	echo "Found ${OUT_DIR}"
fi
cd ${OUT_DIR}

echo "Starting YAHS for ${IN_BAM} to scaffold ${REF}"
date

$YAHS ${REF_DIR}${REF} ${IN_DIR}${IN_BAM} -o yahs-asm5

echo "Completed YAHS scaffolding"
date
