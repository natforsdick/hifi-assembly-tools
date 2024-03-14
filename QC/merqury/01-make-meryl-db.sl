#!/bin/bash -e
#SBATCH --account ga03186
#SBATCH --job-name make-meryl
#SBATCH --time 03:00:00 # could need a couple of hours per fastq
#SBATCH --mem=40G # will prob need at least 24
#SBATCH --cpus-per-task=28
#SBATCH --array=0-1
#SBATCH --output %x.%A.%a.out
#SBATCH --error %x.%A.%a.err
#SBATCH --profile=task

##########
# PARAMS #
##########
k=20
genome=kaki
indir=/nesi/project/ga03186/data/HiSeq-kaki-DNA1565/trimmomatic/
outdir=/nesi/nobackup/ga03048/kaki-hifi-asm/asm-stats/merqury/
##########
mkdir -p $outdir
cd $indir

ml purge
ml Merqury/1.3-Miniconda3

# call samplist from file, and pass to array
SAMPLE_LIST=($(<${indir}input-fastq-list.txt))
SAMPLE=${SAMPLE_LIST[${SLURM_ARRAY_TASK_ID}]}

filename=$(basename "$SAMPLE") 
filename=${filename%.*} 
filename=${filename%.*}
echo $filename

meryl threads=$SLURM_CPU_PER_TASK memory=$SLURM_MEM_PER_NODE k=$k count output ${outdir}${filename}.meryl ${indir}${filename}.fastq.gz
date 
