#! /usr/bin/env bash

# Leave only one comment symbol on selected options
# Those with two commets will be ignored:
# The name to show in queue lists for this job:
##SBATCH -J script.sh

# Number of desired cpus (can be in any node):
#SBATCH --ntasks=1

# Number of desired cpus (all in same node):
##SBATCH --cpus=1

# Amount of RAM needed for this job:
#SBATCH --mem=2gb

# The time the job will be running:
#SBATCH --time=1-00:00:00

# To use GPUs you have to request them:
##SBATCH --gres=gpu:1

# If you need nodes with special features uncomment the desired constraint line:
# * to request only the machines with 80 cores and 2TB of RAM
##SBATCH --constraint=bigmem
# * to request only machines with 16 cores and 64GB with InfiniBand network
##SBATCH --constraint=cal
# * to request only machines with 24 cores and Gigabit network
##SBATCH --constraint=slim

# Set output and error files
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

# MAKE AN ARRAY JOB, SLURM_ARRAYID will take values from 1 to 100
##SARRAY --range=1-100

# To load some software (you can show the list with 'module avail'):
# module load software

PATH=~pedro/software/Sibelia/bin/:$PATH
export PATH
module load circos
PATH=~soft_bio_267/programs/x86_64/scripts/:$PATH

problem=$1 # PATH TO FOLDER #data_script/reasig_Pdp11/genome_problem 
genomes_shewanella=$2 #data_script/reasig_Pdp11/genomes_Shewanella
out_file=$3 #shewanella_genomes_paper/result/reasig_Pdp11

problem_strains=( 'e_Shewanella_putrefaciens_SdM2'  'e_Shewanella_putrefaciens_SdM1'  'e_Pdp11_1' 'e_Shewanella_putrefaciens_SH16_micro22' 'e_Shewanella_putrefaciens_SH9_micro13' 'e_Shewanella_putrefaciens_SH12_micro1' 'e_Shewanella_putrefaciens_SH4_micro9' 'e_Shewanella_putrefaciens_SH6_micro12' ) 

name_problem_strains=( 'e_Shewanella_putrefaciens_SdM2'  'e_Shewanella_putrefaciens_SdM1'  'e_Pdp11_1' 'e_Shewanella_putrefaciens_SH16_micro22' 'e_Shewanella_putrefaciens_SH9_micro13' 'e_Shewanella_putrefaciens_SH12_micro1' 'e_Shewanella_putrefaciens_SH4_micro9' 'e_Shewanella_putrefaciens_SH6_micro12' )

