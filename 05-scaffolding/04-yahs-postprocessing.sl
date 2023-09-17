#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=make-juice-in # job name (shows up in the queue)
#SBATCH --cpus-per-task=4
#SBATCH --mem=26G
#SBATCH --time=01:30:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err 

# Generating .hic file for visualisation and manual curation

##########
# PARAMS #
YAHSJUICE=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/
JUICER=/nesi/nobackup/ga03048/juicer/scripts/juicer_tools.1.9.9_jcuda.0.8.jar
REF_DIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/
REF=01P-asm3-hic-hifiasm-p-p_ctg-purged.fa
##########

cd $OUTDIR

echo 'generating hic contact map'
$YAHSJUICE pre -a -o out_JBATNMC 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahsNMC.bin 01P-asm3-hic-hifiasm-p-p_ctg-purged-yahsNMC_scaffolds_final.agp \
${REF_DIR}${REF}.fai > out_JBATNMC.log 2>&1
echo done step 1

echo 'running juicer_tools pre'
java -jar -Xmx26G $JUICER pre out_JBATNMC.txt out_JBATNMC.hic.part \
	<(cat out_JBATNMC.log | grep PRE_C_SIZE | awk '{print $2" "$3}')

mv out_JBATNMC.hic.part out_JBATNMC.hic

echo done step 2


