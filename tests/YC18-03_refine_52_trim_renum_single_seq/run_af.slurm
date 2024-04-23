#!/bin/bash
#SBATCH --partition=long          # Don't change
#SBATCH --job-name=af
#SBATCH --output=run_af.log
#SBATCH --cpus-per-task=32         # CPU cores/threads
#SBATCH --mem=16G               # memory per node
#SBATCH --time=02-00:00            # Max time (DD-HH:MM)
#SBATCH --ntasks=1                # Only set to >1 if you want to use multi-threading

source /data/anaconda3/etc/profile.d/conda.sh
conda activate pytorch_hunter

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
workdir=$PWD

fasta=$1
pre=`basename $fasta .fasta`
mkdir -p output

python /home/hanlunj/src/alphafold/docker/run_docker.py \
--data_dir=/data/alphafold_data \
--model_preset=multimer \
--fasta_paths=${workdir}/${fasta} \
--output_dir=${workdir}/output \
--use_precomputed_msas=true \
--max_template_date=1000-01-01 &> run_af.${pre}.log

