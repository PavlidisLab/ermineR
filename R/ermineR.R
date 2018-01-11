
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
#' for information about format for this file. (for test = ORA, GSR and ROC)
#' @param scoreColumn Integer. Which column of the \code{scores} includes the scores  (for test = ORA, GSR and ROC)
#' @param expression A file path or a data frame. Expression data. (test = CORR only)
#' Necesary correlation anaylsis. See http://erminej.msl.ubc.ca/help/input-files/gene-expression-profiles/
#' for data format
#' @param bigIsBetter Logical. If TRUE large scores are considered to be higher.
#' \code{FALSE} by default (as in p values).
#' @param customGeneSets Directory path or a named list of character strings.
#' Use this option to create your own gene sets. If you provide directory you can
#' specify probes or gene symbols to include in your gene sets. 
#' See \url{http://erminej.msl.ubc.ca/help/input-files/gene-sets/}
#' for information about format for this file. If you are providing a list, only gene
#' symbols are accepted.
#' @param filterNonSpecific Logical. Filter out non-specific probes
#' @param geneReplicates  What to do when genes have multiple scores in input file
#'  (due to multiple probes per gene)
#' @param genesOut Logical.  Should output include gene symbols for all gene sets 
#' @param logTrans Logical. Should the data be log transformed. Recommended for 
#' p values. \code{TRUE} by default
#' @param pAdjust Which multiple test correction method to use. Can be "FDR" or
#' 'Westfall-Young' (slower).
#' @param test Method for computing gene set significance
#' @param iterations Number of iterations (test = GSR and CORR methods only)
#' @param stats Method for computing raw class statistics (test = GSR only)
#' @param quantile Integer. Quantile to use. (stats = meanAboveQuantile only)
#' @param geneSetDescription "Latest_GO", a file path that leads to a GO XML file
#' or a URL that leads to a go ontology file that ends with rdf-xml.gz. Note that
#' this is a mandatory argument. It defaults to Latest_GO but that option won't
#' work if you don't have a working internet connection. See \url{http://erminej.msl.ubc.ca/help/input-files/gene-set-descriptions/}
#' for details
#' @param multifunctionalityCorrection Logical. Should the resutls be corrected 
#' for multifunctionality.
#' @param output Output file name.
#' @param minClassSize minimum class size
#' @param maxClassSize maximum class size
#'
#' @return
#' @export
#'
#' @examples
ermineR = function(annotation, 
                   scores = NULL, 
                   scoreColumn = 2, 
                   expression =NULL,
                   bigIsBetter = FALSE, 
                   customGeneSets = NULL,
                   filterNonSpecific = TRUE, 
                   geneReplicates = c('mean','best'),
                   genesOut = FALSE, 
                   logTrans = FALSE, 
                   pAdjust = c('FDR','Westfall-Young'),
                   test = c('ORA','GSR','CORR','ROC'), 
                   iterations = NULL, 
                   stats = c('mean','quantile','meanAboveQuantile','precisionRecall'),
                   quantile= 50,
                   geneSetDescription = 'Latest_GO', 
                   multifunctionalityCorrection = TRUE, 
                   output, 
                   minClassSize = 10, 
                   maxClassSize =100){ 
    
    test = match.arg(test)
    pAdjust = match.arg(pAdjust)
    geneReplicates = match.arg(geneReplicates)
    stats = match.arg(stats)
    
    # set ermineJ home so users won't have to
    ermineJHome = system.file("ermineJ-3.0.3",package = 'ermineR')
    Sys.setenv(ERMINEJ_HOME = ermineJHome)
    
    arguments = list()
    
    # get the annotation data.  -------------
    if('character' %in% class(annotation)){
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
    arguments$geneSetDescription = paste('--classFile',shQuote(geneSetDescription))
    
    # get scores -------------
    if ('data.frame' %in% class(scores)){
        temp = tempfile()
        scores %>% readr::write_tsv(temp)
        scores = temp
    } # otherwise it is a character that leads to a score file
    
    if(test %in% c('ORA','GSR','ROC')){
        if(is.null(scores)){
            stop(test,' method requries a score list.')
        }
        arguments$scores = paste('--scoreFile',shQuote(scores))
    } else if(test == 'CORR' & !is.null(scores)){
        warning('You have provided gene scores to use with correlation analysis.',
                ' This is not possible. Gene scores will be ignored. Please refer',
                ' to ermineJ documentation.')
    }
    
    # get expression data -------------
    if('data.frame' %in% class(expression)){
        temp = tempfile()
        expression %>% readr::write_tsv(temp)
        expression = temp
    }
    
    if(test=='CORR'){
        if(is.null(expression)){
            stop('CORR method requires expression data')
        }
        arguments(expression) = paste('--rawData',shQuote(expression))
    } else if(test %in% c('ORA','GSR','ROC') & !is.null(expression)){
        warning('You have provided expression data to use with ',test,' method.',
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
    
    if(test == 'GSR'){
        stats = switch(stats,
                       mean = 'MEAN',
                       quantile = 'QUANTILE',
                       meanAboveQuantile = 'MEAN_ABOVE_QUANTILE',
                       precisionRecall = 'PRECISIONRECALL')
        
        arguments$stats = paste('--stats',stats)
        if(stats =='MEAN_ABOVE_QUANTILE'){
            assertthat::is.number(quantile)
            arguments$quantile = paste('--quantile',quantile)
        }
    } # no warning because there's a default
    
    assertthat::is.number(scoreColumn)
    arguments$scoreColumn = paste('--scoreCol',scoreColumn)
    
    
    # make the sh call ---------------
    if(Sys.info()['sysname'] =='Windows'){
        ermineExec = file.path(ermineJHome,'bin/ermineJ.bat')
    } else{
        ermineExec = file.path(ermineJHome,'bin/ermineJ.sh')
    }
    
    browser()
    
    # system2(shQuote(ermineExec),
    #         args = unlist(arguments))
    
    system(paste(shQuote(ermineExec),paste(unlist(arguments),collapse = ' ')))


}