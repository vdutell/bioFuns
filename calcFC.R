##function to calculate fold change given two vectors of expression values
calc.fc <- function(va,vb){  
    va <- va+.1
    vb <- vb+.1
    fc.pos <- vb/va
    fc.neg <- va/vb
    ##make TRUE/FALSE vectors for lessthan/greaterthan
    pos.v <- fc.pos*(fc.pos >= fc.neg)
    neg.v <- fc.neg*(fc.neg > fc.pos)
    ##return the value that was TRUE
    return(as.numeric(pos.v - neg.v))
}

#log fold change calculation function
calc.log.fc <- function(va,vb){  
    va <- va+.1
    vb <- vb+.1
    fc.pos <- vb/va
    fc.neg <- va/vb
    ##make TRUE/FALSE vectors for lessthan/greaterthan
    pos.v <- log2(fc.pos)*(fc.pos >= fc.neg)
    neg.v <- log2(fc.neg)*(fc.neg > fc.pos)
    ##return the value that was TRUE
    return(as.numeric(pos.v - neg.v))
}  
