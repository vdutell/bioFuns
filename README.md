#bioFuns - 
##Useful (and Fun!) Bioinformatics Functions

Vasha DuTell
vgd@stowers.org
vashadutell@gmail.com

=================
alignStatsTH.R
=================

####Description:
Create a table and graphical report of the alignment results from a TopHat alignmnet, reporting the percent of unique, multimapped, and unmapped alignments.
	
####Usage:
runTophatReport(report.file.path)

####Arguments:
**report.file.path**
A string for the path poiting to the desired directory and filename for the report file to be used/created. If the reportfile does not already exist, the directory of the reportfile given MUST contain the accepted_hits.bam and unmapped.bam files (the results of running Tophat), and only the ones desired for analysis.

####Value:
A barplot containing the results of alignment for all accepted_hits.bam, and unmapped.bam files contained in the directory of report.file.path. While not passed back, the report file is also written to the desired filepath indicated by report.file.path.

####Author(s):
Richard Dannebaum

Vasha DuTell

####Example:
```
##name the desired reportfile or point to existing one
my.reportfile <- paste(./tophat_output/alignmentreport.rda',sep='')
	my.plot <- runTophatReport(my.reportfile)
	my.plot    
```

=================
calcFC, calcLogFC
=================

####Description:
Simple function that returns a list of fold changes given two lists of expression values

####Usage:
calcFC(va,vb)
calcLogFC(va,vb)

####Arguments:
**va**
A numeric list containing the baseline expression values

**vb**
A numeric list containing the expression values to be compared to baseline

####Value:
A numeric list containing either the fold change or log2 fold change from va to vb.

####Notes:
va and vb must be lists of the same length, and the elements (genes) for which each expression level corresponds in the same order in both lists. Definition of Fold Change: Standard FC, whether postive or negative, always has a magnitude greater than 1, where positive FC is defined here as an INCREASE from va TO vb, ie vb/va > 1. Likewise, negative FC is defined here as a DECREASE from va to vb, ie -(va/vb > 1). For example a fold change from 6 to 2 would be -6/2 = -3. Additionally, log(FC) is log2(FC), and is defined as either log2(vb/va) or -log2(va/vb), whichever has largest magnitude.

####Author(s):
Vasha DuTell

Dar Dahen

####Example:
```
wild.type.rpkm <- c(1,3,2,6)
mutant.rpkm <- c(2,0,8,9)
my.fc <- calcFC(wild.type.rpkm, mutant.rpkm)
my.log.fc <- calcLogFC(wild.type.rpkm, mutant.rpkm)
```

=================
runTG
=================

####Description:
Run a Gene Onology (GO) analysis (BP,CC, or MF) using BioMart and topGO on a list of Ensembl Gene IDs.

####Usage:
runTG(ensGeneList, analysis, organism)

####Arguments:
**ensGeneList** 
A list of ensembl gene IDs

**analysis**
A string indicating which type of GO analysis to perform, ie one of: 'BP' (Biological Process), 'CC' (Celluarl Component), or 'MF' (Mollecular Function).

**organism**
A string indicating to Biomart which organism the provided ensembl genelist is from. Some examples are 'mmusculus_gene_ensembl', 'hsapiens_gene_ensembl', 'dmelanogaster_gene_ensembl', etc. For the full list run 'ensembl=useMart("ensembl"); listDatasets(ensembl)' or see http://www.bioconductor.org/packages/release/bioc/vignettes/biomaRt/inst/doc/biomaRt.pdf

####Value:	
A datatable containing the top go terms enriched in the given gene list, with the data for their expected occurance, observed occurance, enrichment, and the classic Fisher test.

####Note:
To save time in future runs, if not found, this function will create and save a file called 'topGOGeneList.organism.rda' in the current working directory, where 'organism' is the organism given as an argument.

####Author(s):
Vasha DuTell

Malcom Cook


####Example:
```
my.genelist <-c('ENSMUSG00000020830','ENSMUSG00000041333','ENSMUSG00000055961')
my.table <- runTG(my.genelist, 'BP', 'mmusculus_gene_ensembl')
my.table
```
	
=================
plotTG
=================

####Description:
Run and graph the results of a Gene Onology (GO) analysis using BioMart and topGO.

####Usage:
plotTG(gotable)

####Arguments:
**gotable**
The datatable output from runTG(), containing the top enriched GO terms from a topGO analysis. 

####Value:
A ggplot geom_bar plot with the enrichment of the top GO terms plotted on the x-axis, and the Fisher plotted as the color of the bars.

####Author(s):
Vasha DuTell

Ashley Woodfin

####Example:
```
my.table <- runTG(my.genelist, 'BP', 'mmusculus_gene_ensembl')
my.plot <- plotTG(my.table)
my.plot
```
