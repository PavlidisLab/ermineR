#' ORA
#' 
#' @description Over-representation analysis (ORA) examines the genes that meet
#'   a selection criterion and determines if there are gene sets which are
#'   statistically over-represented in that list. This method differs from other
#'   methods provided by ErmineJ in that you must set a gene score threshold for
#'   gene selection, or define a “hit list” of genes.
#'   
#'   Because ORA requires that you set a distinction between “good” and “bad” 
#'   genes, ORA is most appropriate when you are very confident about the 
#'   threshold. This is because changing the threshold can change the results, 
#'   sometimes dramatically. If you are examining genes which naturally fall
#'   into two categories (“on chromosome 2” and “not on chromosome 2”), then ORA
#'   is the logical choice. Otherwise, in our opinion the other methods are more
#'   appropriate.
#'   
#'   Technical comment: The probabilities produced by ErmineJ ORA are computed 
#'   using the hypergeometric distribution, but falls back to using the binomial
#'   approximation as needed.
#'   
#'   
#'   Method overview taken from:
#'   \url{http://erminej.msl.ubc.ca/help/tutorials/running-an-analysis-ora}
#'   
#' @inheritParams scores
#' @inheritParams hitlist
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
    do.call(ermineR, args,envir = parent.frame())

}


#' GSR
#'
#' @description The goal of this method is the same as for \code{\link{ora}}: to
#'   provide a p value for each gene set. The key difference lies in that ORA
#'   requires that you select a threshold for “gene selection”, whereas GSR does
#'   not.
#'   
#'   GSR uses all the gene scores for the genes in a gene set to produce a
#'   score. This means that genes that do not meet a statistical threshold for
#'   selection can contribute to the score. In addition, more information
#'   contained in the gene scores is preserved than in ORA, because ORA is
#'   essentially rank-based, whereas GSR uses the gene scores themselves. (The
#'   precision-recall method is even more close to the ORA method).
#'   
#'   In practice, ORA and GSR can yield similar results; however, we have found 
#'   that GSR tends to be more robust than ORA (because there is no threshold to
#'   set) and can give interesting results in situations where ORA doesn’t work 
#'   as well (when no genes meet the predetermined selection threshold).
#'   
#'   GSR is appropriate when you have reasonably good trust in the values of
#'   your gene scores, as opposed to the ranking. Its key advantage over ORA is
#'   that you do not have to set a threshold gene score. If you trust the
#'   ranking of gene scores more, the precision-recall or ROC methods might be
#'   useful.
#'   
#'   Method overview taken from: 
#'   \url{http://erminej.msl.ubc.ca/help/tutorials/running-an-analysis-resampling/}
#'
#' @inheritParams scores
#' @inheritParams annotation
#' @inheritParams iterations
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
               geneReplicates = c('mean','best'),
               pAdjust = c('FDR','Bonferroni'),
               geneSetDescription = 'Latest_GO',
               customGeneSets = NULL,
               minClassSize = 20,
               maxClassSize = 200,
               output = NULL,
               return = TRUE){
    args = as.list(match.call())[-1]
    args = c(args,list(test = 'GSR', stats = 'mean'))
    do.call(ermineR, args,envir = parent.frame())
}


#' Precision-recall
#' 
#' @description Precision-recall curves are a standard way to analyze the
#'   quality of a classifier, as are \code{\link{roc}} curves. The difference
#'   between ROC and Precision-recall (PR) is that PR is mostly concerned with
#'   what is happening at the top of the ranking, while ROC looks at the whole
#'   ranking. The precision-recall method in ErmineJ is similar in intent to the
#'   method popularized in “GSEA“, but uses standard precision-recall (GSEA
#'   originally used Kolmogorov-Smirnov statistics, but was changed to use a
#'   modified K-S statistic that makes it more precision-recall-like).
#'   
#'   Like the ROC method, the PRC method uses only the ranks of the gene scores.
#'   That is, all it cares about is the ordering of items obtained by your gene 
#'   scores (e.g., t-test or fold-change), but doesn’t use the information about
#'   the relative values of the scores.
#'   
#'   PR-scoring is rather like the ORA method in that it is concerned with what
#'   is going on at the “top” of your list, but unlike ORA it does not use a 
#'   threhold. Thus PR-scoring would be appropriate whenever you consider the
#'   ORA method appropriate. The PR method requires a resampling step, so it is
#'   slower to run than ORA.
#'   
#'   Method overview taken from: 
#'   \url{http://erminej.msl.ubc.ca/help/tutorials/tutorial-precision-recall-scoring/}
#'   
#' 
#' @inheritParams scores
#' @inheritParams annotation
#' @inheritParams iterations
#' @inheritParams generalStats
#' @inheritParams geneSetOpts
#' @inheritParams returnOpts
#' 
#' @export
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
    do.call(ermineR, args,envir = parent.frame())
}


