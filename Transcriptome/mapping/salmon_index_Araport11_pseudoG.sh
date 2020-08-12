#!/bin/sh

# script to build the transcriptome index for the Araport11 transcriptome that can be used for gene expression quantification with salmon (non-alignement based)

# SLURM #
#SBATCH --job-name=salmonIdx
#SBATCH --output=/users/sonia.celestini/New_data/Logs/salmon_index_PseudoG_%A_%a.log
#SBATCH --time=1:00:00
#SBATCH --array=0-7


# MODULES #
ml --ignore-cache salmon/1.2.1-foss-2018b
ml --ignore-cache gffread/0.11.8-gcccore-8.3.0

# DATA #
DATA=/scratch-cbe/users/sonia.celestini/
myDir=/users/sonia.celestini/New_data/Results/
i=$SLURM_ARRAY_TASK_ID

accessions=('6909' '9559' '6017' '9728' '8242' '9888' '9433' '9075') 
acn=${accessions[$i]}

##create pseudotranscriptome first, you need gene annotations and pseudogenome

#wget  https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/Araport11_GFF3_genes_transposons.201606.gff.gz

Gene_annot=${DATA}Araport11_transcriptome/Araport11_GFF3_genes_transposons.201606.gff.gz
gunzip $Gene_annot
Gene_annot=${DATA}Araport11_transcriptome/Araport11_GFF3_genes_transposons.201606.gff
out=${DATA}pseudotranscriptomes/pseudoAraport11_${acn}.fa 

if [ $acn = 6909 ]
then
	pseudogenome=/scratch-cbe/users/pieter.clauw/16vs6/Data/Genome/TAIR10_chromosomes.fas
else
	pseudogenome=${myDir}pseudogenomes/pseudoTAIR10_${acn}.fasta
fi

##change name of chloroplast and mitochondria to make it work
sed -i 's/chloroplast/ChrC/g' $pseudogenome
sed -i 's/mitochondria/ChrM/g' $pseudogenome


echo 'Pseudotranscriptome creation'
gffread -F -w $out -g $pseudogenome $Gene_annot 

echo 'Zip annotation'
gzip -f $Gene_annot

##create decoys
decoy=${DATA}pseudotranscriptomes/decoy_${acn}.txt
echo 'Create decoys'

grep "^>" < $pseudogenome | cut -d " " -f 1 > $decoy
sed -i.bak -e 's/>//g' $decoy

gentrome=${DATA}pseudotranscriptomes/gentrome_${acn}.fa
cat $out $pseudogenome > $gentrome
gzip -f $gentrome
gentrome=${DATA}pseudotranscriptomes/gentrome_${acn}.fa.gz

##create indexes
echo 'Create indexes'
echo for accession $accession we are using transcriptome from: $out
INDEX=/scratch-cbe/users/sonia.celestini/SalmonIdx/Araport11_transcriptome_${acn}_salmonIdx

salmon index -t $gentrome -d $decoy -p 12 -i $INDEX --gencode

echo index for salmon quasi-mapping has been built and saved in $INDEX
