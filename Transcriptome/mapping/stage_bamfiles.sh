#!/usr/bin/sh                                                                                                                         

# stage rawdata bamfiles from rawdata repository to scratch-cbe

# SLURM #
#SBATCH --output=/users/sonia.celestini/New_data/Logs/stage_bamfiles.log

SAMPLES=/groups/nordborg/projects/cegs/16Vs6C/Data/Transcriptome/RawData/samples_updated.txt
BAMFILES=$(awk '{ if ($11 == "yes") print $10 }' $SAMPLES)

TARGET=/scratch-cbe/users/sonia.celestini/BAMraw/

for BAM in ${BAMFILES[@]}; do
	    cp -v $BAM $TARGET
    done

