## ----✷----✷---- Download AnGeLi Database ----✷----✷----
options(timeout = 1000) # This is a very large database which takes a while to load, so the timeout setting should be increased. If timeout is still reached, try increasing the timeout.

# Data is acquired from AnGeLi, a tool for gene set enrichment analysis by Bähler Lab.
read.table("http://bahlerweb.cs.ucl.ac.uk/AnGeLiDatabase.txt",
    header = TRUE,
    fill = TRUE,
    nrows = 100,
    sep = "\t") %>%
    write.csv("data/data-raw/short-angeli.csv")


# Load data and clean names
yeast <- read.table("data/data-raw/short-angeli.csv",
    header = TRUE, fill = TRUE,
    sep = ",", row.names = 1) %>%
    janitor::clean_names()

## ----✷----✷---- Extract columns for analysis ----✷----✷----
# Separate the column info into a key to understand the columns
key <- c("Long name", "Group", "Scale of measurement", "Source", "Author", "Update", "Link")

col_key <- yeast %>% # Remove these rows from the dataset
  filter(short_name %in% key &
      short_name == "Group") %>%
    pivot_longer(names_to = "name",
         values_to = "group",
         cols = -1)

yeast2 <- yeast %>% # New dataset without key
    filter()



--------
  cc <- read.delim("data/data-raw/cc_go.tsv",
                   header = FALSE,
                   fill = TRUE,
                   sep = "\t") %>%
  janitor::clean_names()

bp <- read.delim("data/data-raw/bp_go.tsv",
                 header = FALSE,
                 fill = TRUE,
                 sep = "\t") %>%
  janitor::clean_names()

mf <- read.delim("data/data-raw/mf_go.tsv",
                 header = FALSE,
                 fill = TRUE,
                 sep = "\t") %>%
  janitor::clean_names()

annotation <- read.delim("data/data-raw/complex_annotation.tsv",
                         header = TRUE,
                         fill = TRUE,
                         sep = "\t") %>%
  janitor::clean_names() %>%
  rename(go_annotation = "acc") %>%
  select(c(go_annotation, go_name, systematic_id))


go <- list(cc, bp, mf) %>%
  reduce(full_join, by = c("v1", "v2"))

all <- full_join(pombase_all, go,
                 by = c("go_annotation" = "v1")) %>%
  rename("go_definition" = "v2") %>%
  drop_na(systematic_id) %>%
  mutate(across(everything(), ~replace_na(., "unknown"))) %>%
  distinct(.keep_all = TRUE) %>%
  group_by(systematic_id) %>%
  mutate(id = cur_group_id()) %>%
  distinct(.keep_all = TRUE)
 ----------

  ## ----✷----✷---- Pombase data ----✷----✷----
pombase_genes <- read.delim(
  "data/data-raw/gene_list.tsv",
  header = TRUE,
  fill = TRUE,
  sep = "\t",
  na.strings = c("", "NA")
) %>%
  janitor::clean_names()


# https://www.pombase.org/data/annotations/Gene_ontology/gene_association.pombase.gz
pombase_go <-
  read.table(
    "data/data-raw/gene_association.pombase.txt",
    header = FALSE,
    fill = TRUE,
    sep = "\t",
    skip = 5,
    na.strings = c("", "NA")
  ) %>%
  janitor::clean_names() %>%
  select(c(1:5, 9:10)) %>%
  rename(
    v1 = "source",
    v2 = "systematic_id",
    v3 = "gene_name",
    v4 = "relationship",
    v5 = "go_annotation",
    v9 = "go_overview",
    v10 = "product_description"
  )

amigo <-
  read.delim(
    "data/data-raw/amigo.txt",
    header = FALSE
  ) %>%
  janitor::clean_names() %>%
  rename(v1 = "go_annotation" , v2 = "go_class")






## ----✷----✷---- merging ----✷----✷----

all <- (full_join(pombase_go, amigo,
                  by = c("go_annotation")) %>%
          distinct(.keep_all = TRUE)) %>%
  full_join(pombase_genes,
            by = c("systematic_id",
                   "product_description",
                   "gene_name")) %>%
  pivot_longer(
    cols = c(
      budding_yeast_orthologs,
      s_japonicus_orthologs,
      human_orthologs
    ),
    names_to = "orthologs",
    values_to = "ortholog_gene"
  )  %>%
  drop_na(systematic_id) %>%
  group_by(systematic_id) %>%
  mutate(across(everything(), ~ replace_na(., "unknown"))) %>%
  mutate(id = cur_group_id()) %>%
  mutate(ortholog_gene = strsplit(ortholog_gene, ",")) %>%
  unnest(ortholog_gene) %>%
  mutate(physical_interactors = strsplit(physical_interactors, ",")) %>%
  unnest(physical_interactors) %>%
  distinct(.keep_all = TRUE) %>%
  mutate(go_overview = recode(go_overview, C = "cellular_component",
                              F =  "molecular_function",
                              P =  "biological_process"))

## ----✷----✷---- fasta ----✷----✷----

fastafile <-
  readDNAStringSet("data/data-raw/sequence_protein.fasta", format = "fasta")
seq_name = names(fastafile)
sequence = paste(fastafile)
fasta <- data.frame(seq_name, sequence) %>%
  rename(seq_name = "systematic_id")

one_description <- fasta$systematic_id

fasta <- fasta %>%
  mutate(systematic_id = str_extract(one_description, "SP[^\\s]+") %>%
           str_replace("\\sSP[^\\s]+", ""))

# --------

file <- "data/data-raw/mass_spec_data_anon.xlsx"

data <- read_excel(file, skip = 3, col_names = F)
colnames(data) = read_excel(file,
                            skip = 2,
                            col_names = F,
                            n_max = 1)

tidy <- data %>%
  janitor::clean_names() %>%
  pivot_longer(cols = 25:33,
               names_to = "spectral_treatment",
               values_to = "spectral_count") %>%
  pivot_longer(
    cols = -c(
      "accession",
      "peptide_count",
      "unique_peptides" ,
      "confidence_score",
      "description",
      "anova_p",
      "spectral_treatment",
      "spectral_count"
    ),
    names_to = "abundance",
    values_to = "expression"
  ) %>%
  mutate_at(
    vars(c(abundance, spectral_treatment)),
    funs(
      str_extract_all(., "gfp[^\\s]+") %>% str_replace_all("gfp_", "gfp") %>%
        str_replace_all("gfp1", "gfpc_1") %>%
        str_replace_all("gfp2", "gfpc_2") %>%
        str_replace_all("gfp3", "gfpc_3")
    )
  ) %>%
  separate(abundance, c("treatment", "repeat_no", "abundance")) %>%
  mutate(abundance = recode(abundance, "2" = "raw", .missing = "normalised")) %>%
  separate(spectral_treatment, c("spectral", "spectral_repeat")) %>%
  mutate(gene =  str_extract(description, "GN=[^\\s]+") %>%
           str_replace("GN=", "")) %>%
  mutate(description =  str_extract(description, ".*OS=") %>%
           str_replace("OS=", "")) %>%
  write_delim("data/data-processed/tidy")

