#! /usr/bin/env bash

ab1=$1

ab1_files=( 'Pdp11_1492R' 'SH4_1492R' 'SH6_1492R' 'SH9_1492R' 'SH12_1492R' 'SH16_1492R' 'SdM1_1492R' 'SdM2_1492R' )

main_folder=`pwd`
for ab1_file in "${ab1_files[@]}"
do 
     folder_16s=$ab1_file
     mkdir -p $folder_16s
     source ~soft_bio_267/initializes/init_emboss
     seqret -sformat abi -osformat fastq -auto -stdout -sequence $ab1'/'$ab1_file'.ab1' > $folder_16s'/'$ab1_file'.fastq' 
     module load bbmap/38.50b
     bbduk.sh -Xmx1g in=$folder_16s'/'$ab1_file'.fastq' out=$folder_16s'/'$ab1_file'clean.fastq' qtrim=rl trimq=20 qin=33
     seqret -sformat fastq -osformat fasta -auto -stdout -sequence $folder_16s'/'$ab1_file'clean.fastq' > $folder_16s'/'$ab1_file'.fasta'
     #sed s'/SH8_1492R/SH6_1492R/' $folder_16s'/'$ab1_file'.fasta'
     #sed s'/SH19_1492R/SH9_1492R/' 
     mkdir -p $folder_16s'/'analysis
     module load fastqc
     fastqc -o $folder_16s'/'analysis $folder_16s'/'$ab1_file'.fastq'
     
done     
cat */*fasta > prueba.fasta     


