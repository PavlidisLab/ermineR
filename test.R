# JAVA_HOME needs to be set from .Renvionment
# export JAVA_HOME=/usr/lib/jvm/default-java
Sys.setenv(JAVA_HOME="/usr/lib/jvm/default-java")
ermineJHome = system.file("ermineJ-3.0.3",package = 'ermineR')
Sys.setenv(ERMINEJ_HOME = ermineJHome)


system('inst/ermineJ-3.0.3/bin/ermineJ.sh')


.jinit(); .jcall( 'java/lang/System', 'S', 'getProperty', 'java.home' )
Sys.getenv(x = 'JAVA_HOME', unset = "", names = NA)



ermineR = function(annotation, # can be a file or a DF
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
    
    
    
    
}