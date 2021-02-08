#! /usr/bin/env bash
path_16s=$1              # /data_script/reasig_Pdp11/16S_Shewanella
out_put_blast=$2                              # /result/reasig_Pdp11/blast_16S
source ~soft_bio_267/initializes/init_blast 
blastn -query $path_16s/16S.fasta -db nt -remote -outfmt '7 std slen qlen' > $out_put_blast/blast_total
grep -v '#' $out_put_blast/blast_total | awk '{ if (($3>=80) && (($4/$14*100)>=90)) {print $0}}' > $out_put_blast/blast_total_filtre
sequence_16s=( 'Pdp11_1492R' 'SH4_1492R' 'SH6_1492R' 'SH9_1492R' 'SH12_1492R' 'SH16_1492R' 'SdM1_1492R' 'SdM2_1492R'  )
for  sequence_16 in "${sequence_16s[@]}"
    do 
    grep $sequence_16 $out_put_blast/blast_total_filtre  | sort -k3 | tail -n20 > $out_put_blast/'blast'_$sequence_16 
done

