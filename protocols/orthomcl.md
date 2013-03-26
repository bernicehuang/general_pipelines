How to get single copy orthologs
--------------------------------------------

###Run Ortho-MCL

* Create a directory in your project folder called ```orthomcl```
* Within the ```orthomcl``` folder you just created, create another folder called ```compliantFasta```

### orthomclAdjustFasta

* Within the ```compliantFasta``` folder run this command for each called genes protein sequence file: The purpose of this is to create an orthomcl properly formatted fasta file.
	* ```/usr/global/blp/bin/orthomclAdjustFasta taxon_code fasta_file id_field```
		* **taxon_code**: a three or four letter unique abbreviation for the taxon.
		* **fasta_file**: the input fasta file (needs to have the extension .fasta)
		* **id_field**: a number indicating what field in the definition line contains
               the protein ID.  Fields are separated by either ' ' or '|'. Any
               spaces immediately following the '>' are ignored.  The first
               field is 1. For example, in the following definition line, the
               ID (AP_000668.1) is in field 4:  >gi|89106888|ref|AP_000668.1|
	* ```/usr/global/blp/bin/orthomclAdjustFasta tbat ../../genome_files/called_genes/TcBat_1994_genes.faa 1```

###orthomclFilterFasta

* This step produces a single combined goodProteins.fasta file to run Blast on. The filter is based on length and percent stop codons, these parameters can be adjusted.
* Go back to your ```orthomcl``` directory.
	* ```/usr/global/blp/bin/orthomclFilterFasta input_dir min_length max_percent_stops```
		* **input_dir**: compliantFasta directory, which contains your output files from orthomclAdjustFasta
		* **min_length**: minimum allowed length of protein (suggested: 10)
		* **max_percent_stop**: maximum percent stop codons (suggested: 20)
	* ```/usr/global/blp/bin/orthomclFilterFasta ./compliantFasta 10 20```
* **Output**: This will create a file called ```goodProteins.fasta```
	* ```grep ">" goodProteins.fasta | wc ```
		* The first number will give you the database size, which you will need when you run asgard.
	* ```/usr/global/blp/bin/formatdb -i goodProteins.fasta -p T```
		* This is to format the fasta file as a database

###All-v-all Blast
* Use asgard to do an all-vs-all blast
	* ```/usr/global/blp/bin/asgard -w -B -d goodProteins.fasta -p blastp -i goodProteins.fasta -m 8 -z database_size (from grep) -e 1e-5```
* Unzip the blast output:
	* gzip -d blastres_goodProteins.fasta.gz
	
#### orthomclBlastParser
* This step parses the blast output into a format that can be loaded into the orthomcl database.
	* ```/usr/global/blp/bin/orthomclBlastParser blast_file ./compliantFasta```
* **Output**: ```similarSequences.txt``` This will now be loaded into the MySQL database.

###Run orthomcl on new Rashnu
* Log in to the new Rashnu server. 
	* log in: ```ssh huangb2@128.172.189.216```
	* Create a folder called orthomcl
* From Godel: Copy the similarSequences.txt from Godel to the new Rashnu server
	* ```scp similarSequences.txt huangb2@128.172.189.216:/huangb2/orthomcl/```
* Run orthomcl.sh
	* ```sh orthomcl.sh```
	* this is a script that Vishal wrote for Katie: it will runs the following:
		* pre_orthomcl_cleanup.sh this wipes out any previous orthomcl runs so that you start with a clean slate.
		* runs orthomclLoadBlast
		* This script will create the necessary tables so do not need to do anything extra. 
* **Output**: 
	* pairs/ directory: 3 files each with 3 columns: protein A, protein B, their normalized score
		* ortholog.txt
		* coortholog.txt
		* inparalog.txt
	* mclInput file

###Transfer new rashnu output files back to godel:

* transfer the orthomcl output files back to your orthomcl directory on Godel:
	* scp ./pairs huangb2@godel.vcu.edu:/data6/tol/huangb2/projects/bat_trypanosome_project/orthomcl
	* scp mclInput huangb2@godel.vcu.edu:/data6/tol/huangb2/projects/bat_trypanosome_project/orthomcl
	
###mcl
* go back to the orthomcl project directory on Godel.
	* ```~/bin/mcl mclInput --abc -t 10 -I 1.5 -o mclOutput```

###orthomclMclToGroups
* ```/usr/global/blp/bin/orthomclMclToGroups species-prefix 1000 < mclOutput > groups.txt```
	* **species-prefix**: this is an arbitrary string to use as a prefix for your group IDs.
		* tbat-tdio-tmar-tcg
	* 1000 is an arbitrary starting point for your group IDs. 

### To get the single copy orthologs (SCO) from the groups.txt file
* SCO from groups.txt: You want to find all instances where all the species are present but there is only 1 gene from each. 
	* ```cat groups.txt | perl -ne "@t=split/\s+/$_;print if (@t==5)"| grep Tbat | grep Tdio | grep Tmar | grep Tcg | less```
	* ```cat groups.txt | perl -ne "@t=split/\s+/$_;print if (@t==5)"| grep Tbat | grep Tdio | grep Tmar | grep Tcg groups.SCO.txt```
	* ```wc -l groups.SCO.txt```
	* **Output**: (will look something like this)
		* tbat-tdio-tmar-tcg1000: Tbat|Tbat_gene_00001 Tdio|Tdio_gene_00002 
* For each organism extract out the gene id so that you can use it to pull out those gene coordinates from the gff.file
	* ```Org_genes.gff``` files are in ```genome_files/other``` 
	* Extract the gene Ids from the groups.SCO.txt 
		* ```cat groups.SCO.txt |perl -ne 'chomp;@t =split/\s+/; foreach $x (@t) {print "$x\n" if $x=~/^Tbat/}' Tbat.SCO.geneid```

	

.

