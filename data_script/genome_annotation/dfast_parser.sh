#! /usr/bin/env bash

PATH=~oliastencio/micro_lab3/shewanella_genomes_paper/data_script/genome_annotation:$PATH
export PATH
PATH=~soft_bio_267/programs/x86_64/scripts/:$PATH
export PATH
module load ruby/2.4.1

out_put=$1  #shewanella_genomes_paper/result/genome_annotation

mkdir -p $out_put/results_dfast_parser
strains=( 'Pdp11' 'SH12' 'SH4' 'SH6' 'SH9' 'SH16' 'SdM1' 'SdM2')
main_folder=`pwd`
for strain in "${strains[@]}"
do
	dfast_parser.rb $strain/annotation.gbk $out_put/results_dfast_parser/"dfast_parser_$strain.txt"
        cd $out_put/results_dfast_parser/ 
        mv cog_table.txt "$strain"'_cog_table.txt'
        sed -i "1i category\t$strain" "$strain"'_cog_table.txt'
        cd $main_folder
done
cd $out_put/results_dfast_parser/
merge_tabular.rb *cog_table.txt > Total_table.txt
