#!/bin/bash -e 

#SBATCH -A ga03186
#SBATCH -J merqury
#SBATCH --mem=6G
#SBATCH -c 24
#SBATCH --time=00:15:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --profile=task

# run-merqury.sl
# N Forsdick, 2022-04-05

##########
# PARAMS #
##########
genome=kaki
outdir=/nesi/nobackup/ga03186/kaki-hifi-asm/asm-stats/merqury/
asmdir=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/03-polishing/round-2/
asm=01P-asm3-hic-hifiasm-p-p_ctg-purged.cns.pol2.fa
##########

cd $outdir

asmname=$(basename "$asm")
asmname=${asmname%.*}

if [ -e "$asm" ]; then
	echo "${asm} exists"
else
	ln -s ${asmdir}${asm} ${asm}
fi

mkdir -p ${asmname}-merqury
cd ${asmname}-merqury

module purge
module load R/4.1.0-gimkl-2020a BEDTools/2.29.2-GCC-9.2.0 SAMtools/1.13-GCC-9.2.0

$MERQURY/merqury.sh ../${genome}.meryl ../${asm} ${asmname}-merqury
