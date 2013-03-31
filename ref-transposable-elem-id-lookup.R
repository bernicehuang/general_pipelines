library(reshape2)


# PROTEIN: SLACS reference sequences --------------------------------------

# Read in SLACS-CZAR sequence ids (Carly's database)
ref <- read.table(file = "~/Dropbox/bernice/general_pipelines/ref_sequence_id/transposable_elements_sequence_ids/SLACS_CZAR.txt", sep = "|")

# rename colums
names(ref) <- c("gene_id", "gene_org", "gene_desc", "seq_type", "seq_len")

# clean up data columns:
# clean up gene_id (>LbrM03_V2.0010 => LbrM03_V2.0010)
ref$gene_id <- sub(">", "", ref$gene_id)
# clean up seq_len (length=3351 => 3351)
ref$seq_len <- sub("length=", "", ref$seq_len)
# Remove trailiing whitespaces ("Tb09.211.5010         " => "Tb09.211.5010" )
ref$gene_id <- gsub("\\s", "", ref$gene_id)


# Create a look up table to assign a gene annotations to each gene id. ---------
ref.trans <- ref$gene_desc
names(ref.trans) <- ref$gene_id

# make a look up table for gene length
ref.trans.len <- ref$seq_len
names(ref.trans.len) <- ref$gene_id


# Use look up table to annotate data file ---------------------------------
# Now use the refset Named vector (look up table) to go through the data frame  
dataset$blast_desc <- ref.trans[as.character(dataset$blast_id)]
dataset$ref_gene_len <- ref.trans.len[as.character(dataset$blast_id)]
