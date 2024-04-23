#!/bin/bash
#SBATCH --partition=long          # Don't change
#SBATCH --job-name=af
#SBATCH --output=run_af.log
#SBATCH --gres=gpu:1              
#SBATCH --cpus-per-task=16         # CPU cores/threads
#SBATCH --mem=16G               # memory per node
#SBATCH --time=02-00:00            # Max time (DD-HH:MM)
#SBATCH --ntasks=1                # Only set to >1 if you want to use multi-threading
#SBATCH --array=1-5%2

source /data/anaconda3/etc/profile.d/conda.sh
conda activate pytorch_hunter

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
workdir=$PWD

mkdir -p output

index=0
for fasta in `cat fasta.list` ; do
  let index=index+1
  if [ $SLURM_ARRAY_TASK_ID -eq $index ] ; then
    cd $workdir

    pre=`basename $fasta .fasta`
    gpuid=`scontrol show job -d ${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID} | grep IDX | awk -F':' '{print $NF}' | awk -F')' '{print $1}'`
    echo "gpu_id: $gpuid"

python /home/hanlunj/src/alphafold/docker/run_docker.py \
--data_dir=/data/alphafold_data \
--model_preset=multimer \
--fasta_paths=${workdir}/${fasta} \
--output_dir=${workdir}/output \
--use_precomputed_msas=true \
--skip_template \
--gpu_devices=$gpuid \
--max_template_date=1000-01-01 &> run_af.${pre}.log

  fi
done
