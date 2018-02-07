# #' Universal inputs
# #' 
# #' @keywords internal
# #' 
# #' @name universalInputs
# NULL
# config file isnt supported
# different annotation styles aren't supported



#' Run ermineJ analysis
#' @inheritParams annotation
#' @inheritParams scores
#' @inheritParams threshold
#' @param expression A file path or a data frame. Expression data. (test = CORR only)
#' Necesary correlation anaylsis. See http://erminej.msl.ubc.ca/help/input-files/gene-expression-profiles/
#' for data format
#' @param customGeneSets Directory path or a named list of character strings.
#' Use this option to create your own gene sets. If you provide directory you can
#' specify probes or gene symbols to include in your gene sets. 
#' See \url{http://erminej.msl.ubc.ca/help/input-files/gene-sets/}
#' for information about format for this file. If you are providing a list, only gene
#' symbols are accepted.
#' @param geneReplicates  What to do when genes have multiple scores in input file
#'  (due to multiple probes per gene)
#' @param genesOut Logical.  Should output include gene symbols for all gene sets 
#' @param logTrans Logical. Should the data be log transformed. Recommended for 
#' p values. \code{FALSE} by default
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
#' @param return If results should be returned. Set to FALSE if you only want a file
#' @param minClassSize minimum class size
#' @param maxClassSize maximum class size
#'
#' @return A list
#' @export
#'
#' @examples
ermineR = function(annotation, 
                   scores = NULL, 
                   scoreColumn = 1, 
                   threshold = 0.001,
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
                   output = NULL, 
                   return = TRUE,
                   minClassSize = 10, 
                   maxClassSize =100){ 
    test = match.arg(test)
    pAdjust = match.arg(pAdjust)
    geneReplicates = match.arg(geneReplicates)
    stats = match.arg(stats)
    
    # set ermineJ home so users won't have to
    ermineJHome = system.file("ermineJ-3.0.3",package = 'ermineR')
    Sys.setenv(ERMINEJ_HOME = ermineJHome)
    
    # find that java home at all costs
    if(Sys.getenv('JAVA_HOME') == ''){
        javaHome = ''
        if(grepl('^darwin',R.version$os)){ # detect macs
            javaHome = system2('/usr/libexec/java_home',stdout = TRUE)
        }
        if(grepl('linux',R.version$os)){
            # if java executable is in path, find it
            javaLink = system2('which', 'java',stdout = TRUE,stderr = TRUE)
            if(length(javaLink) != 0){
                symLink = Sys.readlink(javaLink)
                javaLink = symLink
                while(symLink != ''){
                    javaLink = symLink
                    symLink = Sys.readlink(javaLink)
                }
                if(grepl('jre/bin/java$',javaLink)){
                    javaHome = gsub('/jre/bin/java$','',javaLink)
                } else{
                    # if you are in an unexpected place do not set java home. hope rJava works
                    javaHome = ''
                }
            } else{
                javaHome = ''
            }
        }
        
        # if OS specific methods fail, 
        if(javaHome =='' & 'rJava' %in% installed.packages()){
            rJava::.jinit()
            javaHome = rJava::.jcall('java/lang/System', 'S', 'getProperty', 'java.home')
        }
        
        # if all fails
        if(javaHome == ''){
            stop('JAVA_HOME cannot be detected. Please ')
        }
        Sys.setenv(JAVA_HOME=javaHome)
    }
    
    arguments = list()
    
    # get the annotation data.  -------------
    if('character' %in% class(annotation)){
        if(!file.exists(annotation)){
            message('Attempting to download annotation file')
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
        temp = tempfile(fileext = '.xml.gz')
        download.file('http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz',
                      destfile = temp)
        geneSetDescription = temp
    }else if(!file.exists(geneSetDescription)){
        message('Attempting to download gene set description from link')
        temp = tempfile(fileext = 'xml.gz')
        download.file(url = geneSetDescription,destfile = temp)
    } # and else, geneSetDescription is a local file
    
    assertthat::is.string(geneSetDescription) # geneSetDescription is mandatory
    arguments$geneSetDescription = paste('--classFile',shQuote(geneSetDescription))
    
    # get scores and score columns-------------
    if(test %in% c('ORA','GSR','ROC')){
        if(is.null(scores)){
            stop(test,' method requries a score list.')
        }
        assertthat::assert_that('data.frame' %in% class(scores))
        temp = tempfile()
        scores %>% write.table(temp,sep='\t',quote=FALSE)
        arguments$scores = paste('--scoreFile',shQuote(temp))
        
        # score columns. accept integer or string. If string, convert into integer
        # always add 1 because gemma starts counting from 2
        assertthat::assert_that(
            assertthat::is.number(scoreColumn) | 
                assertthat::is.string(scoreColumn))
        
        if(assertthat::is.string(scoreColumn)){
            scoreColumn = which(names(scores) %in% scoreColumn)
        }
        scoreColumn = scoreColumn +1
        arguments$scoreColumn = paste('--scoreCol',scoreColumn)
    } else if(test == "CORR" & !is.null(scores)){
        warning('You have provided gene scores to use with correlation analysis.',
                ' This is not possible. Gene scores will be ignored. Please refer',
                ' to ermineJ documentation.')
    }
    
    
    # get expression data ------------
    if(test=='CORR'){
        if('data.frame' %in% class(expression)){
            temp = tempfile()
            expression %>% readr::write_tsv(temp)
            expression = temp
        }
        
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
    if(test == 'ORA'){
        assertthat::is.number(threshold)
        arguments$threshold = paste('--threshold', threshold)
    }
    
    if(bigIsBetter){
        arguments$bigIsBetter = '-b'
    }
    
    
    arguments$geneReplicates = paste('--reps',toupper(geneReplicates))
    
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
    
    if(!is.null(output)){
        assertthat::is.string(output)
        arguments$output = paste('--output',shQuote(output))
    }else{
        output = tempfile()
        arguments$output = paste('--output',shQuote(output))
    }
    
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
    
    
    # make the sh call ---------------
    if(Sys.info()['sysname'] =='Windows'){
        ermineExec = file.path(ermineJHome,'bin/ermineJ.bat')
    } else{
        ermineExec = file.path(ermineJHome,'bin/ermineJ.sh')
    }
    
    # system2(shQuote(ermineExec),
    #         args = unlist(arguments))
    call = paste(shQuote(ermineExec),paste(unlist(arguments),collapse = ' '))
    # system(paste(shQuote(ermineExec),paste(unlist(arguments),collapse = ' ')), ignore.stderr = TRUE)
    response = system2(ermineExec,args = arguments, stdout = TRUE, stderr = TRUE)
    if(grepl(pattern = "JAVA_HOME is not defined correctly",x = response[1])){
        stop('JAVA_HOME is not defined correctly. Install rJava or use Sys.setenv() to set JAVA_HOME')
    } else if(grepl(pattern = 'No usable gene scores found.',x = response) %>% any){
        stop('No usable gene scores found. Please check you have ',
             'selected the right column, that the file has the correct ',
             'plain text format and that it corresponds to the gene ',
             'annotation file you selected.')
    }
    
    if(return){
        out = readErmineJOutput(output)
        out$details$call = call
        return(out)
    }
}