#!/bin/bash -e

#SBATCH --job-name=minimap-HiFi
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=01:30:00
#SBATCH --mem=60G # 6G
#SBATCH --ntasks=1
#SBATCH --profile=task
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=36
#SBATCH --profile=task

# align-HiFi.sl
# Align HiFi reads to a reference using minimap for input to blob tools
# Nat Forsdick, 2021-10-28

# Based on subsamp of 60,000 HiFi reads taking 2 min to map (incl. initial indexing),
# should take 45 min to map all HiFi data.

#########
# MODULES
module purge && module load minimap2/2.20-GCC-9.2.0 SAMtools/1.13-GCC-9.2.0
#########

#########
# PARAMS
#########
DIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/
REFDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/
REF=01P-asm3-hic-hifiasm-p-p_ctg-purged-yahs_scaffolds_final
HIFIDIR=/nesi/project/ga03186/data/JF_PacBio-kaki-Steeves-Order260/processed/
HIFI=m54349U_210221_005741.fastq.gz
#########

cd $DIR

echo Indexing ${REF}

# To index reference genome the first time you run this - can then just call the index ref.mmi following this
minimap2 -t $SLURM_CPUS_PER_TASK -d ${REF}.mmi ${REFDIR}${REF}.fa

echo Aligning ${HIFI} against ${REF}
# To map HiFi reads to assembly
minimap2 -ax map-hifi -t $SLURM_CPUS_PER_TASK ${REF}.mmi ${HIFIDIR}${HIFI} | samtools sort -@ $SLURM_CPUS_PER_TASK -O BAM -o ${REF}-hifi.bam -

echo getting stats
samtools coverage ${REF}-hifi.bam -o ${REF}-hifi-cov.txt
samtools stats -@ 12 ${REF}-hifi.bam > ${REF}-hifi-stats.txt

echo plotting stats
plot-bamstats -p ${REF}-hifi-stats ${REF}-hifi-stats.txt

echo completed minimap2 pipeline for blobtools
