library(reshape2)


# specify the directory where the sequence Id's are
seq.id.dir <- "~/Dropbox/bernice/general_pipelines/ref_sequence_id/gene_fams"

# Pattern used to match and identify reference id files
input.pattern <- "txt$"

# Identify input files ---------------------------------------------------------
# recursive = TRUE so that it will search all the folders.
input.files <- dir(path = seq.id.dir, pattern = input.pattern, 
                   recursive = TRUE, full.names = TRUE)

# Read in data -----------------------------------------------------------------
# create an empty list
seq.ids <- list()

for (f in input.files) {

  seq.ids[[f]] <- read.table(file = f, fill=TRUE)
  
  # extract directory identifiers from input.file path
  seq.id <- gsub(paste(seq.id.dir, "/", sep = ""), "", f)
  seq.id <- unlist(strsplit(seq.id, "/"))
  seq.id <- matrix(rep(seq.id, each = nrow(seq.ids[[f]])), 
                     ncol = length(seq.id))
#  colnames(seq.id) <- c("ref_id_type", "seq_id")
  
  # Add blast identifiers to blast.file
  seq.ids[[f]] <- cbind(seq.id, seq.ids[[f]])
}

# convert into a dataframe
ref.df <- data.frame(do.call("rbind", seq.ids), row.names = NULL)

#rename columns to  make them informative
# names(ref.df) <- c("general_type", "gene_fam", "seq_id")

# Format the sequence ID so it will match ("LmjF13.0280" => "LmjF.13.0280" )
ref.df$V1 <- gsub("LmjF", "LmjF.", ref.df$V1)


# make two look up tables. The first for the specific gene family the other for the broader type (leish or tcruzi)
gene.families <- ref.df$X10
# use the sequence IDs as the look up factor
names(gene.families) <- ref.df$V1

# 2nd look up table
gene.type <- ref.df$X9
names(gene.type) <- ref.df$V1

# How to use the look up table
df$new_column_names <- gene.families[as.character(df$match_column)]