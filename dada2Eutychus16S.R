#-----DADA2 PIPELINE FOR 16S rNA-----
##load packages
#if (!require("BiocManager", quietly = TRUE))
 # install.packages("BiocManager")

BiocManager::install("dada2")

library(dada2); packageVersion("dada2")

# path <- "# CHANGE this to the directory containing the fastq files after unzipping."

path <- "C:/eutychusDada2/eutychusDada2/Microbiome"

list.files(path)



# Sort Samples
fnFs <- sort(list.files(path, pattern="_R1_001.fastq", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="_R2_001.fastq", full.names = TRUE))


#sapply applies a function over a list or vector ...strsplit splits elements of a chr vector into substrings...basename gets or sets the path of an object..and the function supplied to sapply is '[' which is a list subsetting fx i.e it subsets the results from strsplit(basename()) and subsets the 1st element each in the list

?basename
?strsplit
?sapply

sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)


# ------ INSPECT READ QUALITY PROFILES ------

?plotQualityProfile

plotQualityProfile(fnFs[1:2])#checks the quality of the first two forward reads files on a graph

plotQualityProfile(fnRs[1:2])#reverse reads


# ------ FILTER & TRIM ------

# Assign the filenames for the filtered fastq.gz files.

# Place filtered files in filtered/ subdirectory
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))



# We’ll use standard filtering parameters: maxN=0 (DADA2 requires no Ns), truncQ=2, rm.phix=TRUE and maxEE=2. The maxEE parameter sets the maximum number of “expected errors” allowed in a read, which is a better filter than simply averaging quality scores.

?filterAndTrim

out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,160),
                     maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
                     compress=TRUE, multithread=FALSE) # On Windows set multithread=FALSE

head(out)


# ------ LEARN THE ERROR RATES ------

?learnErrors

errF <- learnErrors(filtFs, multithread=TRUE)

errR <- learnErrors(filtRs, multithread=TRUE)

?plotErrors

plotErrors(errF, nominalQ=TRUE)

# ------ DEREPLICATION ------

?derepFastq

derepFs <- derepFastq(filtFs, verbose=TRUE)
derepRs <- derepFastq(filtRs, verbose=TRUE)

# Name the derep-class objects by the sample names

names(derepFs) <- sample.names
names(derepRs) <- sample.names

# ------ SAMPLE INFERENCE ------

# We are now ready to apply the core sample inference algorithm to the dereplicated data.


?dada

dadaFs <- dada(derepFs, err=errF, multithread=TRUE)

dadaRs <- dada(derepRs, err=errR, multithread=TRUE)

dadaFs[[1]]


# ------ MERGE PAIRED READS ------

?mergePairs

mergers <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose=TRUE)


head(mergers[[1]])


# ------ CONSTRUCT SEQUENCE TABLE ------

# We can now construct an amplicon sequence variant table (ASV) table, a higher-resolution version of the OTU table produced by traditional methods.

?makeSequenceTable

seqtab <- makeSequenceTable(mergers)
seqtab
## The sequences being tabled vary in length.

dim(seqtab)

# Inspect distribution of sequence lengths

?getSequences

table(nchar(getSequences(seqtab))) 
#normal bell curve


# ------ REMOVE CHIMERAS ------

?removeBimeraDenovo

seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)

dim(seqtab.nochim)

sum(seqtab.nochim)/sum(seqtab)

# ------ TRACK READS THROUGH THE PIPELINE ------

# As a final check of our progress, we’ll look at the number of reads that made it through each step in the pipeline:

getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))

# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names

head(track)

# ------ ASSIGN TAXONOMY ------

?assignTaxonomy

taxa <- assignTaxonomy(seqtab.nochim, "C:/eutychusDada2/data/Microbiome/silva_nr_v128_train_set.fa.gz", multithread=FALSE)

?addSpecies

taxa <- addSpecies(taxa, "C:/eutychusDada2/data/Microbiome/silva_species_assignment_v128.fa.gz")

# Let’s inspect the taxonomic assignments:

taxa.print <- taxa # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
head(taxa.print)

# Evaluating DADA2’s accuracy on the mock community:

unqs.mock <- seqtab.nochim["Mock",]
unqs.mock <- sort(unqs.mock[unqs.mock>0], decreasing=TRUE) # Drop ASVs absent in the Mock
cat("DADA2 inferred", length(unqs.mock), "sample sequences present in the Mock community.\n")



mock.ref <- getSequences(file.path(path, "HMP_MOCK.v35.fasta"))
match.ref <- sum(sapply(names(unqs.mock), function(x) any(grepl(x, mock.ref)))) ##elaborate further
cat("Of those,", sum(match.ref), "were exact matches to the expected reference sequences.\n")


