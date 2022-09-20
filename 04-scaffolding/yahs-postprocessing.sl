#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=make-juice-in # job name (shows up in the queue)
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err 

# Generating .hic file for visualisation and manual curation

##########
# PARAMS #
YAHSJUICE=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/SALSA/05_kaki_SalsaScaff/yahs/juice/
JUICER=/nesi/nobackup/ga03186/juicer/scripts/juicer_tools.1.9.9_jcuda.0.8.jar
##########

cd $OUTDIR

echo 'generating hic contact map'
$YAHSJUICE pre -a -o out_JBAT ../yahs-asm3.bin ../yahs-asm3_scaffolds_final.agp \
/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/asm3-hic-hifiasm-p.p_ctg.fa.fai > out_JBAT.log 2>&1
echo done step 1

echo 'running juicer_tools pre'
java -jar -Xmx32G $JUICER pre out_JBAT.txt out_JBAT.hic.part \
	<(cat out_JBAT.log | grep PRE_C_SIZE | awk '{print $2" "$3}')

mv out_JBAT.hic.part out_JBAT.hic

echo done step 2


