library(reshape2)

# Read in data -----------------------------------------------------------------
# Myrna's cog reference look up list
# directory if I'm on my lab computer
seq.ids <- read.table(file = "~/Dropbox/Bernice/general_pipelines/ref_sequence_id/rps/cog_look_up_table.txt", sep = "\t", fill=TRUE)
# directory if I'm on my computer
seq.ids <- read.table(file = "~/Dropbox/bernice/general_pipelines/ref_sequence_id/rps/cog_look_up_table.txt", sep = "\t", fill=TRUE)

# Give informative column names
names(seq.ids) <- c("not_sure", "cog_group", "letter_group", "clean_group")

# remove the right bracket (3-hydroxymyristoyl] ==> 3-hydroxymyristoyl)
seq.ids$cog_group <- sub("\\]", "", seq.ids$cog_group)



# Create a look up table
cog.families <- seq.ids$clean_group
# use the cog group as the look up factor
names(cog.families) <- seq.ids$cog_group



# How to use the look up table
df$new_column_names <- cog.families[as.character(df$match_column)]