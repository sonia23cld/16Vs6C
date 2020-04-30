#!/bin/sh

# SLURM #
#SBATCH --output=/users/sonia.celestini/New_data/Logs/makePseudeGenomes_%A_%a.log
#SBATCH --mem=10GB
#SBATCH --array=1-7

# MODULES #
ml python/3.6.6-foss-2018b
# copy script from /projects/cegs/6vs16/Scripts/make_pseudogenome_fasta.py
PSEUDOGENIZE=/users/sonia.celestini/New_data/16Vs6C/Transcriptome/mapping/make_pseudogenome_fasta.py 
# DATA #
i=$SLURM_ARRAY_TASK_ID
mainDir=/scratch-cbe/users/pieter.clauw/16vs6/Data/Genome/
MY_PATH=/users/sonia.celestini/New_data/Results/
FASTA=${mainDir}TAIR10_chromosomes.fas
VCFlst=${MY_PATH}vcf_for_pseudogenome.txt
VCF=${MY_PATH}$(sed -n ${i}p $VCFlst)
OUT=${VCF/1001genomes_snp-short-indel_only_ACGTN/pseudogenomes/pseudoTAIR10}
OUT=${OUT/.vcf/.fasta}

# MAKE PSEUDO GENOMES #
python $PSEUDOGENIZE -O $OUT $FASTA $VCF

awk '/>[0-9]/{gsub(/>/,">Chr")}{print}' $OUT > ${OUT}.tmp
mv ${OUT}.tmp $OUT






