REFDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/yahs/
REF=asm3-hic-hifiasm-p-p_ctg-purged_rep1_scaffolds_final.contam-excl.fa
species=kaki
OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/annotation/repeats/

date

cd $OUTDIR
ml purge
ml RepeatModeler/2.0.3-Miniconda3
BuildDatabase -name $species $REFDIR$REF

date
ml purge
