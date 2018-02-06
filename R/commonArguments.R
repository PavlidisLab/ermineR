#' annotation
#' 
#' @keywords internal
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
NULL


#' scores
#' 
#' @keywords internal
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
#' 
NULL

#' threshold
#' 
#' @keywords internal
#' 
#' @name threshold
#' 
#' @param threshold Double. Score threshold (test = ORA only)
#'
NULL