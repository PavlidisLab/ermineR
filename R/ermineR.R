
# config file isnt supported
# different annotation styles aren't supported

#' Run ermineJ analysis
#'
#' @param annotation Annotation. A file path, a data.frame or a platform short 
#' name (eg. GPL127). If given a platform short name it will be downloaded
#' from annotation repository of Pavlidis Lab (\url{www.chibi.ubc.ca/microannots/}). 
#' Note that if there is a file or folder with the same name as the platform 
#' name in the directory, that file will be read instead of getting a copy from 
#' Pavlidis Lab. If this file isn't a valid annotation file, the function will fail.
#' If providing a custom annotation file, see
#' \url{erminej.msl.ubc.ca/help/input-files/gene-annotations/}
#' @param scores A file path or a data.frame. See \url{http://erminej.msl.ubc.ca/help/input-files/gene-scores/}
#' for information about format for this file.
#' @param scoreColumn Integer. Which column of the \code{scores} includes the scores
#' @param bigIsBetter Logical. If TRUE large scores are considered to be higher.
#' \code{FALSE} by default (as in p values).
#' @param customGeneSets Directory path or a named list of character strings.
#' Use this option to create your own gene sets. If you provide directory you can
#' specify probes or gene symbols to include in your gene sets. 
#' See \url{http://erminej.msl.ubc.ca/help/input-files/gene-sets/}
#' for information about format for this file. If you are providing a list, only gene
#' symbols are accepted.
#' @param filterNonSpecific 
#' @param geneReplicates 
#' @param iterations 
#' @param genesOut Logical. Should output include gene symbols
#' @param logTrans Logical. Should the data be log transformed. Recommended for 
#' p values. \code{TRUE} by default
#' @param pAdjust Which multiple test correction method to use. Can be "FDR" or
#' 'Westfall-Young' (slower).
#' @param test 
#' @param geneSetDescription "Latest_GO", a file path that leads to a GO XML file
#' or a URL that leads to a go ontology file that ends with rdf-xml.gz. Note that
#' this is a mandatory argument. It defaults to Latest_GO but that option won't
#' work if you don't have a working internet connection. See \url{http://erminej.msl.ubc.ca/help/input-files/gene-set-descriptions/}
#' for details
#' @param multifunctionalityCorrection 
#' @param output 
#' @param quantile 
#' @param expression A file path or a data frame.Expression data. 
#' Necesary correlation anaylsis. See http://erminej.msl.ubc.ca/help/input-files/gene-expression-profiles/
#' for data format
#' @param minClassSize 
#' @param maxClassSize 
#'
#' @return
#' @export
#'
#' @examples
ermineR = function(annotation, #
                   scores = NULL, #
                   scoreColumn = 2, #
                   bigIsBetter = FALSE, # 
                   customGeneSets = NULL, #
                   filterNonSpecific = TRUE, # 
                   geneReplicates = c('mean','best'), # 
                   iterations = NULL, # 
                   genesOut = FALSE, # 
                   logTrans = FALSE, # 
                   pAdjust = c('FDR','Westfall-Young'), #
                   test = c('ORA','GSR','CORR','ROC'), # 
                   geneSetDescription = 'Latest_GO', # 
                   multifunctionalityCorrection = TRUE, # 
                   output, # 
                   # quantile = 50,
                   expression =NULL,
                   minClassSize = 10,
                   maxClassSize =100){
    
    test = match.arg(test)
    pAdjust = match.arg(pAdjust)
    geneReplicates = match.arg(geneReplicates)
        
    # set ermineJ home so users won't have to
    ermineJHome = system.file("ermineJ-3.0.3",package = 'ermineR')
    Sys.setenv(ERMINEJ_HOME = ermineJHome)
    
    # iterations are mandatory for GSR and CORR
    # scoreFile and scoreColumn mandatory for  all but CORR
    # expression is only used by CORR
    
    ermineJHome = system.file("ermineJ-3.0.3",package = 'ermineR')
    Sys.setenv(ERMINEJ_HOME = ermineJHome)
    
    arguments = list()
    
    # get the annotation data.  -------------
    if(class(annotation)=='character'){
        if(!file.exists(annotation)){
            print('Attempting to download annotation file')
            tryCatch(suppressWarnings(getGemmaAnnot(annotation,
                                                    chipFile = annotation,
                                                    annotType = 'noParents')),
                     error = function(e){
                         stop('"annotation" is not a valid file or exists in Pavlidis lab annotations. See http://www.chibi.ubc.ca/microannots for available options.')
                     })
        }
    } else if('data.frame' %in% class(annotation)) {
        temp = tempfile()
        annotation %>% readr::write_tsv(temp)
        annotation = temp # replace the annotation object with the newly created file name
    }
    
    assertthat::is.string(annotation) # annotation is mandatory
    arguments$annotation = paste('--annots',shQuote(annotation))
    
    # get gene set descriptions -------------
    if(geneSetDescription == 'Latest_GO'){
        temp = tempfile(fileext = 'xml.gz')
        download.file('http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz',
                      destfile = temp)
        geneSetDescription = temp
    }else if(!file.exists(geneSetDescription)){
        print('Attempting to download gene set description from link')
        temp = tempfile(fileext = 'xml.gz')
        download.file(url = geneSetDescription,destfile = temp)
    } # and else, geneSetDescription is a local file
    
    assertthat::is.string(geneSetDescription) # geneSetDescription is mandatory
    arguments$geneSetDescription = paste('--scoreCol',shQuote(geneSetDescription))
    
    # get scores -------------
    if ('data.frame' %in% class(scores)){
        temp = tempfile()
        scores %>% readr::write_tsv(temp)
        scores = temp
    } # otherwise it is a character that leads to a score file
    
    if(!test %in% c('ORA','GSR','ROC')){
        arguments$scores = paste('--scoreFile',scores)
    } else if(test == 'CORR' & !is.null(scores)){
        warning('You have provided gene scores to use with correlation analysis.',
                ' This is not possible. Gene scores will be ignored. Please refer',
                ' to ermineJ documentation.')
    }
    
    # get custom gene sets --------
    if(is.list(customGeneSets)){
        tempdir = tempdir()
        file.create(file.path(tempdir,'customGeneSet'))
        seq_along(customGeneSets) %>% lapply(function(i){
            cat(glue::glue('{names(customGeneSets)[i]}\tNA\t',
                           customGeneSets[[i]] %>% paste(collapse='\t'),
                           '\n\n'),
                file = file.path(tempdir,'customGeneSet'),append=TRUE)
        })
        customGeneSets = tempdir
    } # otherwise character leading to a directory
    if(!is.null(customGeneSets)){
        arguments$customGeneSets = paste('-f', shQuote(customGeneSets))
    }
    
    # other variables -----
    if(bigIsBetter){
        arguments$bigIsBetter = '-b'
    }
    
    if(filterNonSpecific){
        arguments$filterNonSpecific = '--filterNonSpecific'
    }
    
    arguments$geneReplicates = toupper(geneReplicates)
    
    if(!is.null(iterations)){
        if(test %in% c('GSR','CORR')){
            assertthat::is.number(iterations)
            arguments$iterations = paste('--iters', iters)
        } else{
            warning('You have provided an iteration count for ',test,' anaylsis. ',
                    'This is not possible. Iterations will be ignored. Please',
                    ' refer to ermineJ documentation')
        }
    }
    
    if(genesOut){
        arguments$genesOut='--genesOut'
    }
    if(logTrans){
        arguments$logTrans = '--logTrans'
    }
    arguments$pAdjust = switch(pAdjust,
                               FDR = '--mtc BENJAMINIHOCHBERG',
                               'Westfall-Young' = '--mtc WESTFALLYOUNG')
    
    
    arguments$test = paste('--test', test)
    
    if(!multifunctionalityCorrection){
        arguments$multifunctionalityCorrection = '-nomf'
    }
    
    assertthat::is.string(output)
    arguments$output = paste('--output',shQuote(output))
    
    assertthat::is.number(minClassSize)
    arguments$minClassSize = paste('--minClassSize',minClassSize)
    assertthat::is.number(maxClassSize)
    arguments$maxClassSize = paste('--maxClassSize',maxClassSize)
    
    # make the sh call ---------------
    if(Sys.info()['sysname' =='Windows']){
        ermineExec = file.path(ermineJHome,'bin/ermineJ.bat')
    } else{
        ermineExec = file.path(ermineJHome,'bin/ermineJ.sh')
    }
    
    system2(shQuote(ermineExec),
            args = unlist(arguments))


}