# Here ends the DADA2 portion of the tutorial.

# ------ HANDOFF TO PHYLOSEQ ------


BiocManager::install("phyloseq")
library(phyloseq); packageVersion("phyloseq")


library(ggplot2); packageVersion("ggplot2")

theme_set(theme_classic())

# We can construct a simple sample data.frame from the information encoded in the filenames. Usually this step would instead involve reading the sample data in from a file.

samples.out <- rownames(seqtab.nochim)

subject <- sapply(strsplit(samples.out, "D"), `[`, 1)

?substr

gender <- substr(subject,1,1)

subject <- substr(subject,2,999)

day <- as.integer(sapply(strsplit(samples.out, "D"), `[`, 2))

samdf <- data.frame(Subject=subject, Gender=gender, Day=day)

samdf$When <- "Early"

samdf$When[samdf$Day>100] <- "Late"

rownames(samdf) <- samples.out

# We now construct a phyloseq object directly from the dada2 outputs.

?phyloseq
?otu_table
?sample_data
?tax_table

ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               sample_data(samdf), 
               tax_table(taxa))

?prune_samples

ps <- prune_samples(sample_names(ps) != "Mock", ps) # Remove mock sample
ps

# Visualize alpha-diversity:

?plot_richness

plot_richness(ps, x="Day", measures=c("Shannon", "Simpson"), color="When")

# Ordinate:

# Transform data to proportions as appropriate for Bray-Curtis distances

?transform_sample_counts
?ordinate

ps.prop <- transform_sample_counts(ps, function(otu) otu/sum(otu))
ord.nmds.bray <- ordinate(ps.prop, method="NMDS", distance="bray")


?plot_ordination

plot_ordination(ps.prop, ord.nmds.bray, color="When", title="Bray NMDS")

# Ordination picks out a clear separation between the early and late samples.

# Bar plot:
  
top20 <- names(sort(taxa_sums(ps), decreasing=TRUE))[1:20]
ps.top20 <- transform_sample_counts(ps, function(OTU) OTU/sum(OTU))
ps.top20 <- prune_taxa(top20, ps.top20)
plot_bar(ps.top20, x="Day", fill="Family") + facet_wrap(~When, scales="free_x")


#-----Microviz by Dr. Ganda-----

install.packages("microViz", repos = c(davidbarnett = "https://david-barnett.r-universe.dev", getOption("repos")))


#Load Required Libraries

library(phyloseq)       # microbiome data structure and utilities
library(ggplot2)        # plotting
library(vegan)          # adonis2 for PERMANOVA
library(microbiome)     # CLR transform
library(microViz)       # tax_agg, tax_transform, comp_heatmap, etc.
library(dplyr)          # data manipulation
library(viridis)        # viridis color scales
library(RColorBrewer)   # Set3 palette
library(scales)         # scale formatting in ggplot2
library(tibble)         # tibble operations
library(stringr)        # string manipulation

# ----- Alpha Diversity (Shannon Index) and ANOVA -----

# Calculate alpha diversity metrics
adiv <- estimate_richness(ps, measures = c("Observed", "Shannon"))

# Add metadata (When) for group comparison
adiv$When <- sample_data(ps)$When

# Perform ANOVA to test for group differences
anova_res <- aov(Shannon ~ When, data = adiv)
summary(anova_res)

# Visualize Shannon index by group
ggplot(adiv, aes(x = When, y = Shannon, fill = When)) +
  geom_boxplot() +
  theme_classic() +
  scale_fill_viridis_d() +
  labs(title = "Alpha Diversity (Shannon)", y = "Shannon Index")

# ----- Additional Alpha Diversity Visualization (Violin + Jitter) -----

# Violin plot with individual Shannon values
ggplot(adiv, aes(x = When, y = Shannon, fill = When)) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_jitter(width = 0.2, size = 1, alpha = 0.8) +
  theme_classic() +
  scale_fill_viridis_d() +
  labs(title = "Alpha Diversity (Shannon) - Violin Plot", y = "Shannon Index")

# ----- Beta Diversity (PERMANOVA and NMDS Ordination) -----

# CLR-transform the data (for Aitchison distance)
ps.clr <- microbiome::transform(ps, 'clr')

# Compute Aitchison distance (Euclidean on CLR-transformed data)
dist_matrix <- phyloseq::distance(ps.clr, method = "euclidean")

# Run PERMANOVA to test effect of 'When'
adonis_res <- adonis2(dist_matrix ~ sample_data(ps.clr)$When)
print(adonis_res)

# Perform NMDS ordination
ord <- ordinate(ps.clr, method = "NMDS", distance = "euclidean")

# Plot NMDS ordination colored by group
plot_ordination(ps.clr, ord, color = "When") +
  theme_classic() +
  scale_color_viridis_d() +
  labs(title = "Beta Diversity (NMDS - Euclidean)")

