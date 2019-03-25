#' List gemma annotations
#' 
#' Returns a vector that has names of all available gemma annotation files that
#' can be automatically downloaded from Gemma for use with ermineR. See \code{annotation}
#' argument in \code{\link{ermineR}} and it's wrappers ()
#' @export
listGemmaAnnotations = function(){
    annots =
        XML::getHTMLLinks(RCurl::getURL('https://gemma.msl.ubc.ca/annots/')) %>% 
        {.[grepl('noParents',.)]} %>% stringr::str_extract('.*?(?=_noParents)')
    return(annots)
}

#' Get annotation files from gemma
#' 
#' @param chipName Name of platform. Use \code{\link{listGemmaAnnotations}} to get
#' a list of valid platform names.
#' @param chipFile Name of the output file.
#' @param annotType Type of annotation to download. ErmineR typically uses "noParents"
#' @param overwrite Should it overwrite an existing file?
#' 
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
    download.file(paste0('https://gemma.msl.ubc.ca/annots/',chipName,annotType,'.an.txt.gz'),
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