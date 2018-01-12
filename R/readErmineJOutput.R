
#' Read ermineJ output files
#'
#' @param output File location
#'
#' @return A data.frame
#' @export
readErmineJOutput = function(output){
    dataStart = readLines(output,100) %>% grep(x = .,pattern = '#!') %>% max
    out = suppressMessages(suppressWarnings(
        readr::read_tsv(output,skip = dataStart-1,col_names=TRUE)
        ))
    out = out[1:(nrow(out)-1),2:ncol(out)]
}