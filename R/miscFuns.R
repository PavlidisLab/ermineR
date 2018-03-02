#' @export
getGemmaAnnot = function(chipName,chipFile,annotType = c('noParents','bioProcess','allParents'), 
                         overwrite=FALSE){
    
    annotType = match.arg(annotType)
    if (annotType == 'allParents'){
        annotType = ''
    } else{
        annotType = paste0('_',annotType)
    }
    if(file.exists(chipFile) & !overwrite){
        warning('annotation file already exists. not overwriting')
        return(FALSE)
    }
    download.file(paste0('http://chibi.ubc.ca/microannots/',chipName,annotType,'.an.txt.gz'),
                  paste0(chipFile,'.gz'))
    
    R.utils::gunzip(paste0(chipFile,'.gz'), overwrite = TRUE)
    
}

#' Get genes for a term
#' 
#' Gets genes for a go term that was available in the analysis
#' 
#' @param result An ermineJ output as returned by \code{\link{ermineR}} and it's
#' wrapper functions (\code{\link{ora}}, \code{\link{gsr}}, \code{\link{corr}},
#' \code{\link{roc}})
#' @param goTerms A go term (eg. 'GO:0007218') or term name ('neuropeptide signaling pathway')
#' 
#' @return A vector of gene names, annotated with the GO term
#' 
#' @export
getGoGenes = function(result,goTerm){
    result$results$GeneMembers[
        result$results$ID %in% goTerm | result$results$Name %in% goTerm] %>%
        strsplit('\\|') %>% {.[[1]]}
}