## create and plot a report of the results from a TopHat run
##Credit to Richard Dannebaum for the bulk of these, I have done minor edits
## internal function called by runTopHatReport, creates the report even if there is not already one.

topHatReport <- function(reportfile){
    topHatDir <- dirname(reportfile)
    nClus<-16
    library(Rsamtools)  
    library(parallel)  
    topHat.mapped <- list.files(path=topHatDir,pattern="^accepted_hits.bam$",recursive=TRUE,full.names=TRUE)
    topHat.unmapped <- file.path(dirname(topHat.mapped),'unmapped.bam')
    stopifnot(all(file.exists(topHat.unmapped)))  ## Breaks if there is no unmapped bam associated with a bam file
    ##print(topHat.mapped) ##debugging
    ##print(topHat.unmapped) ## debugging
    
    getNumber <- function(mapped.file){
        unmapped.file <- file.path(dirname(mapped.file),'unmapped.bam')
        if(!file.exists(unmapped.file)){ return(NULL) }
        param <- ScanBamParam(flag = scanBamFlag(isUnmappedQuery=NA)
                              ,tag='NH')
        t <- readGAlignments(mapped.file,
                             param=param)
        tt <- table(values(t)$NH)
        tt <- tt/as.numeric(names(tt))
        counts <- c(unique=tt[as.numeric(names(tt))==1]/1e6,
                    multi.match=sum(tt[as.numeric(names(tt))>1])/1e6,
                    unmapped=countBam(unmapped.file)$records/1e6)
        c(sprintf("%0.1fM",c(sum(counts),counts)),sprintf("%0.1f%%",counts/sum(counts)*100))
        
        nClus <- ifelse(length(topHat.mapped) < nClus,length(topHat.mapped),nClus)
        counts <- t(data.frame(mclapply(topHat.mapped,getNumber,mc.cores=nClus)))
        rownames(counts) <- sub(".+/","",dirname(topHat.mapped))
        colnames(counts) <- c("total reads",
                              "singly mapped",
                              "multiply mapped",
                              "unmapped",
                              "singly mapped (%)",
                              "multiply mapped (%)",
                              "unmapped reads (%)")    
        report <- counts
        save(report, file=reportfile))
        counts
    }
}

## user function - pass desired directory and filename for the report file to be used/created.
## Note! If the reportfile does not already exist, the directory of the reportfile given MUST contain the accepted_hits.bam and unmapped.bam files (the results of running Tophat), and only the ones desired for analysis.
## an example:
## my.reportfile<-paste(./aln/tophat/alignmentreport.rda',sep='');
## runTophatReport(my.reportfile)

runTophatReport <- function(reportfile){
    
    if(!file.exists(reportfile)){
        topHatReport(reportfile)
    }
    load(reportfile)
    x <- data.frame(report)
    ##change all the factors to characters
    for(i in 1:length(x)){
        x[,i] <- as.character(x[,i])
    }
    ##strip the M off
    for(i in 1:4){
        x[,i] <- sub("M", "", x[,i])
    }
    ##strip the % off
    for(i in 5:7){
        x[,i] <- sub("%", "", x[,i])
    }
    ##change all the characters to numbers(for graphing)
    for(i in 1:7){
        x[,i] <- as.numeric(x[,i])
    }
        ## make a matrix of the 
    y <- do.call(rbind, x[,5:7])
    colnames(y) <- row.names(x)
    ##legend.text=rownames(y)
    par(las=2,cex=2)
    barplot(y, beside=TRUE, ylim=c(0,110), col=c("green", "blue", "red"), legend.text=rownames(y), args.legend="topleft", main=paste('Alignment Report'), ylab="Percent of reads")
}
