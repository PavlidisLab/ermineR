#' @export
getGemmaAnnot = function(chipName,chipFile,annotType = c('bioProcess','noParents','allParents'), 
                         overwrite=FALSE){
    
    annotType = match.arg(annotType)
    if (annotType == 'allParents'){
        annotType = ''
    } else{
        annotType = paste0('_',annotType)
    }
    if(file.exists(chipFile) & !overwrite){
        print('the file already exists. not overwriting')
        return(FALSE)
    }
    download.file(paste0('http://chibi.ubc.ca/microannots/',chipName,annotType,'.an.txt.gz'),
                  paste0(chipFile,'.gz'))
    
    out = system(paste0('gunzip -f ', chipFile,'.gz'))
    if(out==0){
        return(TRUE)
    } else{
        return(FALSE)
    }
}