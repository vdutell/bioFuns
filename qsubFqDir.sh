#!/bin/bash
#script is first argument
script=$1
#source is second argument
source=$2

#for each .fq.gz file in source
for path in ${source}/*.fq.gz
do
#qsub the script  
qsub $script $source
done
