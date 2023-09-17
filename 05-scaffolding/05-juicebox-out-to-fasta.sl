#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=JBATout-fasta # job name (shows up in the queue)
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --time=01:15:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

# PARAMS #
INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/
REFDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/
REF=01P-asm3-hic-hifiasm-p-p_ctg-purged.fa

ml Python/3.10.5-gimkl-2022a LASTZ/1.04.03-GCC-9.2.0

cd $INDIR
bash /nesi/nobackup/ga03048/modules/3d-dna/run-asm-pipeline-post-review.sh \
-r 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahs_out-JBAT.review.assembly $REFDIR$REF out_JBAT.txt
