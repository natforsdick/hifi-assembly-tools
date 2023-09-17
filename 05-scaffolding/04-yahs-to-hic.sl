#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=make-juice-in # job name (shows up in the queue)
#SBATCH --cpus-per-task=8
#SBATCH --mem=36G
#SBATCH --time=08:00:00 #Walltime (HH:MM:SS)
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err 

# Generating .hic file for visualisation and manual curation

##########
# PARAMS #
YAHSJUICE=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/
JUICER="java -Xmx30G -jar /nesi/project/ga03186/scripts/Hi-C_scripts/juicer_tools_1.22.01.jar pre"
REFDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/
REF=01P-asm3-hic-hifiasm-p-p_ctg-purged.fa
OUT=01P-asm3-hic-hifiasm-p-p_ctg-purged-yahsNMC
##########

cd $OUTDIR
echo making JBAT
$YAHSJUICE pre -a -o ${OUT}_JBAT ${OUT}.bin ${OUT}_scaffolds_final.agp ${REFDIR}${REF}.fai 2>tmp_juicer_pre_JBAT.log

echo making chrom.sizes
cat tmp_juicer_pre_JBAT.log | grep "PRE_C_SIZE" | cut -d' ' -f2- >${OUT}_JBAT.chrom.sizes

echo making .hic
${JUICER} ${OUT}_JBAT.txt ${OUT}_JBAT.hic.part ${OUT}_JBAT.chrom.sizes 

# mv ${OUT}_JBAT.hic.part ${OUT}_JBAT.hic
echo completed
