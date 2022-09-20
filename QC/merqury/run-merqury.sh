#!/bin/bash -e 

#SBATCH -A ga03186
#SBATCH -J merqury
#SBATCH --mem=5G
#SBATCH -c 28
#SBATCH --time=00:15:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --profile=task

# run-merqury.sl
# N Forsdick, 2022-04-05
# Takes 2 params: $1 = asmdir (must include final /), $2 = primary asm

##########
# PARAMS #
##########
genome=kaki
outdir=/nesi/nobackup/ga03186/kaki-hifi-asm/asm-stats/merqury/
asmdir=$1
asm1=$2 # PRI
##########

cd $outdir

asmname=$(basename "$asm1")
asmname=${asmname%.*}

mkdir -p ${asmname}-merqury
cd ${asmname}-merqury

echo "$1 $2"

if [ -L ${asm1} ]; then
	echo "${asm1} found"
	else
		ln -s ${asmdir}${asm1} ${asm1}
    		ln -s ${asmdir}${asm2} ${asm2}
fi

module purge
module load R/4.1.0-gimkl-2020a BEDTools/2.29.2-GCC-9.2.0 SAMtools/1.13-GCC-9.2.0

$MERQURY/merqury.sh ../${genome}.meryl ${asm1} ${asmname}-merqury
