
#' Run ermineJ analysis
#' 
#' The monolith function that wraps the emrineJ cli. It is recommended to use
#' the wrapper functions (\code{\link{ora}}, \code{\link{gsr}},
#' \code{\link{corr}}, \code{\link{roc}}).
#' 
#' @inheritParams annotation
#' @inheritParams scores
#' @inheritParams threshold
#' @inheritParams expression
#' @inheritParams generalStats
#' @param test Method for computing gene set significance
#' @inheritParams iterations 
#' @inheritParams GSRstats
#' @inheritParams geneSetOpts
#' @inheritParams returnOpts
#'
#' @return A list
#' @export
#'
ermineR = function(annotation = NULL, 
                   aspects = c('Molecular Function','Cellular Component', 'Biological Process'),
                   scores = NULL, 
                   hitlist = NULL,
                   scoreColumn = 1, 
                   threshold = 0.001,
                   expression =NULL,
                   bigIsBetter = FALSE, 
                   customGeneSets = NULL,
                   geneReplicates = c('mean','best'), 
                   logTrans = FALSE, 
                   pAdjust = c('FDR','FWE'),
                   test = c('ORA','GSR','CORR','ROC'), 
                   iterations = NULL, 
                   stats = c('mean','quantile','meanAboveQuantile','precisionRecall'),
                   quantile= 50,
                   geneSetDescription = 'Latest_GO', 
                   output = NULL, 
                   return = TRUE,
                   minClassSize = 20, 
                   maxClassSize =200){
    test = match.arg(test)
    pAdjust = match.arg(pAdjust)
    geneReplicates = match.arg(geneReplicates)
    stats = match.arg(stats)
    # set ermineJ home so users won't have to
    ermineJHome = system.file("ermineJ-3.1.2",package = 'ermineR')
    Sys.setenv(ERMINEJ_HOME = ermineJHome)
    
    # find that java home at all costs
    if(Sys.getenv('JAVA_HOME') == ''){
        findJava()
        }
    
    
    arguments = list()
    # get the annotation data.  -------------
    if(is.null(annotation)){
        assertthat::assert_that(!is.null(customGeneSets),msg = 'annotation or customGeneSets must be defined')
        assertthat::assert_that(is.null(hitlist),msg = 'Hitlists require an annotation file to act as a negative set')
        
        annot = vector(mode = 'list',length = nrow(scores))
        names(annot) = rownames(scores)
        annotation = makeAnnotation(annot)
        nullAnnot = TRUE # remember if the annotation was NULL
    } else{
        nullAnnot = FALSE
    }
    
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
    if(is.null(geneSetDescription) | nullAnnot){
        geneSetDescription = system.file('go-minimal.xml',package = 'ermineR') 
    } else if(geneSetDescription == 'Latest_GO'){
        temp = tempfile(fileext = '.xml')
        goToday(temp)
        geneSetDescription = temp
    }else if(!file.exists(geneSetDescription)){
        message('Attempting to download gene set description from link')
        temp = tempfile(fileext = 'xml.gz')
        download.file(url = geneSetDescription,destfile = temp,quiet= TRUE)
        geneSetDescription = temp
    } # and else, geneSetDescription is a local file
    
    assertthat::is.string(geneSetDescription) # geneSetDescription is mandatory
    arguments$geneSetDescription = paste('--classFile',shQuote(geneSetDescription))
    
    # get scores and score columns-------------
    if(test %in% c('ORA','GSR','ROC')){
        # get hitlist if provided instead of scores
        if(test == 'ORA' & is.null(scores) & !is.null(hitlist)){
            logTrans = FALSE
            bigIsBetter = FALSE
            threshold = 0.5
            scoreColumn = 1
            annoFile = readErmineJAnnot(annotation)

            allGenes = annoFile[,1] %>% unique
            
            scores = data.frame(scores = rep(1,length(allGenes)))
            rownames(scores) =allGenes 
            
            scores[hitlist,] = 0
            
            # annotation is created before here.
            
        } else if(test =='ORA' & is.null(scores) & is.null(hitlist)){
            stop("ORA method requires scores or hitlist")
        } else if(!is.null(scores) & !is.null(hitlist)){
            stop("You can't provide both scores and a hitlist")
        }
        
        if(is.null(scores)){
            stop(test,' method requries a score list.')
        }
        assertthat::assert_that('data.frame' %in% class(scores))
        temp = tempfile()
        scores %>% utils::write.table(temp,sep='\t',quote=FALSE)
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
        arguments$expression = paste('--rawData',shQuote(expression))
    } else if(test %in% c('ORA','GSR','ROC') & !is.null(expression)){
        warning('You have provided expression data to use with ',test,' method.',
                ' This is not possible. Gene scores will be ignored. Please refer',
                ' to ermineJ documentation.')
    }
    
    # get custom gene sets --------
    if(is.list(customGeneSets)){
        tempdir = tempfile()
        dir.create(tempdir)
        file.create(file.path(tempdir,'customGeneSet'))
        seq_along(customGeneSets) %>% lapply(function(i){
            cat(glue::glue('{names(customGeneSets)[i]}\tNA\t',
                           customGeneSets[[i]] %>% paste(collapse='\t'),
                           '\n\n'),
                file = file.path(tempdir,'customGeneSet'),append=TRUE)
        })
        customGeneSets = tempdir
    } else if(length(customGeneSets) == 1 && is.character(customGeneSets) && fs::is_dir(customGeneSets)){
        # this is a directory, native ermineJ input, no modification needed
    } else if(is.character(customGeneSets) && all(fs::is_file(customGeneSets))){
        tempdir = tempfile()
        dir.create(tempdir)
        # this makes sure same file names doesn't cause issues
        outnames = basename(customGeneSets) %>%
            sapply(function(x){
                paste0(x, paste(sample(LETTERS,10,TRUE),collapse = ''))
            })
        fs::link_create(normalizePath(customGeneSets), file.path(tempdir,outnames))
        customGeneSets = tempdir
    } else if(is.null(customGeneSets)){
        # this is fine
    } else{
        stop('customGeneSets have to be a list or a character vector pointing to a directory or annotation files.\nSee documentation')
    }
    
    if(!is.null(customGeneSets)){
        arguments$customGeneSets = paste('-f', shQuote(customGeneSets))
    }
    
    # other variables -----
    assertthat::assert_that(all(aspects %in%  c('Molecular Function','Cellular Component', 'Biological Process',
                                                'C','B','M')))
    
    arguments$aspects = aspects %>% sapply(function(x){
        out = switch(x,
               'Molecular Function' = 'M',
               'Cellular Component' = 'C',
               'Biological Process' = 'B')
        if(is.null(out)){
            out = x
        }
        return(out)
    }) %>% paste(collapse='') %>% paste('-aspects',.)
    
    
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
            arguments$iterations = paste('--iters', iterations)
        } else{
            warning('You have provided an iteration count for ',test,' anaylsis. ',
                    'This is not possible. Iterations will be ignored. Please',
                    ' refer to ermineJ documentation')
        }
    }
    
    genesOut = TRUE
    if(genesOut){
        arguments$genesOut='--genesOut'
    }
    if(logTrans){
        arguments$logTrans = '--logTrans'
    }
    arguments$pAdjust = switch(pAdjust,
                               FDR = '--mtc FDR',
                               FWE = '--mtc FWE')
    
    
    arguments$test  = paste('--test', test)

    
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
    
    # set seed here
    arguments$seed = paste('-seed',runif(1)*10^16)
    
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
    
    badJavaHome = "JAVA_HOME is not defined correctly|JAVA_HOME is set to an invalid directory"
    
    
    if(any(grepl(pattern = badJavaHome ,x = response))){
        stop('JAVA_HOME is not defined correctly. Install rJava or use Sys.setenv() to set JAVA_HOME')
    } else if(grepl(pattern = 'No usable gene scores found.',x = response) %>% any){
        stop('No usable gene scores found. Please check you have ',
             'selected the right column, that the file has the correct ',
             'plain text format and that it corresponds to the gene ',
             'annotation file you selected.')
    } else if(any(grepl(pattern = 'Could not reserve enough space for', x = response))){
        stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    }
    
    if(!any(grepl(pattern ='^Done!$',response))){
        stop('Something went wrong. Blame the dev\n',paste(response,collapse= '\n'))
    }
    
    # degub version
    # if(!any(grepl(pattern ='^Done!$',response))){
    #     warning('Something went wrong and I have no idea what. Returning response')
    #     return(response)
    # }
    
    if(return){
        out = readErmineJOutput(output)
        out$details$call = call
        return(out)
    }
}