#!/bin/bash
#SBATCH --account=ga03186
#SBATCH --job-name=make-juice-in # job name (shows up in the queue)
#SBATCH --cpus-per-task=8
#SBATCH --mem=34G
#SBATCH --time=08:00:00 #Walltime (HH:MM:SS)
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err 

# Generating .hic file for visualisation and manual curation

##########
# PARAMS #
YAHSJUICE=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
OUTDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/06-kaki-yahs/
JUICER="java -Xmx32G -jar /nesi/project/ga03186/scripts/Hi-C_scripts/juicer_tools_1.9.9_jcuda.0.8.jar pre"
REFDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/02-purge-dups/
REF=01P-asm3-hic-hifiasm-p-p_ctg-purged.fa
OUT=01P-asm3-hic-hifiasm-p-p_ctg-purged-yahs
BED=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/05-SALSA/pur/05-kaki-sorted/Kaki_HiCmapped_rep1-sorted.bed
##########

cd $OUTDIR
echo making JBAT
$YAHSJUICE pre -a -o ${OUT}_JBAT ${BED} ${OUT}_scaffolds_final.agp ${REFDIR}${REF}.fai > out_JBAT.log 2>&1

(${JUICER} out_JBAT.txt out_JBAT.hic.part <(cat out_JBAT.log | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv out_JBAT.hic.part out_JBAT.hic)

#echo making chrom.sizes
#cat tmp_juicer_pre_JBAT.log | grep "PRE_C_SIZE" | cut -d' ' -f2- >${OUT}_JBAT.chrom.sizes

#echo making .hic
#${JUICER} ${OUT}_JBAT.txt ${OUT}_JBAT.hic.part ${OUT}_JBAT.chrom.sizes 

# mv ${OUT}_JBAT.hic.part ${OUT}_JBAT.hic
echo completed
