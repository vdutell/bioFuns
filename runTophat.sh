#!/bin/bash

#$ -N vgd_Tophat
#$ -V -j y -pe by_node 8
#$ -cwd -M vgd@stowers.org -b y -m ae
#$ -l mem_free=1G,h_vmem=2G 

FASTQ=$1
SAMPLE=$(basename ${FASTQ} ".fq.gz")
ODIR="./${SAMPLE}"

##specify options
OPTIONS=" --read-realign-edit-dist 0 --b2-very-sensitive --solexa1.3-quals -p 8 -N 2 -g 300 -x 300 --report-secondary-alignments --no-novel-juncs "

##specify GTF File
GTF=" -G /home/vgd/dge_sex_strain/gene_lists/mm10_added_Vmn1r_merged_sorted_tid.gff "

##specify index
INDEX=" /n/data1/genomes/bowtie-index/mm10/mm10 "

mkdir ${ODIR}
tophat ${GTF} ${OPTIONS} -o ${ODIR} ${INDEX} ${FASTQ}
