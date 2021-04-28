
#' goToday
#' 
#' Downloads latest gene ontology term information (not gene annotations)
#'
#' @param path File path
#' @param overwrite If TRUE, overwrites existing file
#'
#' @export
goToday = function(path,overwrite = FALSE){
    if(exists(path) & !overwrite){
        stop('File exists, not downloading')
    }
    utils::download.file('http://purl.obolibrary.org/obo/go.obo',
                         destfile = paste0(path),quiet= TRUE)
}

#' getGoDates
#' 
#' Get all dates for which a version of the GO is available. Any date returned here can be used as an input of
#' \code{\link{goAtDate}}
#' @export
getGoDates = function(){
    # check the links to use. for soime reason archive link is faster
    files = 
        RCurl::getURL('ftp://ftp.geneontology.org/pub/go/godatabase/archive/termdb/',dirlistonly = TRUE,ftp.use.epsv=TRUE)
    
    files = RCurl::getURL('http://release.geneontology.org/')
    
    # dates = files %>% strsplit('a href') %>% {.[[1]]} %>% {.[grepl(x = .,pattern = '[0-9]+?-[0-9]+?-[0-9]+(?=/)',perl = TRUE)]} %>% 
    #     stringr::str_extract( '[0-9]+?-[0-9]+?-[0-9]+(?=/)')
    files %<>% strsplit('\n') %>% {.[[1]]} %>% {.[grepl(pattern = '[0-9]+?-[0-9]+?-[0-9]+', .)]}
    
    rev(files)
}


#' goAtDate
#' 
#' Get GO terms from a particular date. Use \code{\link{getGoDates}} to see which
#' dates are available
#'
#' @param path File path. Without gz extension
#' @param date Character. A valid date as returned from \code{\link{getGoDates}}.
#' @param overwrite If TRUE, overwrites existing file
#'
#' @export
goAtDate = function(path, date, overwrite = FALSE){
    if(exists(path)){
        stop('File exists. Not overwriting')
    }
    utils::download.file(
        glue::glue('http://archive.geneontology.org/termdb/{date}/go_daily-termdb.rdf-xml.gz'),
                         destfile = paste0(path,'.gz'),quiet= TRUE)
    R.utils::gunzip(paste0(path,'.gz'),overwrite = overwrite)  
}


#' makeAnnotation
#' 
#' Make an annotation object
#' 
#' @param annotationList A list of go terms for each gene identifier. Gene identifiers
#' are the names of the list, each element of the list should have character vectors
#' with go terms in
#' @param symbol Option gene symbols. If not provided IDs from annotation list
#' will be used
#' @param name Optional gene name
#' @inheritParams returnOpts
#' @export
makeAnnotation = function(annotationList,
                          symbol = names(annotationList), 
                          name = NULL,
                          output = NULL,
                          return = TRUE){
    
    IDs = names(annotationList)
    goTerms  = annotationList %>% purrr::map_chr(paste,collapse = '|')
    if(is.null(name)){
        name = ' '
    }
    data.frame(IDs, GeneSymbols = symbol,GeneNames = name, 
               GOTerms = goTerms, 
               stringsAsFactors = FALSE)
    
}
