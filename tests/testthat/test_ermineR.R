context('ermineJ usage')

test_that('ermineJ basic usage',{
    annotation = 'Generic_human.txt'
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    result1 = ermineR(annotation = 'Generic_human.txt',
                     scoreColumn = 2,
                     scores = scores,
                     output = 'out',
                     genesOut = TRUE,
                     return = TRUE)
    testthat::expect_is(result1,'list')
    testthat::expect_is(result1$results,'data.frame')
    
    # check column names and integers give the same results
    result2 = ermineR(annotation = 'Generic_human.txt',
                       scoreColumn = 'Endothelial',
                       scores = scores,
                       output = 'out',
                       genesOut = TRUE,
                       return = TRUE)
    
    testthat::expect_identical(result1$results,result2$results)
    
    
    # paul's test
    scores<-read.table("chd8.pvals.txt", header=T, row.names = 1)
    lmebtr.enrich<-ermineR(annotation = "Generic_mouse", 
                           scores=scores,
                           scoreColumn = 6, 
                           test="GSR", 
                           stats="precisionRecall", 
                           genesOut=T,
                           logTrans=T)
    testthat::expect_is(lmebtr.enrich,'list')
    
    
    # lilah's test
    annots = read.table('AnnotationsCommonGenes.txt')
    annots = unique(annots)
    
    annots %>% readr::write_tsv('newAnnots.tsv')
    
    scores =  read.table('SCZcombine.txt',header=TRUE) %>% {rownames(.) = .[,1];.}
    AnnoFile = 'newAnnots.tsv'
    SCZtest = ermineR(annotation = AnnoFile,
            scores = scores,
            scoreColumn = 'FC_mod0',
            test = 'GSR')
    
})

test_that('test wrappers',{
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    oraOut = ora(annotation = 'Generic_human.txt',
                 scores = scores,
                 scoreColumn = 2,
                 threshold = 0.001)
    
    testthat::expect_is(oraOut,'list')
    testthat::expect_is(oraOut$results,'data.frame')
    testthat::expect_equal(oraOut$details$classScoreMethod, 'ORA')
    
    gsrOut = gsr(annotation = 'Generic_human.txt',
                 scores = scores,
                 scoreColumn = 2,
                 iterations = 24,
                 bigIsBetter = FALSE,
                 logTrans = FALSE,
                 stats = 'quantile')
    testthat::expect_is(gsrOut,'list')
    testthat::expect_is(gsrOut$results,'data.frame')
    testthat::expect_equal(gsrOut$details$classScoreMethod, 'GSR')
    testthat::expect_equal(gsrOut$details$iterations, 24)
    
    
    corrOut = corr(expression = 'expression.tsv',
                   annotation = 'GPL96_noParents.an.txt.gz',
                   iterations = 22)
    testthat::expect_is(corrOut,'list')
    testthat::expect_is(corrOut$results,'data.frame')
    testthat::expect_equal(corrOut$details$classScoreMethod, 'CORR')
    # testthat::expect_equal(corrOut$details$iterations, 22)
    
    rocOut = roc(annotation = 'Generic_human.txt',
                 scores = scores,
                 scoreColumn = 2,
                 bigIsBetter = TRUE,
                 multifunctionalityCorrection = FALSE) # doesn't seem to work for now
    testthat::expect_is(rocOut,'list')
    testthat::expect_is(rocOut$results,'data.frame')
    testthat::expect_equal(rocOut$details$classScoreMethod, 'ROC')
})


test_that('bad java home error',{
    oldJavaHome = Sys.getenv('JAVA_HOME')
    Sys.setenv(JAVA_HOME = 'bahHumbug')
    
    annotation = 'Generic_human.txt'
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    expect_error(ermineR(annotation = 'Generic_human.txt',
                      scoreColumn = 1,
                      scores = scores,
                      output = 'out',
                      genesOut = TRUE,
                      return = TRUE),
                 'JAVA_HOME is not defined correctly')
    Sys.setenv(JAVA_HOME = oldJavaHome)
})
