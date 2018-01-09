# JAVA_HOME needs to be set from .Renvionment
# export JAVA_HOME=/usr/lib/jvm/default-java
Sys.setenv(JAVA_HOME="/usr/lib/jvm/default-java")
ermineJHome = system.file("ermineJ-3.0.3",package = 'ermineR')
Sys.setenv(ERMINEJ_HOME = ermineJHome)


system('inst/ermineJ-3.0.3/bin/ermineJ.sh')


.jinit(); .jcall( 'java/lang/System', 'S', 'getProperty', 'java.home' )
Sys.getenv(x = 'JAVA_HOME', unset = "", names = NA)




#' Run ermineJ analysis
#'
#' @param annotation Annotation. A file path, a data.frame or a platform short 
#' name (eg. GPL127). If given a platform short name it will be downloaded
#' from annotation repository of Pavlidis Lab (ErmineJ format). Note that if there
#' is a file with the same name as the 
#' @param annotationFormat Format of the annotation. \code{"ErmineJ"} for the 
#' format of the files provided by Pavlidis Lab. \code{"Agilent"} and 
#' \code{"Affymetrix"} for files provided by the 
#' @param bigIsBetter 
#' @param configFile 
#' @param geneSetDescription 
#' @param scoreFile 
#' @param scoreColumn 
#' @param filterNonSpecific 
#' @param geneReplicates 
#' @param iterations 
#' @param genesOut 
#' @param logTrans 
#' @param pAdjust 
#' @param test 
#' @param multifunctionalityCorrection 
#' @param outFile 
#' @param quantile 
#' @param expression 
#' @param minClassSize 
#' @param maxClassSize 
#'
#' @return
#' @export
#'
#' @examples
ermineR = function(annotation, # can be a file path, data.frame or the platform short name
                   annotationFormat = c('ErmineJ','Affy CSV','Agilent'), # not sure how to set up for agilent
                   bigIsBetter = FALSE, 
                   configFile = NULL,
                   geneSetDescription = 'Latest_GO', # if "Latest_GO" download the latest one, otherwise provide file path
                   # dataDir = NULL,
                   scoreFile = NULL,
                   scoreColumn = 2,
                   filterNonSpecific = TRUE,
                   geneReplicates = c('mean','best'),
                   iterations = NULL,
                   genesOut = FALSE,
                   logTrans = FALSE,
                   pAdjust = c('FDR','Westfall-Young'),
                   test = c('ORA','GSR','CORR','ROC'),
                   multifunctionalityCorrection = TRUE,
                   outFile,
                   quantile = 50,
                   expression,
                   minClassSize = 10,
                   maxClassSize =100){
    
    # iterations are mandatory for GSR and CORR
    # scoreFile and scoreColumn mandatory for  all but CORR
    # expression is only used by CORR
    
    ermineJHome = system.file("ermineJ-3.0.3",package = 'ermineR')
    Sys.setenv(ERMINEJ_HOME = ermineJHome)
    
    if(class(annotation)=='character'){
        if(!file.exists(annotation)){
            plaftorm = tryCatch(XML::getHTMLLinks('http://www.chibi.ubc.ca/microannots'),
                                          error = function(e){
                                              stop('"annotation" is not a valid file or exists in Pavlidis lab annotations. See http://www.chibi.ubc.ca/microannots for available options.')
                                          })
        }
    }
    
    
    
    
}