# ----- Relative Abundance Bar Plot (Phylum Level) -----

# Collapse taxa to Phylum level
ps.phylum <- tax_glom(ps, taxrank = "Phylum")

# Convert to relative abundance (compositional)
ps.phylum.rel <- transform_sample_counts(ps.phylum, function(x) x / sum(x))

# Plot relative abundance by group
plot_bar(ps.phylum.rel, fill = "Phylum") +
  facet_wrap(~When, scales = "free_x") +
  theme_bw() +
  labs(title = "Relative Abundance by Phylum", y = "Proportion") +
  scale_fill_viridis_d()


# ----- Relative Abundance Bar Plot (Genus Level + some fancy rearranging) -----

library(phyloseq)
library(ggplot2)
library(RColorBrewer)
library(dplyr)

# Collapse to Genus and convert to relative abundance
ps.genus <- tax_glom(ps, taxrank = "Genus")
ps.genus.rel <- transform_sample_counts(ps.genus, function(x) x / sum(x))

# Identify top 10 most abundant genera
top10 <- names(sort(taxa_sums(ps.genus.rel), decreasing = TRUE))[1:10]

# Label all other genera as "Other"
tax_table(ps.genus.rel)[!(taxa_names(ps.genus.rel) %in% top10), "Genus"] <- "Other"

# Re-agglomerate to merge all "Other" taxa
ps.genus.top10 <- tax_glom(ps.genus.rel, taxrank = "Genus")

# Melt for plotting
plotdf <- psmelt(ps.genus.top10)

# Order genera by total abundance, placing "Other" last
genus_order <- plotdf %>%
  group_by(Genus) %>%
  summarise(total_abundance = sum(Abundance)) %>%
  arrange(desc(total_abundance)) %>%
  pull(Genus)
genus_order <- c(setdiff(genus_order, "Other"), "Other")
plotdf$Genus <- factor(plotdf$Genus, levels = genus_order)

# Create color palette: Set3 for first 10, gray for "Other"
base_colors <- brewer.pal(n = 10, name = "Set3")
names(base_colors) <- genus_order[genus_order != "Other"]
base_colors["Other"] <- "gray70"

# Plot
ggplot(plotdf, aes(x = Sample, y = Abundance, fill = Genus)) +
  geom_bar(stat = "identity") +
  facet_wrap(~When, scales = "free_x") +
  scale_fill_manual(values = base_colors) +
  theme_bw() +
  labs(title = "Relative Abundance (Top 10 Genera + Other)", y = "Proportion", x = NULL)

# ----- Constrained Ordination (PCA with Taxa Vectors) -----

# Clean taxonomy: remove unknown/NA labels
ps_clean <- ps %>%
  tax_fix(unknowns = c("Incertae Sedis", "Unknown", "uncultured", "NA", NA))

# Aggregate to Genus level, CLR-transform, and compute PCA
ps_ord <- ps_clean %>%
  tax_agg("Genus") %>%
  tax_transform("clr") %>%
  ord_calc(method = "PCA")

# Create PCA plot with taxa vectors (top 6 most important)
pca_plot <- ps_ord %>%
  ord_plot(
    plot_taxa = 1:6,
    colour = "When",
    size = 1.5,
    tax_vec_length = 0.325,
    tax_lab_style = tax_lab_style(max_angle = 90, aspect_ratio = 1),
    auto_caption = 8
  )

# Customize plot appearance
custom_pca_plot <- pca_plot +
  stat_ellipse(aes(linetype = When, colour = When), linewidth = 0.3) +
  scale_colour_brewer(palette = "Set1") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom") +
  coord_fixed(ratio = 1, clip = "off")

# Display PCA plot
custom_pca_plot

# ----- Relative Abundance Heatmap (Top 30 Genera) -----

# Aggregate to Genus level, transform to relative abundance, and filter rare taxa
ps_heat <- ps %>%
  tax_fix() %>%
  tax_agg("Genus") %>%
  tax_transform("compositional") %>%
  tax_filter(min_prevalence = 0.1)

# Select top 30 most abundant genera
top30 <- tax_top(ps_heat, n = 30)

# Define group color palette for sample annotations
cols <- distinct_palette(n = length(unique(sample_data(ps_heat)$When)), add = NA)
names(cols) <- unique(sample_data(ps_heat)$When)

# Plot heatmap with prevalence bars and sample group annotation
ps_heat %>%
  comp_heatmap(
    taxa = top30,
    tax_anno = taxAnnotation(
      Prev. = anno_tax_prev()
    ),
    sample_anno = sampleAnnotation(
      When = anno_sample("When"),
      col = list(When = cols)
    )
  )
