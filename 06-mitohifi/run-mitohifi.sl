#!/bin/bash -e

#SBATCH --job-name=mitoHiFi
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=00:10:00
#SBATCH --mem=3G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=16

# run-mitoHiFi.sl
# Running the MitoHiFi pipeline to assemble a mitogenome from HiFi data
# NF, 2022-10-14

############
# ENV 
ml BLAST/2.6.0-gimkl-2018b
ml CD-HIT/4.8.1-gimkl-2017a
ml SAMtools/1.8-gimkl-2018b
ml hifiasm/0.15.5-GCC-9.2.0
ml minimap2/2.17-GCC-9.2.0
ml MAFFT/7.487-gimkl-2020a-with-extensions

ml Miniconda3/4.12.0
source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.12.0/etc/profile.d/conda.sh
###########

cd /nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/
# -t = threads, -o = organism genetic code for mitogenome annotation
#python /nesi/nobackup/ga03186/CondaEnv/MitoHiFi/mitohifi.py -r "/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/03-fill-polish/pur-yahs/01-TGSGC/m54349U_210221_005741.fasta" \
#-f /nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/NC_035423.1.fasta \
#-g /nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/NC_035423.1.gb -t 12 -o 2

#mkdir /nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/filt-in/
cd /nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/filt-in/
python /nesi/nobackup/ga03186/CondaEnv/MitoHiFi/mitohifi.py -c "/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/gbk.HiFiMapped.bam.filtered.fasta" \
-f /nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/NC_035423.1.fasta \
-g /nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/06-mitohifi/NC_035423.1.gb -t 12 -o 2

