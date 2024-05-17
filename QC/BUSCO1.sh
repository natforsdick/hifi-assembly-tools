#!/bin/bash -e

###################
# BUSCO - 2020-12-13
# Nat Forsdick
###################

# Load modules
module purge
module load BUSCO/5.6.1-gimkl-2022a
#cp -r $AUGUSTUS_CONFIG_PATH ./MyAugustusConfig

# Set up environment
#export AUGUSTUS_CONFIG_PATH=/nesi/project/ga03048/scripts/QC/MyAugustusConfig
#export BUSCO_CONFIG_FILE="/nesi/project/ga03048/scripts/config.ini"

OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm-stats/
INDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/yahs/
samplist='asm3-hic-hifiasm-p-p_ctg-purged_rep1_scaffolds_final.fa' # e.g., 'weta-hic-hifiasm.cns.fa'
INDB=/nesi/project/ga03186/aves_odb10

for samp in $samplist
do

filename=$(basename "$samp")
filename=${filename%.*}

cd $OUTDIR

echo "Starting BUSCO for ${samp}"
# -f = force, -r = restart
	busco -i ${INDIR}${samp} -o BUSCO5_${filename} -f --offline -l ${INDB} -m geno -c 24
	echo "Finished BUSCO for ${samp}"
done

# To make BUSCO plots:
# ml BUSCO/5.2.2-gimkl-2020a R/4.1.0-gimkl-2020a
# generate_plot.py -wd ./


