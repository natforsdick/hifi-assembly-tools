#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J repmask3
#SBATCH --cpus-per-task=16
#SBATCH --mem=12G
#SBATCH -t 4:00:00
#SBATCH --out %x.%j.out
#SBATCH --err %x.%j.err

# round 1: annotate/mask simple repeats
OUTDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/annotation/repeats/masking/
REFDIR=/nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/05-scaffolding/2023-12-18-asm3-pur-scaf/yahs/
REF=asm3-hic-hifiasm-p-p_ctg-purged_rep1_scaffolds_final.contam-excl

cd $OUTDIR

ml purge
ml RepeatMasker/4.1.0-gimkl-2020a

# round 3: annotate/mask known elements sourced from species-specific de novo repeat library using output froom 2nd round of RepeatMasker
echo starting round 3
RepeatMasker -pa 16 -a -e ncbi -dir 03_known_out -nolow \
-lib ../round-3_Self/round-3_Self.known \
02_aves_out/${REF}.aves.masked.fasta 2>&1 | tee logs/03_knownmask.log
# round 3: rename outputs
rename aves.masked.fasta known.masked.fasta 03_known_out/${REF}*

# round 4: annotate/mask unknown elements sourced from species-specific de novo repeat library using output froom 3nd round of RepeatMasker
echo starting round 4
RepeatMasker -pa 16 -a -e ncbi -dir 04_unknown_out -nolow \
-lib ../round-3_Self/round-3_Self.unknown \
03_known_out/${REF}.known.masked.fasta 2>&1 | tee logs/04_unknownmask.log
# round 4: rename outputs
rename known.masked.fasta unknown.masked.fasta 04_unknown_out/${REF}*

ml purge
