#!/bin/bash
source /data/anaconda3/etc/profile.d/conda.sh
conda activate af2_hanlun

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
workdir=$PWD

fasta=YC18-03_refine_52_trim_renum.af2.fasta
pre=`basename $fasta .fasta`
mkdir -p output

python /home/hanlunj/src/alphafold_fork/alphafold/docker/run_docker.py \
--data_dir=/data/alphafold_data \
--model_preset=multimer \
--fasta_paths=${workdir}/${fasta} \
--output_dir=${workdir}/output \
--use_precomputed_msas=true \
--skip_template \
--gpu_devices=1 \
--max_template_date=1000-01-01 #&> run_af.${pre}.log


