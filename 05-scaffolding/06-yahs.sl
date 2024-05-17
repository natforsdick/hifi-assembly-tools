#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=yahs # job name (shows up in the queue)
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G # 6G limit without -nmc
#SBATCH --time=01:30:00 #Walltime (HH:MM:SS) # under 30 min without -nmc
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

################################
# Created 2020-11-26 by Nat Forsdick
# Passing aligned HiC Kakī data to YAHS scaffolding genome assemblies
################################

REF_DIR='/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/'
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
IN_DIR='/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/04_kaki_dedup/'
IN_BAM='asm3-hic-hifiasm-p-p_ctg-purged_rep1.bam'
OUT_DIR='/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/yahs/'

if [ ! -e ${OUT_DIR} ]; then
	mkdir -p ${OUT_DIR}
else
	echo "Found ${OUT_DIR}"
fi
cd ${OUT_DIR}

echo "Starting YAHS for ${IN_BAM} to scaffold ${REF}"
date

$YAHS ${REF_DIR}${REF} ${IN_DIR}${IN_BAM} -o asm3-hic-hifiasm-p-p_ctg-purged_rep1 --no-mem-check

echo "Completed YAHS scaffolding"
date
