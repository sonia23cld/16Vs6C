#!/bin/sh

# SLURM #
#SBATCH --job-name=STAR_align_pseudoG
#SBATCH --output=/users/sonia.celestini/New_data/Logs/STAR_align_pseudoG_%A_%a.log 
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=10GB
#SBATCH --cpus-per-task=8
#SBATCH --array=1-48

# MODULES #
ml star/2.7.1a-foss-2018b
ml samtools/1.9-foss-2018b

# DATA #
i=$SLURM_ARRAY_TASK_ID
mainDir=/scratch-cbe/users/sonia.celestini/FASTQraw_trimmed/
samples=/users/sonia.celestini/New_data/samples_updated.txt
fqLst=$(awk '{ if ($11 == "yes") print $5 }' $samples)
sample=$(echo $fqLst | cut -d" " -f$i)
#raw_fq1_zip=${mainDir}${sample}.end1_val_1_fastqc.zip
#raw_fq2_zip=${raw_fq1_zip/end1_val_1/end2_val_2}

#raw_fq1=${mainDir}$(basename -s .zip $raw_fq1_zip)
#raw_fq2=${mainDir}$(basename -s .zip $raw_fq2_zip)

raw_fq1=${mainDir}${sample}.end1_val_1.fq
raw_fq2=${mainDir}${sample}.end2_val_2.fq  

#get accession and short sample name                                                            
accession=$(awk -v l="$sample" '$5==l {print $2}' $samples)
fqbase=$(awk -v l="$sample" '$5==l {print $1}' $samples)

if [ $accession = 6909 ]
then
	indices=/users/sonia.celestini/New_data/Results/pseudogenomes/TAIR10_6909_STAR_idx/
else
	indices=/users/sonia.celestini/New_data/Results/pseudogenomes/pseudoTAIR10_${accession}_STAR_idx/
fi

echo using STAR indices from: $indices

cores=8
STAR_out=/users/sonia.celestini/New_data/Results/Alignement_STAR_annot/${fqbase}_pseudoG/

mkdir -p $STAR_out

# unzip fastq files #
#echo 'unzipping files:'
#echo $raw_fq1_zip
#echo $raw_fq2_zip

#unzip $raw_fq1_zip -d $mainDir
#unzip $raw_fq2_zip -d $mainDir

# RUN #
STAR \
--runMode alignReads \
--twopassMode Basic \
--runThreadN $cores \
--alignIntronMax 4000 \
--alignMatesGapMax 4000 \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMattributes NH HI AS nM NM MD jM jI XS \
--outSAMtype BAM SortedByCoordinate \
--quantMode TranscriptomeSAM \
--genomeDir $indices \
--readFilesIn $raw_fq1 $raw_fq2 \
--outFileNamePrefix $STAR_out


echo 'Job finished'

# rezip fastq files #
#echo 'rezipping'
#zip -rm ${raw_fq1}.zip $raw_fq1
#zip -rm ${raw_fq2}.zip $raw_fq2

