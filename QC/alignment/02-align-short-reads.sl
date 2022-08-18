#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J map-reads
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=30G
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err

# 02-align-short-reads.sl
# Nat Forsdick, 2022-08-17
# Mapping Illumina short-reads to an assembly and gathering stats  

##############
# ENVIRONMENT

asm=/nesi/nobackup/ga03186/assemblies/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/05_kaki_SalsaScaff/yahs/yahs-asm3_scaffolds_final.fa

outdir=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-bwa/

fq1=H01392-L1_S7_L005_R1_001.fastq
fq2=H01392-L1_S7_L005_R2_001.fastq

HiFi=m54349U_210221_005741.fastq

###############
# MODULES
ml BWA/0.7.17-GCC-9.2.0 SAMtools/1.13-GCC-9.2.0 
################

cd ${outdir}

#index the reference fasta file
echo Beginning mapping pipeline at 
date
if [ ! -e $asm.amb ]; then
echo "Index file of reference does not exist: creating index with BWA at "
date
bwa index $asm
else
echo BWA Index file found
fi

# unzip data if necessary
if [ ! -e ${fq1} ] || [ ! -e ${fq2} ]; then
echo Unzipping fastq files at 
date
gunzip ${fq1}.gz
gunzip ${fq2}.gz
fi

if [ ! -e ${HiFi} ]; then
echo Unzipping fastq files at 
date
gunzip ${HiFi}.gz
fi

# map paired
bwa mem -t 32 $asm ${fq1} ${fq2} | samtools view -T $asm -C - > out.paired.cram

# map hifi
bwa mem -t 32 -x pacbio $asm ${HiFi} | samtools view -T $asm -C - > out.hifi.cram

echo "mapping completed"
date

# merge all mapped (let's see if this is possible)
samtools merge --reference $assembly -O CRAM --threads 32 merged.cram out.paired.cram out.hifi.cram

samtools view --threads 32 hT $asm merged.cram | samtools sort --reference $asm --threads 32 -O CRAM -l 9 -o kaki-asm3-mapped.cram -

samtools index kaki-asm3-mapped.cram

samtools stats --reference $asm --threads 32 kaki-asm3-mapped.cram > kaki-asm3-mapped.stats

samtools flagstat --threads 32 kaki-asm3-mapped.cram > kaki-asm3-mapped.flagstats

samtools idxstats --threads 32 kaki-asm3-mapped.cram > kaki-asm3-mapped.idxstats

echo "stats gathered; pipeline completed"
date
