## use the result from run_tg to create a bargraph of the results
plotTG<- function(gotable){
    ##load our libraries
    library(Rgraphviz)
    library(ggplot2)
    library(plyr)

    colnames(gotable)[colnames(gotable)=='classicFisher'] <- 'Fisher'
    
    gotable$Term <- gsub('(.{1,78})(\\s|$)', '\\1\n', gotable$Term)
    gotable$oTerm <-reorder(gotable$Term, gotable$enrich) #ordered version
    
    ggplot(gotable, aes(y=enrich, x=oTerm, fill=Fisher)) +
        geom_bar(stat="identity",colour='grey',linetype=element_line(size=5)) + scale_fill_gradient(low="white",high="green4") +
            ylab("Enrichment") + xlab("Term") +
                coord_flip() + labs(title="Enriched GO terms") +
                    geom_text(aes(y=.25, label=Term), size=8.5, face="bold", hjust = 0, vjust=.7) +
                        theme(plot.title = element_text(size=28,face="bold"),
                              axis.ticks.y = element_blank(),
                              axis.title=element_text(size=30,face="bold"),
                              axis.text.x=element_text(size=25),
                              axis.text.y=element_blank(),
                              panel.background=element_blank(), 
                              legend.position=c(.9,.2),
                              legend.key.size=unit(1.5,'cm'),
                              legend.title = element_text(size=25), 
                              legend.text = element_text(size=25,hjust=3)
                              )
    
}