#' CORR
#' 
#' @description This method examines the gene expression profiles themselves,
#'   not the gene scores for each gene (which is how the other methods like ORA
#'   work). A score is computed for a gene set based on how correlated the
#'   expression profiles are.
#'   
#'   This can be thought of as a measure of how well the genes in the set
#'   cluster together, but they need not all be in the same cluster. Thus a gene
#'   set that contains two coherent clusters that encompass most of the genes in
#'   the set will tend to get a good score (though not as good as a gene set
#'   that is just one big cluster).
#'   
#'   If you are interested in gene clustering, as opposed to simply looking at
#'   differntial expression, this method is appropriate. If you feel limited by
#'   the choice of distance metrics in ermineJ, ORA would be an alternative, but
#'   you have to define distinct clusters of genes to do that.
#'   
#'   One alternative use of correlation scoring is as a control for
#'   gene-score-based analysis. Correlated gene sets can cause spurious high
#'   scores, especially if the differential expression in your study is weak. To
#'   use this approach, you could first use gene-score-based analysis (e.g.,
#'   gene score resampling and then analyze the data using correlation analysis.
#'   If any of your gene sets have high scores in both analyses, you should look
#'   at the data to see if the correlation is not associated with the
#'   differential expression. This is a simple (but ad hoc) alternative to using
#'   resampling over the samples to do the gene-score-based analysis.
#'   
#'   Method overview taken from: 
#'   \url{http://erminej.msl.ubc.ca/help/tutorials/running-an-analysis-correlation/}
#'   
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
    do.call(ermineR, args,envir = parent.frame())
}

#' ROC
#' 
#' The receiver operator characteristic (ROC) method is a fast, non-parametric
#' alternative to the ORA and resampling methods for generating gene set scores
#' from gene scores.
#' 
#' The ROC is a well-known method for evaluating rankings of items, in this case
#' genes. The ranking in this case comes from the gene scores. A gene set will
#' get a good ROC if many genes in the gene set are near the top of the list.
#' 
#' The score measured for each gene set is the area under the ROC curve, a value
#' between 0 and 1. If the genes in the gene set are randomly distributed in the
#' ranking, you would expect a value near 0.5. Values near 1 indicate the genes
#' in the gene set are near the top of the list, while values near 0 indicate
#' the genes in the gene set are near the bottom of the list. In principle both
#' values near 0 and near 1 are statistically significant, but p-values reported
#' by ermineJ are based on the assumption that only the top of the list is of
#' interest (e.g., we’re not considering “under-representation analysis”).
#' 
#' Unlike the other methods in ermineJ other than the PRC method, the ROC uses
#' only the ranks of the gene scores. That is, all it cares about is the
#' ordering of items obtained by your gene scores (e.g., t-test or fold-change),
#' but doesn’t use the information about the relative values of the scores.
#' 
#' P-values for this analysis are computed using algorithms described in Breslin
#' et al., 2004*. For more information on the ROC, you could do worse than
#' reading the Wikipedia page
#' \url{http://en.wikipedia.org/wiki/Receiver_operator_characteristic}.
#' 
#' Like other non-parametric techniques, using ranks costs some statistical
#' power, but also makes fewer assumptions. Specifically, if you think the
#' ordering of items in your data is more accurate than the actual p-values
#' themselves, the ROC might be appropriate. The PRC method is similar in that
#' it uses ranks, but puts more emphasis on genes in the set which are ranked
#' very near the top. In contrast the ROC method looks at overall trends in the
#' rankings.
#' 
#' Method overview taken from: 
#' \url{http://erminej.msl.ubc.ca/help/tutorials/running-an-analysis-correlation/}
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
    do.call(ermineR, args,envir = parent.frame())
}
