#!/bin/bash -e
#SBATCH --account ga03186
#SBATCH --job-name 01-make-meryl
#SBATCH --time 00:02:00 # could need a couple of hours per fastq
#SBATCH --mem=1G # will prob need at least 24
#SBATCH --cpus-per-task=4
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err
#SBATCH --profile=task

k=21
genome=kaki
indir=/nesi/nobackup/ga03048/correction/trimmomatic/
outdir=/nesi/nobackup/ga03048/assemblies/hifiasm/05-merqury/

cd $outdir

# loop for whole data set
# for file in `ls *P.fastq.gz`
for file in ${indir}H07456-L1_S1_L001_R1_001.fastq_trimmed_1P.fastq.gz
do
    filename=$(basename "$file") 
    filename=${filename%.*} 
    filename=${filename%.*}
    echo $filename
    meryl threads=$SLURM_CPUS_PER_TASK memory=$SLURM_MEM_PER_NODE k=$k count output ${outdir}${filename}.meryl ${indir}${filename}.fastq.gz

done

# 2. Merge
#meryl union-sum output ${genome}.meryl *.meryl
