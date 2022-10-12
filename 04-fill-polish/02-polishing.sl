#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J kaki-polish
#SBATCH --cpus-per-task=36
#SBATCH --mem=32G
#SBATCH --partition=large
#SBATCH --time=02:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err
#SBATCH --profile=task

# 02-polishing.sl
# Assembly polishing with redbean (wtdbg) using long-reads

##########
# PARAMS #
asmdir=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/03-fill-polish/pur-yahs/01-TGSGC/
fo=asm3-pur-yahs-TGC.scaff_seqs #w/out .fa suffix
datadir=/nesi/project/ga03186/data/JF_PacBio-kaki-Steeves-Order260/processed/
outdir=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/03-fill-polish/pur-yahs/02-pol/
##########

##########
# ENV
ml purge
ml wtdbg/2.5-GCC-9.2.0 BWA/0.7.17-GCC-9.2.0 \
SAMtools/1.13-GCC-9.2.0 minimap2/2.20-GCC-9.2.0
##########

if [ ! -e ${outdir} ]; then
	mkdir -p $outdir
fi

cd $outdir

date
echo "minimap2 -I 24G -t $SLURM_CPUS_PER_TASK -ax map-hifi -r2k ${asmdir}${fo}.fa ${datadir}*.fastq.gz |\
samtools sort -@4 -o ${fo}.bam"
minimap2 -I 24G -t $SLURM_CPUS_PER_TASK -ax map-hifi -r2k ${asmdir}${fo}.fa ${datadir}*.fastq.gz |\
samtools sort -@4 -o ${fo}.bam

date
echo "samtools view -F0x900 ${fo}.bam | wtpoa-cns -t $SLURM_CPUS_PER_TASK \
-d ${asmdir}${fo}.fa -i - -fo ${fo}.pol-cns.fa"
samtools view -F0x900 ${fo}.bam | wtpoa-cns -t $SLURM_CPUS_PER_TASK \
-d ${asmdir}${fo}.fa -i - -fo ${fo}.pol-cns.fa

date
echo "bwa index ${fo}.pol-cns.fa"
bwa index ${fo}.pol-cns.fa

