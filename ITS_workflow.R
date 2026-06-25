# ----- GETTING READY -----
library(dada2)
packageVersion("dada2")
library(ShortRead)
packageVersion("ShortRead")
library(Biostrings)
packageVersion("Biostrings")

path_its <- "C:/eutychusDada2/data/ITS"
list.files(path_its)

fnFs_its <- sort(list.files(path_its, pattern = "_1.fastq.gz", full.names = TRUE))
fnRs_its <- sort(list.files(path_its, pattern = "_2.fastq.gz", full.names = TRUE))


# ----- Identify primers ------
FWD <- "ACCTGCGGARGGATCA"  ## your forward primer sequence
REV <- "GAGATCCRTTGYTRAAAGTT"  ## reverse primer sequence

allOrients <- function(primer) {
  # Create all orientations of the input sequence
  require(Biostrings)
  dna <- DNAString(primer)  # The Biostrings works DNAString objects rather than character vectors
  orients <- c(Forward = dna, Complement = Biostrings::complement(dna), Reverse = Biostrings::reverse(dna),
               RevComp = Biostrings::reverseComplement(dna))
  return(sapply(orients, toString))  # Convert back to character vector
}

FWD.orients <- allOrients(FWD)
REV.orients <- allOrients(REV)

fnFs.filtN <- file.path(path_its, "filtN", basename(fnFs_its)) # Put N-filtered files in filtN/ subdirectory
fnRs.filtN <- file.path(path_its, "filtN", basename(fnRs_its))
filterAndTrim(fnFs_its, fnFs.filtN, fnRs_its, fnRs.filtN, maxN = 0, multithread = FALSE)


primerHits <- function(primer, fn) {
  # Counts number of reads in which the primer is found
  nhits <- vcountPattern(primer, sread(readFastq(fn)), fixed = FALSE)
  return(sum(nhits > 0))
}
rbind(FWD.ForwardReads = sapply(FWD.orients, primerHits, fn = fnFs.filtN[[1]]), FWD.ReverseReads = sapply(FWD.orients,
                                                                                                          primerHits, fn = fnRs.filtN[[1]]), REV.ForwardReads = sapply(REV.orients, primerHits,
                                                                                                                                                                       fn = fnFs.filtN[[1]]), REV.ReverseReads = sapply(REV.orients, primerHits, fn = fnRs.filtN[[1]]))


# ----- Remove Primers -----

#These primers can be now removed using a specialized primer/adapter removal tool. Here, we use cutadapt for this purpose. Download, installation and usage instructions are available online: http://cutadapt.readthedocs.io/en/stable/index.html

#run these commands to connect the cutadapt command to R

cutadapt <- "C:/eutychusDada2/ITS/cutadapt.exe" # CHANGE ME to the cutadapt path on your machine
system2(cutadapt, args = "--version") # Run shell commands from R


cutadapt <- "C:/Users/HomePC/Downloads/cutadapt.exe" #use this one kheem!!!!!
#create a directory for cutadapt and direct path.cut to that path

path.cut <- file.path(path_its, "cutadapted")
if(!dir.exists(path.cut)) dir.create(path.cut) #create the directory if it doesn't exist

fnFs.cut <- file.path(path.cut, basename(fnFs_its))
fnRs.cut <- file.path(path.cut, basename(fnRs_its))

FWD.RC <- dada2:::rc(FWD)#reverse complements of the FWD primer sequence

REV.RC <- dada2:::rc(REV)

# Trim FWD and the reverse-complement of REV off of R1 (forward reads)
#compare R1.flags and the primer sequences
R1.flags <- paste("-g", FWD, "-a", REV.RC) 
# Trim REV and the reverse-complement of FWD off of R2 (reverse reads)
R2.flags <- paste("-G", REV, "-A", FWD.RC) 

# Run Cutadapt
for(i in seq_along(fnFs_its)) {
  system2(cutadapt, args = c(R1.flags, R2.flags, "-n", 2, # -n 2 required to remove FWD and REV from reads
                             "-o", fnFs.cut[i], "-p", fnRs.cut[i], # output files
                             fnFs.filtN[i], fnRs.filtN[i])) # input files
}



