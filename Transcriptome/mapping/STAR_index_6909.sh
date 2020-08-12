#!/bin/sh

# SLURM #
#SBATCH --output=/users/sonia.celestini/New_data/Logs/STARidx_6909.log
#SBATCH --mem=40GB
#SBATCH --cpus-per-task=4

# MODULES #
ml star/2.7.1a-foss-2018b

# DATA #
#i=$SLURM_ARRAY_TASK_ID
#mainDir=/users/sonia.celestini/New_data/Results/pseudogenomes/
#pseudoGs=${mainDir}pseudogenomes.txt
FASTA=/scratch-cbe/users/pieter.clauw/16vs6/Data/Genome/TAIR10_chromosomes.fas
Indices=/users/sonia.celestini/New_data/Results/pseudogenomes/TAIR10_6909_STAR_idx
Araport11GTF=/scratch-cbe/users/pieter.clauw/16vs6/Data/Genome/Araport11_GFF3_genes_transposons.201606.ChrM_ChrC_FullName.gtf
# old
# TAIR10GFF=$HOME/Data/TAIR10/Arabidopsis_thaliana.TAIR10.41.gtf

# PARAMETERS #
cores=4

# PREPARATION #
mkdir -p $Indices

# GENOME INDICES #

STAR \
--runThreadN $cores \
--runMode genomeGenerate \
--genomeDir $Indices \
--genomeFastaFiles $FASTA \
--sjdbGTFfile $Araport11GTF \
--sjdbOverhang 124