genome_candidates=( 'GCF_000013765.1_ASM1376v1_genomic'   'GCF_000215895.1_ASM21589v1_genomic'   'GCF_007567505.1_ASM756750v1_genomic' 'GCF_000014665.1_ASM1466v1_genomic'  'GCF_002005305.1_ASM200530v1_genomic'  'GCF_009372175.1_ASM937217v1_genomic' 'GCF_000014685.1_ASM1468v1_genomic'   'GCF_002075795.1_ASM207579v1_genomic'  'GCF_009730575.1_ASM973057v1_genomic' 'GCF_000014705.1_ASM1470v1_genomic'   'GCF_002209245.2_ASM220924v2_genomic'  'GCF_009730655.1_ASM973065v1_genomic' 'GCF_000014885.1_ASM1488v1_genomic'   'GCF_002215585.1_ASM221558v1_genomic'  'GCF_009846595.1_ASM984659v1_genomic' 'GCF_000015185.1_ASM1518v1_genomic'  'GCF_002216875.1_ASM221687v1_genomic'  'GCF_010092445.1_ASM1009244v1_genomic' 'GCF_000015245.1_ASM1524v1_genomic'   'GCF_002838165.1_ASM283816v1_genomic'  'GCF_011106835.1_ASM1110683v1_genomic' 'GCF_000015845.1_ASM1584v1_genomic'   'GCF_002966515.1_ASM296651v1_genomic'  'GCF_011765625.1_ASM1176562v1_genomic' 'GCF_000016065.1_ASM1606v1_genomic'   'GCF_003030925.1_ASM303092v1_genomic'  'GCF_013394145.1_ASM1339414v1_genomic' 'GCF_000016585.1_ASM1658v1_genomic'   'GCF_003044255.1_ASM304425v1_genomic'  'GCF_014263185.1_ASM1426318v1_genomic' 'GCF_000017325.1_ASM1732v1_genomic'   'GCF_003052765.1_ASM305276v1_genomic'  'GCF_014702225.1_ASM1470222v1_genomic' 'GCF_000018025.1_ASM1802v1_genomic'   'GCF_003427415.1_ASM342741v1_genomic'  'GCF_014840975.1_ASM1484097v1_genomic' 'GCF_000018285.1_ASM1828v1_genomic'   'GCF_003721455.1_ASM372145v1_genomic'  'GCF_016406305.1_ASM1640630v1_genomic' 'GCF_000018765.1_ASM1876v1_genomic'   'GCF_003855395.1_ASM385539v1_genomic'  'GCF_016406325.1_ASM1640632v1_genomic' 'GCF_000019185.1_ASM1918v1_genomic'   'GCF_003957745.1_ASM395774v1_genomic'  'GCF_016757755.1_ASM1675775v1_genomic' 'GCF_000019525.1_ASM1952v1_genomic'   'GCF_004295345.1_ASM429534v1_genomic'  'GCF_900476435.1_SHEWBE_PRJEB25587v2_genomic' 'GCF_000021665.1_ASM2166v1_genomic'  'GCF_005234075.1_ASM523407v1_genomic'  'GCF_900636665.1_43781_G01_genomic' 'GCF_000091325.1_ASM9132v1_genomic'   'GCF_006385555.1_ASM638555v1_genomic'  'GCF_900636855.1_44858_H01_genomic' 'GCF_000146165.2_ASM14616v2_genomic'  'GCF_006494715.1_ASM649471v1_genomic'  'GCF_000169215.2_ASM16921v2_genomic' 'GCF_006494755.1_ASM649475v1_genomic'  'GCF_000178875.2_ASM17887v2_genomic'  'GCF_007004545.2_ASM700454v2_genomic'  'GCF_000203935.1_ASM20393v1_genomic'  'GCF_007197555.1_ASM719755v1_genomic' )


main_folder=`pwd`

for problem_strain in "${problem_strains[@]}"
do
    mkdir -p $out_file/$problem_strain 
    for name_problem_strain in "${name_problem_strains[@]}"
    do
        mkdir -p $out_file/$problem_strain/$name_problem_strain
        Sibelia -m 2000 -s fine $problem/$problem_strain'.fasta'  $problem/$name_problem_strain'.fasta' -o $out_file/$problem_strain/$name_problem_strain
        cd $out_file/$problem_strain/$name_problem_strain/circos
        circos -conf circos.conf -debug_group summary,timer -param image/radius=1500p > run.out 
        cd $main_folder
    done
    for genome_candidate in "${genome_candidates[@]}"
		do
		mkdir -p $out_file'/'$problem_strain/$genome_candidate
        Sibelia -m 2000 -s fine $problem/$problem_strain'.fasta'  $genomes_shewanella/$genome_candidate'.fna' -o $out_file/$problem_strain/$genome_candidate
        cd $out_file/$problem_strain/$genome_candidate/circos
        circos -conf circos.conf -debug_group summary,timer -param image/radius=1500p > run.out 
		cd $main_folder
    done
    cd $out_file/$problem_strain
    grep 'All' */coverage_report.txt | cut -f 1,3 > results
    sed -i "1i shewanella_genome\t$problem_strain" 'results'
    cd $main_folder
done 
cd $out_file
merge_tabular.rb */results > $out_file/results_sibelia_total     
cat results_sibelia_total | awk '{ if (($2>=50) || ($3>=50) || ($4>=50) || ($5>=50) || ($6>=50) || ($7>=50) || ($8>=50) || ($9>=50)) {print $0}}' > results_sibelia_total_filtre
