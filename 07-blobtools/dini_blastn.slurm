#!/bin/bash -e

#SBATCH --job-name      BLAST-test
#SBATCH --account	ga03186
#SBATCH --time          18:00:00
#SBATCH --mem           580G  # 30 GB plus the database
#SBATCH --cpus-per-task 64    # half a node
#SBATCH --error		slurmlogs/%x.%j.err
#SBATCH --out		slurmlogs/%x.%j.out
#SBATCH --partition     milan


ml purge 
module load BLAST/2.13.0-GCC-11.3.0 BLASTDB/2023-04


QUERY="/nesi/nobackup/ga03186/kaki-hifi-asm/asm3-hic-hifiasm-p/08-blobtools/01P-asm3-hic-hifiasm-p-p_ctg-purged.cns-yahs_scaffolds_final.fa"
FORMAT="6 qseqid staxids bitscore std"
#BLASTOPTS="-task blastn -evalue 1e-25 -max_hsps 1 -max_target_seqs 10"
BLASTOPTS="-task blastn -evalue 1e-25 -max_hsps 1 -culling_limit 5"
BLASTAPP=blastn
DB=nt

# Keep the database in RAM - should only need to run cp once
# find the size of the dataase with  `find  /opt/nesi/db/blast/2023-01/ -type f -name 'nt.*' -exec du -ch {} + | grep total$ `
# Total memory assigned via `--mem` should be {(2 x total size of the data base)+ 15GB} = {(258 x 2) + 15} =  535G
# Keep the database in RAM
cp $BLASTDB/{$DB.,taxdb}* $TMPDIR/ 
export BLASTDB=$TMPDIR

$BLASTAPP $BLASTOPTS -db $DB -query $QUERY -outfmt "$FORMAT" \
-out $QUERY.$DB.$BLASTAPP -num_threads ${SLURM_CPUS_PER_TASK}

