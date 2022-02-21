#!/bin/bash -e

#SBATCH --job-name=minimap-aln
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=00:12:00
#SBATCH --mem=26G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=32

# align-genomes.sl
# Align genomes to one another using minimap
# Nat Forsdick, 2021-09-01

#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 
#########

INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/01-purge-dups/
QUERY=01P-asm3-hic-hifiasm-p-p_ctg-purged

cd /nesi/nobackup/ga03186/kaki-hifi-asm/genome-to-genome/

echo Aligning $QUERY against reference genome

# To index reference genome the first time you run this - can then just call the index ref.mmi following this
#minimap2 -t $SLURM_CPUS_PER_TASK -d ref.mmi /nesi/project/ga03048/data/kaki/Kaki1_v2.3_head.fasta
minimap2 -ax asm5 -t $SLURM_CPUS_PER_TASK ref.mmi ${INDIR}${QUERY}.fa > Kaki1v2.3-${QUERY}.paf

$HOME/bin/k8 /nesi/project/ga03186/HiFi-scripts/paftools.js stat Kaki1v2.3-${QUERY}.paf > Kaki1v2.3-${QUERY}-stat.out
