
#' scores
#' 
#' @keywords internal ORA GSR ROC
#' 
#' @name scores
#' 
#' @param scores A data.frame. Rownames have to be gene identifiers, followed by
#' any number of columns. The column used for scoring is chosen by \code{scoreColumn}.
#' See \url{http://erminej.msl.ubc.ca/help/input-files/gene-scores/}
#' for information abot how to specify scores. (for test = ORA, GSR and ROC)
#' @param scoreColumn Integer or character. Which column of the \code{scores} data.frame
#' to use as scores. Defaults to first column of \code{scores}. See
#' \url{http://erminej.msl.ubc.ca/help/input-files/gene-scores/} for details.
#' (for test = ORA, GSR and ROC)
#' @param bigIsBetter Logical. If TRUE large scores are considered to be higher.
#' \code{FALSE} by default (as in p values).
#' @param logTrans Logical. Should the data be log transformed. Recommended for 
#' p values. \code{FALSE} by default
#' 
scores = function(scores,
                  scoreColumn = 1,
                  bigIsBetter = FALSE,
                  logTrans = FALSE){}

#' annotation
#' 
#' @keywords internal universal
#' 
#' @name annotation
#' 
#' @param annotation Annotation. A file path, a data.frame or a platform short 
#' name (eg. GPL127). If given a platform short name it will be downloaded
#' from annotation repository of Pavlidis Lab (\url{www.chibi.ubc.ca/microannots/}). 
#' Note that if there is a file or folder with the same name as the platform 
#' name in the directory, that file will be read instead of getting a copy from 
#' Pavlidis Lab. If this file isn't a valid annotation file, the function will fail.
#' If providing a custom annotation file, see
#' \url{erminej.msl.ubc.ca/help/input-files/gene-annotations/}
#' 
annotation = function(annotation){}


#' threshold
#' 
#' @keywords internal ORA
#' 
#' @name threshold
#' 
#' @param threshold Double. Score threshold (test = ORA only)
#'
threshold = function(threshold = 0.001){}



#' GSRstats
#' 
#' @keywords internal GSR
#' 
#' @name GSRstats
#' 
#' @param stats Method for computing raw class statistics (test = GSR only)
#' @param quantile Integer. Quantile to use. (stats = meanAboveQuantile only)
GSRstats = function(stats =  c('mean','quantile','meanAboveQuantile','precisionRecall'),
                    quantile = 50){}

#' expression
#' 
#' @keywords internal CORR
#' 
#' @name expression
#' 
#' @param expression A file path or a data frame. Expression data. (test = CORR only)
#' Necesary correlation anaylsis. See http://erminej.msl.ubc.ca/help/input-files/gene-expression-profiles/
#' for data format
#' 
expression = function(expression){}

#' iterations
#' 
#' @keywords internal GSR CORR
#' 
#' @name iterations
#' 
#' @param iterations Number of iterations (test = GSR and CORR methods only)
#' 
iterations = function(iterations){}

#' generalStats
#' 
#' @keywords internal universal
#' 
#' @name generalStats
#' 
#' @param geneReplicates  What to do when genes have multiple scores in input file
#'  (due to multiple probes per gene)
#' @param pAdjust Which multiple test correction method to use. Can be "FDR" or
#' 'Westfall-Young' (slower).
#' @param multifunctionalityCorrection Logical. Should the resutls be corrected 
#' for multifunctionality.
#' 
generalStats = function(geneReplicates = c('mean','best'),
                        pAdjust = c('FDR','Westfall-Young'),
                        multifunctionalityCorrection = TRUE){}


#' geneSetOpts
#' 
#' @keywords internal uniersal
#' 
#' @name geneSetOpts
#' 
#' @param geneSetDescription "Latest_GO", a file path that leads to a GO XML file
#' or a URL that leads to a go ontology file that ends with rdf-xml.gz. Note that
#' this is a mandatory argument. It defaults to Latest_GO but that option won't
#' work if you don't have a working internet connection. See \url{http://erminej.msl.ubc.ca/help/input-files/gene-set-descriptions/}
#' for details
#' @param customGeneSets Directory path or a named list of character strings.
#' Use this option to create your own gene sets. If you provide directory you can
#' specify probes or gene symbols to include in your gene sets. 
#' See \url{http://erminej.msl.ubc.ca/help/input-files/gene-sets/}
#' for information about format for this file. If you are providing a list, only gene
#' symbols are accepted.
#' @param minClassSize minimum class size
#' @param maxClassSize maximum class size
geneSetOpts = function(geneSetDescription = 'Latest_GO',
                       customGeneSets = NULL,
                       minClassSize = 10,
                       maxClassSize = 100){}

#' returnOptions
#' 
#' @keywords internal universal
#' 
#' @name returnOpts
#' 
#' @param genesOut Logical.  Should output include gene symbols for all gene sets 
#' @param output Output file name. 
#' @param return If results should be returned. Set to FALSE if you only want a file
#' 
returnOptions = function(genesOut =FALSE,
                         output = NULL,
                         return = TRUE){}
