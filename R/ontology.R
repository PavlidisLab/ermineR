
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
    utils::download.file('http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz',
                         destfile = paste0(path,'.gz'),quiet= TRUE)
    R.utils::gunzip(paste0(path,'.gz'),overwrite = overwrite)    
}
