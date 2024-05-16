#!/bin/bash -e 

#SBATCH -A ga03186
#SBATCH -J merqury
#SBATCH --mem=5G
#SBATCH -c 28
#SBATCH --time=00:15:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

# run-merqury.sl
# N Forsdick, 2022-04-05
# Takes 2 params: $1 = asmdir (must include final /), $2 = primary asm

##########
# PARAMS #
##########
genome=kaki
outdir=/nesi/nobackup/ga03048/kaki-hifi-asm/asm-stats/merqury/
asmdir=$1
asm1=$2 # PRI
##########

cd $outdir

asmname=$(basename "$asm1")
asmname=${asmname%.*}

mkdir -p ${asmname}-merqury
cd ${asmname}-merqury

echo "$1 $2"

module purge
module load Merqury/1.3-Miniconda3
export MERQURY=/opt/nesi/CS400_centos7_bdw/Merqury/1.3-Miniconda3/merqury/

merqury.sh ../${genome}.meryl ${asmdir}${asm1} ${asmname}-merqury
