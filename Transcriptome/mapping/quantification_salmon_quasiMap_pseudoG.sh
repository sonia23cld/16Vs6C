#!/bin/sh

# SLURM #
#SBATCH --job-name=salmonQuasi
#SBATCH --output=/users/sonia.celestini/New_data/Logs/salmon_quasiMap_Araport11_pseudoG_^array_index^.log
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=20GB
#SBATCH --cpus-per-task=4
#SBATCH --array=1-48

# MODULES #
ml Salmon/0.12.0-foss-2018b-Python-3.7.4

# DATA #
i=$SLURM_ARRAY_TASK_ID
DATA=/lustre/scratch/users/pieter.clauw/Transcriptome/6vs16/Data/
FASTQdir=${DATA}Trimmed_illumina/
RESULTS=/lustre/scratch/users/pieter.clauw/Transcriptome/6vs16/Results/
SAMPLES=${DATA}samples.txt

# Select correct index file, based on pseudo genome
base=$(awk '$6 == "ok" {print $5}' $SAMPLES | sed -n ${i}p)
sample=$(echo $base | grep -o -E '[0-9]{5}_')
sample=${sample%'_'}
acn=$(awk -v sample="$sample" '$1==sample {print $2}' $SAMPLES)

INDEX=${DATA}Genome/Araport11_transcriptome_${acn}_salmonIdx

# select fastq files of given sample
end1=${FASTQdir}${base}.end1_val_1.fq.gz
end2=${FASTQdir}${base}.end2_val_2.fq.gz


outdir=${RESULTS}SalmonQuant/Araport11/${base}_quasiMap_pseudoG_Trimmed_illumina/

# PREP #
mkdir -p ${RESULTS}SalmonQuant/Araport11

salmon quant -i $INDEX -l ISR --seqBias --gcBias --writeUnmappedNames --validateMappings --rangeFactorizationBins 4 \
	-p 4 \
	-1 $end1 \
	-2 $end2 \
	-o $outdir


