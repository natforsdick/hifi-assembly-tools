#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=kaki-asm3-pur-yahs # job name (shows up in the queue)
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G
#SBATCH --time=00:20:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

################################
# Created 2020-11-26 by Nat Forsdick
# Passing aligned HiC Weta data to YAHS scaffolding genome assemblies
################################

REF_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/'
REF='01P-asm3-hic-hifiasm-p-p_ctg-purged.fa'
echo “Making FAI from reference assembly”
cd $REF_DIR
if [ ! -e ${REF_DIR}${REF}.fai ]; then
	echo "indexing ${REF_DIR}${REF}"
	module purge
	module load SAMtools/1.10-GCC-9.2.0

	samtools faidx ${REF_DIR}${REF}
	echo  "indexed"
	date
	ml purge
fi

# make output directory prior to running.
YAHS='/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/yahs'
IN_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/05-kaki-sorted/'
IN_BAM='Kaki_HiCmapped_rep1-sorted.bed'
OUT_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/'

if [ ! -e ${OUT_DIR} ]; then
	mkdir -p ${OUT_DIR}
else
	echo "Found ${OUT_DIR}"
fi
cd ${OUT_DIR}

echo "Starting YAHS for ${IN_BAM} to scaffold ${REF}"
date

$YAHS ${REF_DIR}${REF} ${IN_DIR}${IN_BAM} -o 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahsNMC --no-mem-check

echo "Completed YAHS scaffolding"
date