rbind(FWD.ForwardReads = sapply(FWD.orients, primerHits, fn = fnFs.cut[[1]]), FWD.ReverseReads = sapply(FWD.orients,
                                                                                                        primerHits, fn = fnRs.cut[[1]]), REV.ForwardReads = sapply(REV.orients, primerHits,
                                                                                                                                                                   fn = fnFs.cut[[1]]), REV.ReverseReads = sapply(REV.orients, primerHits, fn = fnRs.cut[[1]]))


# Forward and reverse fastq filenames have the format:
cutFs <- sort(list.files(path.cut, pattern = "_1.fastq.gz", full.names = TRUE))
cutRs <- sort(list.files(path.cut, pattern = "_2.fastq.gz", full.names = TRUE))

# Extract sample names, assuming filenames have format:
get.sample.name <- function(fname) strsplit(basename(fname), "_")[[1]][1]
sample.names <- unname(sapply(cutFs, get.sample.name))
head(sample.names)


#----- Inspect Read Quality Profles-----
plotQualityProfile(cutFs[1:2])

#The forward reads are of good quality. The red line shows that a significant chunk of reads were cutadapt-ed to about 150nts in length, likely reflecting the length of the amplified ITS region in one of the taxa present in these samples. Note that, unlike in the 16S Tutorial Workflow, we will not be truncating the reads to a fixed length, as the ITS region has significant biological length variation that is lost by such an appraoch.

plotQualityProfile(cutRs[1:2])



##filter and trim
filtFs_its <- file.path(path.cut, "filtered", basename(cutFs))
filtRs_its <- file.path(path.cut, "filtered", basename(cutRs))

out_its <- filterAndTrim(cutFs, filtFs_its, cutRs, filtRs_its, maxN = 0, maxEE = c(2, 2), truncQ = 2,
                     minLen = 50, rm.phix = TRUE, compress = TRUE, multithread = FALSE)  # on windows, set multithread = FALSE
head(out_its)

##Learn the error rates
#Please ignore all the “Not all sequences were the same length.” messages in the next couple sections. We know they aren’t, and it’s OK!

errF_its <- learnErrors(filtFs_its, multithread = TRUE)
errR_its <- learnErrors(filtRs_its, multithread = TRUE)

#Visualize the estimated error rates
plotErrors(errF_its, nominalQ = TRUE)

#Sample inference
dadaFs_its <- dada(filtFs_its, err = errF_its, multithread = TRUE)
dadaRs_its <- dada(filtRs_its, err = errR_its, multithread = TRUE)

#merge paired reads
mergers_its <- mergePairs(dadaFs_its, filtFs_its, dadaRs_its, filtRs_its, verbose=TRUE)

#construct sequence table
seqtab_its <- makeSequenceTable(mergers_its)
dim(seqtab_its)


#remove chimeras
seqtab.nochim.its <- removeBimeraDenovo(seqtab_its, method="consensus", multithread=TRUE, verbose=TRUE)

table(nchar(getSequences(seqtab.nochim.its)))


#track reads through the pipeline
getN <- function(x) sum(getUniques(x))
track_its <- cbind(out_its, sapply(dadaFs_its, getN), sapply(dadaRs_its, getN), sapply(mergers_its, getN),
                   rowSums(seqtab.nochim.its))
# If processing a single sample, remove the sapply calls: e.g. replace
# sapply(dadaFs_its, getN) with getN(dadaFs_its)

colnames(track_its) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track_its) <- sample.names
head(track_its)


#assign taxonomy

unite.ref <- "C:/eutychusDada2/data/ITS/tax/sh_general_release_dynamic_29.11.2022.fasta"
taxa_its <- assignTaxonomy(seqtab.nochim.its, unite.ref, multithread = FALSE, tryRC = TRUE)
taxa.print.its <- taxa_its# Removing sequence rownames for display only
rownames(taxa.print.its) <- NULL
head(taxa.print.its)
