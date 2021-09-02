#!/bin/bash -e

#SBATCH --job-name=minimap-aln
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=00:30:00
#SBATCH --mem=16G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=14

# align-genomes.sl
# Align genomes to one another using minimap
# Nat Forsdick, 2021-09-01

# Takes 1 argument: $1: focal genome fasta.
 
#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 
#########

echo Aligning $1 against reference

cd /nesi/nobackup/ga03186/kaki-hifi-asm/asm-stats/alignments/

# To index reference genome the first time you run this - can then just call the index ref.mmi following this
#minimap2 -t $SLURM_CPUS_PER_TASK -d ref.mmi /nesi/project/ga03048/data/kaki/Kaki1_v2.3_head.fasta
minimap2 -ax asm5 -t $SLURM_CPUS_PER_TASK ref.mmi $1 > aln.sam

$HOME/bin/k8 /nesi/project/ga03186/HiFi-scripts/paftools.js stat aln.sam > ${1}-aln-stat.out
