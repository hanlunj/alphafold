#!/bin/bash
#SBATCH --cluster=whale            # Don't change
#SBATCH --partition=long          # Don't change
#SBATCH --account=researcher      # Don't change
#SBATCH --job-name=af
#SBATCH --output=run.gpu.array.log
#SBATCH --gres=gpu:1              # Number of GPU(s) per node. In this case I am asking for one GPU
#SBATCH --cpus-per-task=16         # CPU cores/threads
#SBATCH --mem=16G               # memory per node
#SBATCH --time=02-00:00            # Max time (DD-HH:MM)
#SBATCH --ntasks=1                # Only set to >1 if you want to use multi-threading
#SBATCH --array=1-5%2

source /data/anaconda3/etc/profile.d/conda.sh
conda activate pytorch_hunter

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
workdir=$PWD

index=0
for i in {1..5}; do
  let index=index+1
  if [ $SLURM_ARRAY_TASK_ID -eq $index ] ; then
    cd $workdir

gpuid=`scontrol show job -d $SLURM_JOB_ID | grep IDX | awk -F':' '{print $NF}' | awk -F')' '{print $1}'`
echo "$i $SLURM_JOB_ID $SLURM_ARRAY_TASK_ID: gpu_id: $gpuid" >> run.log
sleep 100

  fi
done
