##pass a list of ensembl ids as well as a type of analysis ('BP','CC',or 'MF)
##get a list of go enrichment in the list
##ensGeneList = list of ensembl ids
##analysis = c('BP','CC','MF')
##organism = c('mmusculus_gene_ensembl','hsapiens_gene_ensembl','dmelanogaster_gene_ensembl', etc) (for full list see : http://www.bioconductor.org/packages/release/bioc/vignettes/biomaRt/inst/doc/biomaRt.pdf)
runTG<-function(ensGeneList,analysis,organism){
    library("biomaRt")
    library(topGO)

    ##look for a file with the entire Biomart genelist for this organism, if not make it
    topgo.file <- paste('./TopGoGeneList.',organism,'.rda',sep='')
    if(!file.exists(topgo.file)){
        ##grab our GO annotation table form biomart
        ensembl<-useMart("ensembl")
        ensembl<-useDataset(organism, mart=ensembl)            SC2GO<-getBM(attributes=c('ensembl_gene_id','external_gene_name','go_id'),filters='',values='',mart=ensembl)
        SC2GO <- SC2GO[SC2GO$go_id != '',]  
        geneID2GO <- by(SC2GO$go_id,SC2GO$ensembl_gene_id,function(x) as.character(x))
        geneNames <- names(geneID2GO)
        #save it
        save(geneID2GO,geneNames,file=topgo.file)
        
    }else{
        load(topgo.file)
    }
    
    ensGeneList <- factor(as.integer(geneNames %in% ensGeneList))
    names(ensGeneList) <- geneNames
    GOData <- new("topGOdata",description="GO Enrichment for sig DE genes",
                  ontology=analysis,
                  allGenes=ensGeneList,
                  annot=annFUN.gene2GO,
                  gene2GO=geneID2GO)
    resultFisher <- runTest(GOData, algorithm = "classic", statistic = "fisher")
    x <- GenTable(GOData, classicFisher = resultFisher,orderBy="classicFisher",numChar=500)
    x$classicFisher <- as.numeric(gsub("<","",as.matrix(x$classicFisher)))
    x$enrich <- x$Significant/x$Expected #calculate enrichment
    x<-x[x$Annotated > 2,] #if we only have 2 annotated we don't care
    x<- x[x$classicFisher < .05,] #only the significant
    x[order(x$classicFisher),] #order by classic_ Fisher
}

