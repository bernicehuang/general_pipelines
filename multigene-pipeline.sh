# ===========================
# = Command line parameters =
# ===========================
# directory where genome assemblies are
input_dir=$1/*


# this script is designed to be run within the project folder
# within the project folder create a folder called genome files: 


# =============================
# = Create output directories =
# =============================
if [ ! -d multigene_fam ]; then
	mkdir "multigene_fam"
fi

if [ ! -d transposable_elements ]; then
	mkdir "transposable_elements"
fi

if [ ! -d tandem_repeats ]; then
	mkdir "tandem_repeats"
fi


# ============================
# = Reference sequence files =
# ============================
leish=~/blast_database/reference_seq/protein/LMF_genefam.faa
tcruzi=~/blast_database/reference_seq/protein/tcruzi_genefam.faa
slacs=~/blast_database/reference_seq/protein/SLACS_CZAR.faa


# ======================
# = Multigene families =
# ======================
for f in $input_dir; do 
	d=$(basename ${f})
	i=$(basename ${leish})
	# blast the leishmania gene families against the genomes. Store output in multigene_fam folder.
	out=${d%.*}_${i%.*}_blastxres
	/usr/global/blp/bin/blastall -p blastx -m 8 -i $leish -d $f > multigene_fam/$out
	
	# blast the tcruzi gene families against the genomes. Store output in multigene_fam folder.
	t=$(basename ${tcruzi})
	out_t=${d%.*}_${t%.*}_blastxres
	/usr/global/blp/bin/blastall -p blastx -m 8 -i $tcruzi -d $f > multigene_fam/$out_t
	
	# blast the slacs/transposable seq against the genomes. Store output in transposable folder.
	te=$(basename ${slacs})
	out_te=${d%.*}_${te%.*}_blastxres
	/usr/global/blp/bin/blastall -p blastx -m 8 -i $tcruzi -d $f > transposable_elements/$out_te
	echo $d
	echo $i
	echo $out
	
	~/bin/run_etandem.sh $f tandem_repeats/$f.etandem
done;

# 
# allgff=/home/huangb2/projects/comparative_genomes/carly_transposable_database/all_transposable_elements_${org}_4.2.sorted.fasta.blastnres.gff
# 
# 
# slacs=/home/huangb2/projects/comparative_genomes/carly_transposable_database/SLACS_CZAR_${org}_4.2.sorted.fasta.tblastnres
# slacsgff=/home/huangb2/projects/comparative_genomes/carly_transposable_database/SLACS_CZAR_${org}_4.2.sorted.fasta.tblastnres.gff
# 
# assembly=${base}/gDNA/assembly/fasta/${org}_4.2_gap/${org}_4.2.sorted.fasta



# # remove duplicates
# # ~/bin/rem_dup $tblastn > ${org}_genefam_tblastn.nodup
# 
# # convert the blast results file to a gff file. Blast has already been done
# perl /home/vnkoparde/scripts/blast92gff3.pl $all > $allgff
# perl /home/vnkoparde/scripts/blast92gff3.pl $slacs > $slacsgff
# 
# # map reads to blast results for all transposable elements first
# /usr/global/blp/BEDTools-Version-2.16.1/bin/intersectBed -abam reads.0.5.HQ.bam -b $allgff > ${org}_all_transposable_elements.reads.bam
# samtools mpileup -BQ0 -d 1000000 -f $assembly ${org}_all_transposable_elements.reads.bam > ${org}_all_transposable_elements.reads.bam.mpileup
# 
# 
# perl /home/vnkoparde/scripts/pileup2GenomicPositionTable.pl ${org}_all_transposable_elements.reads.bam.mpileup ${org}_all_transposable_elements.reads.bam.mpileup.30.table 
# 
# perl /home/vnkoparde/scripts/getHeterozygosityFromGenomicPositionTable.v3.pl $allgff  ${org}_all_transposable_elements.reads.bam.mpileup.30.table  |awk 'NR==1;NR>1{print $0|"sort -k2,2"}' > ${org}_all_transposable_elements.reads.30.heterozygosity
# 
# mv HT_stats.txt ${org}_all_transposable_elements.reads.30.HT_stats.txt
# 
# cat ${org}_all_transposable_elements.reads.30.heterozygosity
# cat ${org}_4.2.reads.SCO.30.heterozygosity |perl -ne 'print unless $_=~/^#/'|awk -F "\t" '{sum2=sum2+$2;sum3=sum3+$3;sum4=sum4+$4;count=count+1}END{printf "SCO\t%5.1f\t%5.1f\t%7.2f\n",sum2/count,sum3/count,sum4/count}'
# 
# # copy the file with the mapped reads count to the project folder
# cp ${org}_all_transposable_elements.reads.30.heterozygosity /home/huangb2/projects/comparative_genomes_project/TATE_transposons/
# 
# 
# # map reads to blast results for SLACS/CZAR elements
# /usr/global/blp/BEDTools-Version-2.16.1/bin/intersectBed -abam reads.0.5.HQ.bam -b $slacsgff > ${org}_slacs_czar.reads.bam
# samtools mpileup -BQ0 -d 1000000 -f $assembly ${org}_slacs_czar.reads.bam > ${org}_slacs_czar.reads.bam.mpileup
# 
# 
# perl /home/vnkoparde/scripts/pileup2GenomicPositionTable.pl ${org}_slacs_czar.reads.bam.mpileup ${org}_slacs_czar.reads.bam.mpileup.30.table 
# 
# perl /home/vnkoparde/scripts/getHeterozygosityFromGenomicPositionTable.v3.pl $slacsgff  ${org}_slacs_czar.reads.bam.mpileup.30.table  |awk 'NR==1;NR>1{print $0|"sort -k2,2"}' > ${org}_slacs_czar.reads.30.heterozygosity
# 
# mv HT_stats.txt ${org}_slacs_czar.reads.30.HT_stats.txt
# 
# cat ${org}_slacs_czar.reads.30.heterozygosity
# cat ${org}_4.2.reads.SCO.30.heterozygosity |perl -ne 'print unless $_=~/^#/'|awk -F "\t" '{sum2=sum2+$2;sum3=sum3+$3;sum4=sum4+$4;count=count+1}END{printf "SCO\t%5.1f\t%5.1f\t%7.2f\n",sum2/count,sum3/count,sum4/count}'
# 
# # copy the file with the mapped reads count to the project folder
# cp ${org}_slacs_czar.reads.30.heterozygosity /home/huangb2/projects/comparative_genomes_project/TATE_transposons/
# 
