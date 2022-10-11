#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J make.hic
#SBATCH --time=03:00:00
#SBATCH -c 16
#SBATCH --mem=28G
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err
#SBATCH --profile=task

################
# Make .hic file from HiC-scaffolded genome assembly (fasta)
# Nat Forsdick, 2020-12-09
###############
# Load modules
module purge
#module load Python/3.6.3-gimkl-2017a

###############
# PARAMS
# We have an .agp file as output from HiC scaffolding with YAHS
# We want to produce a .hic file to pass to Juicebox (desktop) for visualisation

# Specify directories and files
agp2assembly='/nesi/project/ga03048/modules/juicebox_scripts/juicebox_scripts/agp2assembly.py'
matlock='/nesi/project/ga03048/modules/matlock/bin/matlock'
visualise='bash /nesi/project/ga03048/modules/3d-dna/visualize/run-assembly-visualizer.sh'
IN_PREFIX='scaffolds_FINAL'
IN_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/05_kaki_SalsaScaff/'
OUT_DIR='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/05_kaki_SalsaScaff/post-processing/'
IN_BAM='/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/01_kaki_mapped/Kaki_HiC_raw_all_R.bam'
OUT_PREFIX='asm3-yahs-scaffolds-final'
##############

# Step 1 - Make .assembly file from .agp file
echo "Starting Step 1 - Make .assembly file from .agp file"
python ${agp2assembly} ${IN_DIR}${IN_PREFIX}.agp ${IN_DIR}${IN_PREFIX}.assembly 

# Step 2 - Make .hic from BAM + .assembly files
echo "Starting Step 2 - Make .hic from BAM + .assembly files"
# this BAM file should represent Hi-C reads mapped against starting contigs!
# This step requires matlock, found at bin/matlock
#module purge

if [ ! -e ${OUT_DIR} ]; then
mkdir ${OUT_DIR}
fi

cd ${OUT_DIR}

echo "sorting bam"
module load SAMtools/1.10-GCC-9.2.0
samtools sort -@ 12 -n ${IN_BAM} -o ${OUT_DIR}${OUT_PREFIX}_sorted.bam

echo "running matlock"
module purge
module load GSL/2.6-GCCcore-9.2.0 gimkl/2020a bzip2/1.0.8-GCCcore-9.2.0
${matlock} bam2 juicer ${OUT_DIR}${OUT_PREFIX}_sorted.bam ${OUT_PREFIX}.links.txt  
# this step sometimes crashes on memory

echo "sorting links"
sort -k2,2 -k6,6 ${OUT_PREFIX}.links.txt > ${OUT_PREFIX}.sorted.links.txt

echo "making .hic"
# Final step requires a script from the 3d-dna project - https://github.com/aidenlab/3d-dna
${visualise} -p false ${IN_DIR}${IN_PREFIX}.assembly ${OUT_DIR}${OUT_PREFIX}.sorted.links.txt 
# creates a .hic file
echo "completed making .hic"
