#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=JBAT2fasta # job name (shows up in the queue)
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=00:30:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err 

# Generating .hic file for visualisation and manual curation

##########
# PARAMS #
#YAHSJUICE=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
JUICER=/nesi/nobackup/ga03186/yahs/juicer
CONTIGS=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/05_kaki_SalsaScaff/yahs/juice/

cd $OUTDIR

$JUICER post -o 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahs-out_JBAT out_JBAT-1stpass.review.assembly out_JBAT.liftover.agp ${CONTIGS}01P-asm3-hic-hifiasm-p-p_ctg-purged.fa
