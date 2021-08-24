#!/bin/bash -e

#SBATCH --job-name=make-paf
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=02:00:00
#SBATCH --mem=10G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=16


module purge

module load minimap2/2.20-GCC-9.2.0 

INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm1-Canu/
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm1-Canu/purge_dups/
DATA=/nesi/project/ga03186/data/JF_PacBio-kaki-Steeves-Order260/processed/

cd $OUTDIR

minimap2 -x map-hifi -t $SLURM_CPUS_PER_TASK ${INDIR}kaki-asm.contigs.fasta ${DATA}m54349U_210221_005741.fastq | gzip -c - > kaki-hifi-to-asm1-Canu.paf.gz

