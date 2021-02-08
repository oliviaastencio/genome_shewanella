#! /usr/bin/env bash 

summary_file=$1  # shewanella_genomes_paper/data_script/transposons/tp_finder_results/results/summary.txt
protein_fasta=$2  # shewanella_genomes_paper/data_script/transposons/data/total_prots.fasta
tp_sequence=$3   # shewanella_genomes_paper/data_script/transposons/data/sequence_tp.fasta
tp_coordinate=$4 #shewanella_genomes_paper/data_script/transposons/data/coord_tp.txt 
out_file=$5    #shewanella_genomes_paper/result/transposons

module load blast_plus/2.2.30+
module load cdhit/4.5.4

awk '{ print $1'_'$2'_'$3 "\t" 2000 "\t" $3-$2+2000 }' $tp_coordinate > $out_file/new_tp_coordinates 
regions=( '850951:856278' '1261471:1266798' '1906106:1911827' '2693976:2700579' '2990403:2995648' '3053373:3058616' '3073685:3079406' '4349020:4355949' )
for region in "${regions[@]}"
do
        folder='tp_'` echo $region | tr ':' '_'`
        mkdir -p $out_file/$folder
        grep $region $summary_file | cut -f 4,5 | tr ',' '\n' | tr '\t' '\n' > $out_file/$folder/protein_names
        lista_to_fasta.rb $protein_fasta $out_file/$folder/protein_names > $out_file/$folder/proteins.fasta
        cd-hit -i $out_file/$folder/proteins.fasta -o $out_file/$folder/proteins_new.fasta -c 0.95
        grep $region $summary_file | cut -f 1,2,3 > $out_file/$folder/tp_finder_coordinate
        lista_to_fasta.rb $tp_sequence $out_file/$folder/tp_finder_coordinate > $out_file/$folder/tp.fasta
        blastx -query $out_file/$folder/tp.fasta -subject $out_file/$folder/proteins_new.fasta -outfmt '7 std slen qlen' > $out_file/$folder/blast
        awk '{if ($3>=35) {print $0}}' $out_file/$folder/blast | cut -f 1,2,3,4,6,7,8,13,14 > $out_file/$folder/blast_summary
        cat $out_file/$folder/tp_finder_coordinate $out_file/$folder/blast_summary > $out_file/$folder/result_summary   
done

