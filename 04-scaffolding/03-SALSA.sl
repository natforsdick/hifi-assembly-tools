#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=KakiSALSA-asm5 # job name (shows up in the queue)
#SBATCH --cpus-per-task=2
#SBATCH --mem=6G
#SBATCH --time=00:45:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

################################
# Created 2020-11-26 by Nat Forsdick
# Passing aligned HiC kaki data to SALSA for assembly and error correction with the existing assembly
################################

# Following Weta HiC test - can scale down mem to 6G, time to 1 hr, 4 cpus.
module purge
module load Python/2.7.16-gimkl-2018b

# make output directory prior to running.
SALSA='/nesi/project/ga03048/modules/SALSA/run_pipeline.py'
REF_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm5-masurca/01-purge-dups/'
REF='01-primary.genome.scf-purged.fa'
IN_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm5-masurca/SALSA/04_kaki_dedup/'
IN_BED='Kaki_HiCmapped_rep1-sorted.bed'
OUT_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm5-masurca/SALSA/05_kaki_SalsaScaff/'

if [ ! -e ${OUT_DIR} ]; then
	mkdir -p ${OUT_DIR}
else
	echo "Found ${OUT_DIR}"
fi

echo "Starting SALSA for ${IN_BED} to scaffold ${REF}"
date

python ${SALSA} -a ${REF_DIR}${REF} -l ${REF_DIR}${REF}.fai -b ${IN_DIR}${IN_BED} -o ${OUT_DIR} -m yes

echo "Completed SALSA scaffolding"
date
