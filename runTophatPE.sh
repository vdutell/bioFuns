#!/bin/bash

#$ -N vgd_Tophat_pe
#$ -V -j y -pe by_node 6
#$ -cwd -M vgd@stowers.org -m ae -b y 
#$ -l mem_free=50G,h_vmem=100G 

FASTQ1=$1
FASTQ2=$(echo $FASTQ1 | awk '{ gsub("_1\.f","_2\.f")}1')
SAMPLE=$(basename $(basename ${FASTQ1} ".fastq.gz" ) ".fq.gz") 

ODIR=${2}/${SAMPLE}

OPTIONS="-p 6 -N 2 -g 300 --no-novel-juncs"

GTF="-G /n/data1/genomes/bowtie-index/mm10/Ens_78/mm10.Ens_78.remap.gtf"

INDEX="/n/data1/genomes/bowtie-index/mm10/mm10"

mkdir ${ODIR}
tophat ${GTF} ${OPTIONS} -o ${ODIR} ${INDEX} ${FASTQ1} ${FASTQ2} 2> ${ODIR}${Tophat}.err
