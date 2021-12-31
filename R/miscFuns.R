#' List gemma annotations
#' 
#' Returns a vector that has names of all available gemma annotation files that
#' can be automatically downloaded from Gemma for use with ermineR. See \code{annotation}
#' argument in \code{\link{ermineR}} and it's wrappers ()
#' @export
listGemmaAnnotations = function(){
    annots = httr::GET('https://gemma.msl.ubc.ca/annots/')$content %>% rawToChar() %>% XML::getHTMLLinks() %>% 
        {.[grepl('noParents',.)]} %>% stringr::str_extract('.*?(?=_noParents)')
    
    return(annots)
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