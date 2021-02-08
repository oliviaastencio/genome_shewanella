#! /usr/bin/env bash
PATH=~soft_bio_267/programs/x86_64/scripts/:$PATH
summary=$1  #shewanella_genomes_paper/data_script/transposons/tp_finder_results/results/summary.txt
protein_fasta=$2   #shewanella_genomes_paper/data_script/transposons/data/total_prots.fasta
out_put=$3   #shewanella_genomes_paper/result/transposon/comparative
tp1=$4  #shewanella_genomes_paper/result/transposon/tp_850951_856278/tp.fasta       #completed sequence tp_850951:856278
tp2=$5   #shewanella_genomes_paper/result/transposon/tp_1261471_1266798/tp.fasta     #completed sequence tp_1261471:1266798
tp3=$6   #shewanella_genomes_paper/result/transposon/tp_1906106_1911827/tp.fasta      #completed sequence tp_1906106:1911827
tp4=$7   #shewanella_genomes_paper/result/transposon/tp_3073685_3079406/tp.fasta       #completed sequence tp_3073685:3079406

#transposon complete sequence = disrupted protein fragment + transposon sequence + disrupted protein fragment
mkdir -p $out_put/comparative
module load blast_plus/2.2.30+
module load cdhit/4.5.4

sequences=( '850951:856278' '1261471:1266798' '1906106:1911827' '3073685:3079406' )
transposons=( 'tp1' 'tp2' 'tp3' 'tp4' )

main_folder=`pwd`

for sequence in "${sequences[@]}"
do 
	folder='tp_'` echo $sequence | tr ':' '_'`
	mkdir -p $out_put/comparative/$folder
	string=`tail -n 1 $tp1`  
	echo ${string:2000:1327} > $out_put/comparative/$folder/tp1_seq.fasta  
	#we extract the transposon sequence and discard the sequence of the ends. TThis corresponding to the interrupted proteins
	string=`tail -n 1 $tp2`  
	echo ${string:2000:1327} > $out_put/comparative/$folder/tp2_seq.fasta
	string=`tail -n 1 $tp3`
	echo ${string:2000:1721} > $out_put/comparative/$folder/tp3_seq.fasta
	string=`tail -n 1 $tp4` 
	echo ${string:2000:1721} > $out_put/comparative/$folder/tp4_seq.fasta
	grep $sequence $summary | cut -f 4 | tr ',' '\n' | tr '\t' '\n' > $out_put/comparative/$folder/protein_code
	lista_to_fasta.rb $protein_fasta $out_put/comparative/$folder/protein_code > $out_put/comparative/$folder/protein.fasta
	#We have used the transposon proteins sequence. 
	cd-hit -i $out_put/comparative/$folder/protein.fasta -o $out_put/comparative/$folder/protein_new.fasta -c 0.95
	for transposon in "${transposons[@]}"
		do
		blastx -query $out_put/comparative/$folder/$transposon'_seq.fasta' -subject $out_put/comparative/$folder/protein_new.fasta -outfmt '7 std slen qlen' > $out_put/comparative/$folder/$folder'_'$transposon'_blast'
		#We make a crossed blast among the 4 tp candidates for the repetition study. (tp_protein v/s tp_sequence)
		grep -v '#' $out_put/comparative/$folder/$folder'_'$transposon'_blast' | awk '{ if ($3>=80) {print $0}}' | cut -f 1,2,3 > $out_put/comparative/$folder/$folder'_'$transposon'_blast_filtre'
     done
done 