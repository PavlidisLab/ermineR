#' Run ORA
#' 
#' @inheritParams scores
#' @inheritParams annotation
#' @inheritParams threshold
#' @inheritParams generalStats
#' @inheritParams geneSetOpts
#' @inheritParams returnOpts
#' @export
ora = function(scores = NULL,
               hitlist = NULL,
               scoreColumn = 1,
               bigIsBetter = FALSE,
               logTrans = FALSE,
               annotation,
               aspects = c('Molecular Function','Cellular Component', 'Biological Process'),
               threshold = 0.001,
               geneReplicates = c('mean','best'),
               pAdjust = c('FDR','Bonferroni'),
               geneSetDescription = 'Latest_GO',
               customGeneSets = NULL,
               minClassSize = 20,
               maxClassSize = 200,
               output = NULL,
               return = TRUE){
    args = as.list(match.call())[-1]
    args = c(args,list(test = 'ORA'))
    do.call(ermineR, args,envir = new.env())
}


#'Run GSR
#'
#' @inheritParams scores
#' @inheritParams annotation
#' @inheritParams iterations
#' @inheritParams GSRstats
#' @inheritParams generalStats
#' @inheritParams geneSetOpts
#' @inheritParams returnOpts
#' 
#' @export
gsr = function(scores,
               scoreColumn = 1,
               bigIsBetter = FALSE,
               logTrans = FALSE,
               annotation,
               aspects = c('Molecular Function','Cellular Component', 'Biological Process'),
               iterations,
               stats =  c('mean','quantile','meanAboveQuantile','precisionRecall'),
               quantile = 50,
               geneReplicates = c('mean','best'),
               pAdjust = c('FDR','Bonferroni'),
               geneSetDescription = 'Latest_GO',
               customGeneSets = NULL,
               minClassSize = 20,
               maxClassSize = 200,
               output = NULL,
               return = TRUE){
    args = as.list(match.call())[-1]
    args = c(args,list(test = 'GSR'))
    do.call(ermineR, args,envir = new.env())
}


#' Run Precision-recall
#' 
#' @inheritParams scores
#' @inheritParams annotation
#' @inheritParams iterations
#' @inheritParams generalStats
#' @inheritParams geneSetOpts
#' @inheritParams returnOpts
precRecall = function(scores,
                      scoreColumn = 1,
                      bigIsBetter = FALSE,
                      logTrans = FALSE,
                      annotation,
                      aspects = c('Molecular Function','Cellular Component', 'Biological Process'),
                      iterations,
                      geneReplicates = c('mean','best'),
                      pAdjust =c('FDR','Bonferroni'),
                      geneSetDescription = 'Latest_GO',
                      customGeneSets = NULL,
                      minClassSize = 20,
                      maxClassSize = 200,
                      output = NULL,
                      return = TRUE){
    args = as.list(match.call())[-1]
    args = c(args,list(test = 'GSR',stats ='precisionRecall'))
    do.call(ermineR, args,envir = new.env())
}


#' Run CORR
#' 
#' @inheritParams expression
#' @inheritParams annotation
#' @inheritParams iterations
#' @inheritParams generalStats
#' @inheritParams geneSetOpts
#' @inheritParams returnOpts
#' 
#' @export
corr = function(expression,
                annotation,
                aspects = c('Molecular Function','Cellular Component', 'Biological Process'),
                iterations,
                geneReplicates = c('mean','best'),
                pAdjust = c('FDR','Bonferroni'),
                geneSetDescription = 'Latest_GO',
                customGeneSets = NULL,
                minClassSize = 20,
                maxClassSize = 200,
                output = NULL,
                return = TRUE){
    args = as.list(match.call())[-1]
    args = c(args,list(test = 'CORR'))
    do.call(ermineR, args,envir = new.env())
}

#' Run ROC
#' 
#' @inheritParams scores
#' @inheritParams annotation
#' @inheritParams generalStats
#' @inheritParams geneSetOpts
#' @inheritParams returnOpts
#' 
#' @export
roc = function(scores,
               scoreColumn = 1,
               bigIsBetter = FALSE,
               logTrans = FALSE,
               annotation,
               aspects = c('Molecular Function','Cellular Component', 'Biological Process'),
               geneReplicates = c('mean','best'),
               pAdjust = c('FDR','Bonferroni'),
               geneSetDescription = 'Latest_GO',
               customGeneSets = NULL,
               minClassSize = 20,
               maxClassSize = 200,
               output = NULL,
               return = TRUE){
    
    args = as.list(match.call())[-1]
    args = c(args,list(test = 'ROC'))
    do.call(ermineR, args,envir = new.env())
}
