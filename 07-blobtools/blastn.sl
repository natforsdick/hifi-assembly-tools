#!/bin/bash -e

#SBATCH --job-name      BLAST
#SBATCH --account	ga03186
#SBATCH --time          18:00:00
#SBATCH --mem           5G  # 30 GB plus the database
#SBATCH --ntasks        1
#SBATCH --cpus-per-task 36    # half a node
#SBATCH --error		%x.%j.err
#SBATCH --out		%x.%j.out

ml purge && ml BLAST/2.13.0-GCC-11.3.0 BLASTDB/2023-01

INDIR=/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/08-blobtools/
QUERY="01P-asm3-hic-hifiasm-p-p_ctg-purged.cns-yahs_scaffolds_final.fa"
FORMAT="6 qseqid staxids bitscore std"
BLASTOPTS="-task blastn -evalue 1e-25 -max_hsps 1 -max_target_seqs 10"
BLASTAPP=blastn
DB=nt
TMP=/nesi/nobackup/ga03186/tmp-blastdb-2023-03-01

cd $INDIR

# Keep the database in RAM - should only need to run cp once
#cp $BLASTDB/{$DB,taxdb}* $TMP/ 
export BLASTDB=$TMP

$BLASTAPP $BLASTOPTS -db $DB -query $QUERY -outfmt "$FORMAT" \
-out $QUERY.$DB.$BLASTAPP -num_threads $SLURM_CPUS_PER_TASK
