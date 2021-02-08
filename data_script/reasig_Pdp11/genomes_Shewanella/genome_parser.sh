#! /usr/bin/env bash

PATH=~oliastencio/micro_lab3/shewanella_genomes_paper/data_script/reasig_Pdp11/genomes_Shewanella:$PATH
export PATH
module load ruby/2.4.1

prokaryotes_genomes_csv=$1  #all shewanella genomes from https://www.ncbi.nlm.nih.gov/genome/browse#!/prokaryotes/shewanella
output=$2    #sequence_download

#cat $prokaryotes_genomes_csv | tr ',' '\t'| cut -f 16 | tr '"' '\t'| cut -f 2  > genomes_link
# We online need the genomic.fna.gz file 
main_folder=`pwd`
#file="genomes_link"
#while IFS= read -r line
#do
#    wget "$line/*1_genomic.fna.gz" 
#    wget "$line/*2_genomic.fna.gz" 
#done < "$file" 
#gzip -d *fna.gz 
#mv *genomic.fna $output
cd $output
strains=( `ls` )
for strain in "${strains[@]}"
do
	genome_parser.rb $strain genomes/$strain'_genome.fna' plasmids/$strain'_plasmids.fna'
done
cd $main_folder