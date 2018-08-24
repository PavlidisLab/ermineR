
#' Read ermineJ output files
#'
#' @param output File location
#'
#' @return A data.frame
#' @export
readErmineJOutput = function(output){
    fileHead = readLines(output,100,warn = FALSE)
    dataStart = fileHead %>% grep(x = .,pattern = '#!') %>% max
    frame = suppressMessages(suppressWarnings(
        readr::read_tsv(output,skip = dataStart-1,col_names=TRUE)
        ))
    
    if(!is.numeric(frame$Pval)){
        frame = suppressMessages(suppressWarnings(
            readr::read_tsv(output,skip = dataStart-1,col_names=TRUE, locale = readr::locale(decimal_mark = ','))
        ))
    }
    frame = frame[1:(nrow(frame)-1),2:ncol(frame)]
    
    settingsStart = fileHead %>% grep(x = .,pattern = 'Settings')
    settingsEnd = fileHead %>%  grep(x = .,pattern = '#!----')
    
    details = readLines(output,n = settingsEnd-1)
    details = details[(settingsStart+1):length(details)]
    details %<>% strsplit('=')
    names(details) = details %>% purrr::map_chr(1) %>% trimws()
    details %<>% purrr::map(2) %>% purrr::map(trimws)
    suppressWarnings({doublables = details %>% purrr::map(as.double)})
    details[!is.na(doublables)] = doublables[!is.na(doublables)]
    
    return(list(results = frame,
                details = details))
}

#' Read ermineJ annotation files files
#'
#' @param annotation File location
#'
#' @return A data.frame
#' @export
readErmineJAnnot = function(annotation){
    fileHead = readLines(annotation,20)
    toSkip = fileHead %>% grep(x = .,pattern = '^#') %>% {suppressWarnings(max(.))} %>% max(.,0)
    annoFile = read.table(annotation, header=T,sep='\t', quote="", 
                          stringsAsFactors = F,comment.char = '',skip = toSkip)
    return(annoFile)
}
