#!/bin/sh

# SLURM #
#SBATCH --job-name=salmonQuasi
#SBATCH --output=/users/sonia.celestini/New_data/Logs/salmon_quasiMap_Araport11_pseudoG_%A_%a.log
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=20GB
#SBATCH --cpus-per-task=4
#SBATCH --array=1

# MODULES #
ml --ignore-cache salmon/1.2.1-foss-2018b

# DATA #
i=$SLURM_ARRAY_TASK_ID
DATA=/scratch-cbe/users/sonia.celestini/
myDir=/users/sonia.celestini/New_data/
FASTQdir=${DATA}FASTQraw_trimmed/
RESULTS=${myDir}Results/
SAMPLES=${myDir}samples_updated.txt

# Select correct index file, based on pseudo genome
base=$(awk '{ if ($11 == "yes") print $5 }' $SAMPLES | sed -n ${i}p)
acn=$(awk -v l="$base" '$5==l {print $2}' $SAMPLES)

INDEX=${DATA}SalmonIdx/Araport11_transcriptome_${acn}_salmonIdx

# select fastq files of given sample
end1=${FASTQdir}${base}.end1_val_1.fq
end2=${FASTQdir}${base}.end2_val_2.fq


outdir=${RESULTS}SalmonQuant/${base}_quasiMap_pseudoG_Trimmed/

# PREP #
mkdir -p $outdir

salmon quant -i $INDEX -l ISR --seqBias --gcBias --writeUnmappedNames --validateMappings --rangeFactorizationBins 4 \
	-p 4 \
	-1 $end1 \
	-2 $end2 \
	-o $outdir


