#!/bin/bash -e

#SBATCH -A ga03186
#SBATCH -J pbccs-hifi
#SBATCH --time 10:00:00 # initial test: 10hr
#SBATCH --mem 80G 
#SBATCH --cpus-per-task 36
#SBATCH --error=%x.%j.err
#SBATCH --out=%x.%j.out
#SBATCH --profile=task

# 00-extract-ccs-hifi.sl
# Nat Forsdick, 2022-04-08
# script for generating ccs and hifi reads from PacBio bam files

##########
# MODULES
module purge
module load Anaconda3
source activate pacbio # env containing pbccs, extract-hifi, zmwfilter tools
##########

##########
# PARAMS
INDIR=/nesi/nobackup/ga03186/kaki-pacbio-data/
INBAM=m54349U_210221_005741.subreads.bam
##########

cd $INDIR
filename=$(basename "$INBAM")
filename=${filename%.*.*}

# Generating CCS reads from raw PacBio subreads file
for i in {1..1} # inital test with one chunk, then can do {2..6} - or could run it as an array
do
echo "Starting ccs at"
date
ccs ${INBAM} ${filename}.ccs.${i}.bam --chunk ${i}/6 -j 24
echo "completed ${i} at"
date
done

#module load SAMtools

# Merging chunked CCS reads 
#samtools merge -@24 ${filename}.ccs.bam ${filename}.ccs.bam

# extract HiFi reads (>=Q20)
#extracthifi ${filename}.ccs.bam ${filename}.hifi.bam
# convert bam to fq and compress
#samtools bam2fq ${filename}.hifi.bam | gzip -c > ${filename}.hifi.fastq.gz

