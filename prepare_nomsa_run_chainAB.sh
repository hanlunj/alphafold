#!/bin/bash

### assuming each sequence occupies only one line!

outdir=output
mkdir -p $outdir

fasta=$1
chain_a=`head -2 $fasta | tail -1`
chain_a_len=${#chain_a}
chain_b=`tail -1 $fasta`
chain_b_len=${#chain_b}
pre=`basename $fasta .fasta`
rm -rf $outdir/$pre
mkdir $outdir/$pre
mkdir $outdir/$pre/msas
chain_a_dir=$outdir/$pre/msas/A
mkdir $chain_a_dir
chain_b_dir=$outdir/$pre/msas/B
mkdir $chain_b_dir

head -2 $fasta > $chain_a_dir/bfd_uniref_hits.a3m
echo -e "# STOCKHOLM 1.0\nchain_A $chain_a\n//\n" > $chain_a_dir/mgnify_hits.sto
echo -e "# STOCKHOLM 1.0\nchain_A $chain_a\n//\n" > $chain_a_dir/uniprot_hits.sto
chain_a_x=$(for i in `seq 1 $chain_a_len`; do echo -n "x"; done)
echo -e "# STOCKHOLM 1.0\nchain_A $chain_a\n#=GC RF $chain_a_x\n//\n" > $chain_a_dir/uniref90_hits.sto

tail -2 $fasta > $chain_b_dir/bfd_uniref_hits.a3m
echo -e "# STOCKHOLM 1.0\nchain_B $chain_b\n//\n" > $chain_b_dir/mgnify_hits.sto
echo -e "# STOCKHOLM 1.0\nchain_B $chain_b\n//\n" > $chain_b_dir/uniprot_hits.sto
chain_b_x=$(for i in `seq 1 $chain_b_len`; do echo -n "x"; done)
echo -e "# STOCKHOLM 1.0\nchain_B $chain_b\n#=GC RF $chain_b_x\n//\n" > $chain_b_dir/uniref90_hits.sto
