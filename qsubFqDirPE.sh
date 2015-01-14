#!/bin/bash
#takes a script as it's first argument
#takes a directory as it's second argument

script=$1
src=$2
odir=$3


##paired end wild card
pewc="${src}/*_1.f*q.gz"
##single end wild card
sewc="${src}/*.f*q.gz"


##NOTE: never got this working...^ is ambigious
##paired end wild card
##pewc="${src}/*_1.f{astq.gz,q.gz}"
##single end wild card
##sewc="${src}/*.f{astq.gz,q.gz}"


#function to check existance of files matching wild card
exists()
{
    [ -e "$1" ]
}

#ls $pewc
#ls $sewc

##check if anything matches the paired end format
if exists $pewc
then
    ##echo 'paired end'
    for path in $pewc
    do
	qsub $script $path $odir
	#echo $script $path $odir
    done
    ##if it's not paired end check for fq files and assume single end
elif exists $sewc
then
    ##echo 'single end'
    for path in $sewc
    do
	qsub $script $path $odir
	#echo $script $path $odir
    done
    ## if we don't find any files in the proper format, say so. 
else
    echo 'no .f*q.gz files found in ' $src  ' directory. Try again.'
fi
