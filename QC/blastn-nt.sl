#!/bin/bash -e

#SBATCH --account	ga03186
#SBATCH --job-name      BLAST
#SBATCH --time          02:30:00
#SBATCH --mem           350G  # 30 GB plus the database (est at 125 GB)
#SBATCH --ntasks        1
#SBATCH --cpus-per-task 36    # half a node
#SBATCH --err		%x.%j.err
#SBATCH --out		%x.%j.out

module load BLAST/2.13.0-GCC-11.3.0
module load BLASTDB/2022-07

cd $1 # the INDIR
QUERIES=$2 #the FASTA file of query sequences
FORMAT="6 qseqid qstart qend qseq sseqid sgi sacc sstart send staxids sscinames stitle length evalue bitscore"
BLASTOPTS="-task blastn"
BLASTAPP=blastn
DB=nt

# Keep the database in RAM
cp $BLASTDB/{$DB,taxdb}* $TMPDIR/ 
export BLASTDB=$TMPDIR

$BLASTAPP $BLASTOPTS -db $DB -query $QUERIES -outfmt "$FORMAT" \
    -out $QUERIES.$DB.$BLASTAPP -num_threads $SLURM_CPUS_PER_TASK
