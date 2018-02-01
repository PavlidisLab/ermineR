
#' Read ermineJ output files
#'
#' @param output File location
#'
#' @return A data.frame
#' @export
readErmineJOutput = function(output){
    fileHead = readLines(output,100)
    dataStart = fileHead %>% grep(x = .,pattern = '#!') %>% max
    frame = suppressMessages(suppressWarnings(
        readr::read_tsv(output,skip = dataStart-1,col_names=TRUE)
        ))
    frame = out[1:(nrow(out)-1),2:ncol(out)]
    
    settingsStart = fileHead %>% grep(x = .,pattern = 'Settings')
    settingsEnd = fileHead %>%  grep(x = .,pattern = '#!----')
    
    details = readLines(output,n = settingsEnd-1)
    details = details[(settingsStart+1):length(details)]
    details %<>% strsplit('=')
    names(details) = details %>% purrr::map_chr(1) %>% trimws()
    details %<>% purrr::map(2) %>% purrr::map(trimws)
    suppressWarnings({doublables = details %>% map(as.double)})
    details[!is.na(doublables)] = doublables[!is.na(doublables)]
    
    return(list(results = frame,
                details = details))
}
