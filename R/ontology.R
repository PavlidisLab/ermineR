
#' goToday
#' 
#' Downloads latest go ontology
#'
#' @param path File path. Without gz extension
#' @param overwrite If TRUE, overwrites existing file
#'
#' @return
#' @export
#'
#' @examples
goToday = function(path,overwrite = FALSE){
    if(exists(path) & !overwrite){
        stop('File exists, not downloading')
    }
    utils::download.file('http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz',
                         destfile = paste0(path,'.gz'),quiet= TRUE)
    R.utils::gunzip(paste0(path,'.gz'),overwrite = overwrite)    
}

#' getGoDates
#' 
#' Get all available go dates. Any date returned here can be used as an input of
#' \code{\link{goAtDate}}
#' @export
getGoDates = function(){
    # check the links to use. for soime reason archive link is faster
    files = 
        RCurl::getURL('ftp://ftp.geneontology.org/pub/go/godatabase/archive/termdb/',dirlistonly = TRUE,ftp.use.epsv=TRUE)
    
    # dates = files %>% strsplit('a href') %>% {.[[1]]} %>% {.[grepl(x = .,pattern = '[0-9]+?-[0-9]+?-[0-9]+(?=/)',perl = TRUE)]} %>% 
    #     stringr::str_extract( '[0-9]+?-[0-9]+?-[0-9]+(?=/)')
    files %<>% strsplit('\n') %>% {.[[1]]} %>% {.[grepl(pattern = '[0-9]+?-[0-9]+?-[0-9]+', .)]}
    
    rev(files)
}


#' goAtDate
#' 
#' Get Go terms from a particular date. Use \code{\link{getGoDates}} to see which
#' dates are available
#'
#' @param path File path. Without gz extension
#' @param date Character. A valid date as returned from \code{\link{getGoDates}}.
#' @param overwrite If TRUE, overwrites existing file
#'
#' @return
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