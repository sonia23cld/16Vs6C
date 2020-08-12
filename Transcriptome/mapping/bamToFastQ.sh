#!/bin/sh

# SLURM # 
#SBATCH --output=/users/sonia.celestini/New_data/Logs/bamToFastq_%A_%a.log
#SBATCH --mem=10GB
#SBATCH --array=1-48

# WARNING: script suffers from random craches due to stale file handling in internal files of bedtools and/or samtools.
# check log files after running and rerun failed processes

# MODULES #
ml bedtools/2.27.1-foss-2018b
ml samtools/1.9-foss-2018b

# DATA #
i=$SLURM_ARRAY_TASK_ID
DATAdir=/scratch-cbe/users/sonia.celestini/
BAMlst=${DATAdir}BAMraw_list.txt
BAM=${DATAdir}BAMraw/$(sed "${i}q;d" $BAMlst)
BAMbase=$(basename -s .bam $BAM)

BAMsort=${DATAdir}BAMraw/${BAMbase}.qsort.bam
FASTQ1=${DATAdir}FASTQraw/${BAMbase}.end1.fastq
FASTQ2=${DATAdir}FASTQraw/${BAMbase}.end2.fastq

# sort bam file in order to make 2 fastq files -> paired-end data
samtools sort -n $BAM -o $BAMsort

echo 'bamfile sorted'

# split sorted BAM file into two fastq files (paired-end data)
bedtools bamtofastq -i $BAMsort -fq $FASTQ1 -fq2 $FASTQ2

echo 'bamtofastq finished'

#loop to find the missing results
#for i in {1..48}
#do
	#BAM=$(sed "${i}q;d" $BAMlst)
	#BAMbase=$(basename -s .bam $BAM)
	#FASTQ1=${DATAdir}FASTQraw/${BAMbase}.end1.fastq
	#if test -f "$FASTQ1"; then
		#echo nope
	#else 
		#echo $FASTQ1 NOT EXIST
	#fi
#done
