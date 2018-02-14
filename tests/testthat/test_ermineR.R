context('ermineJ usage')

# utils::download.file('http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz',destfile = 'GO.xml.gz',quiet= TRUE)


test_that('ermineJ basic usage',{
    annotation = 'Generic_human.txt'
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    result1 = ermineR(annotation = 'Generic_human.txt',
                      scoreColumn = 2,
                      scores = scores,
                      output = 'out',
                      return = TRUE,
                      geneSetDescription = 'GO.xml.gz')
    testthat::expect_is(result1,'list')
    testthat::expect_is(result1$results,'data.frame')
    
    # check column names and integers give the same results
    result2 = ermineR(annotation = 'Generic_human.txt',
                      scoreColumn = 'Endothelial',
                      scores = scores,
                      output = 'out',
                      return = TRUE,
                      geneSetDescription = 'GO.xml.gz')
    
    testthat::expect_identical(result1$results,result2$results)
    

    
    # paul's test
    scores<-read.table("chd8.pvals.txt", header=T, row.names = 1)
    lmebtr.enrich<-ermineR(annotation = "Generic_mouse", 
                           scores=scores,
                           scoreColumn = 6, 
                           test="GSR", 
                           stats="precisionRecall",
                           logTrans=T,
                           geneSetDescription = 'GO.xml.gz')
    testthat::expect_is(lmebtr.enrich,'list')
    
    # test getGoGenes 
    
    goGenes = lmebtr.enrich %>% getGoGenes('GO:0035097')
    goGenesByName = lmebtr.enrich %>% getGoGenes('histone methyltransferase complex')
    testthat::expect_identical(goGenes, goGenesByName)
    
})

test_that('geting annotations from gemma',{
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    
    # try to get annotation from gemma
    result = ermineR(annotation = 'Generic_human',
                      scoreColumn = 'Endothelial',
                      scores = scores,
                      output = 'out',
                      return = TRUE,
                     geneSetDescription = 'GO.xml.gz')
    testthat::expect_is(result,'list')
    testthat::expect_is(result$results,'data.frame')    
})

test_that('test wrappers',{
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    oraOut = ora(annotation = 'Generic_human.txt',
                 scores = scores,
                 scoreColumn = 2,
                 threshold = 0.001,
                 geneSetDescription = 'GO.xml.gz')
    
    testthat::expect_is(oraOut,'list')
    testthat::expect_is(oraOut$results,'data.frame')
    testthat::expect_equal(oraOut$details$classScoreMethod, 'ORA')
    
    gsrOut = gsr(annotation = 'Generic_human.txt',
                 scores = scores,
                 scoreColumn = 2,
                 iterations = 24,
                 bigIsBetter = FALSE,
                 logTrans = FALSE,
                 stats = 'quantile',
                 geneSetDescription = 'GO.xml.gz')
    testthat::expect_is(gsrOut,'list')
    testthat::expect_is(gsrOut$results,'data.frame')
    testthat::expect_equal(gsrOut$details$classScoreMethod, 'GSR')
    testthat::expect_equal(gsrOut$details$rawScoreMethod, 'QUANTILE')
    testthat::expect_equal(gsrOut$details$iterations, 24)
    
    precRecallOut = precRecall(annotation = 'Generic_human.txt',
                               scores = scores,
                               scoreColumn = 2,
                               iterations = 24,
                               bigIsBetter = FALSE,
                               logTrans = FALSE,
                               geneSetDescription = 'GO.xml.gz')
    testthat::expect_is(precRecallOut,'list')
    testthat::expect_is(precRecallOut$results,'data.frame')
    testthat::expect_equal(precRecallOut$details$classScoreMethod, 'GSR')
    testthat::expect_equal(precRecallOut$details$rawScoreMethod, 'PRECISIONRECALL')
    
    corrOut = corr(expression = 'expression.tsv',
                   annotation = 'GPL96_noParents.an.txt.gz',
                   iterations = 22,
                   geneSetDescription = 'GO.xml.gz')
    testthat::expect_is(corrOut,'list')
    testthat::expect_is(corrOut$results,'data.frame')
    testthat::expect_equal(corrOut$details$classScoreMethod, 'CORR')
    # testthat::expect_equal(corrOut$details$iterations, 22)
    
    rocOut = roc(annotation = 'Generic_human.txt',
                 scores = scores,
                 scoreColumn = 2,
                 bigIsBetter = TRUE,
                 geneSetDescription = 'GO.xml.gz')
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
                         return = TRUE,
                         geneSetDescription = 'GO.xml.gz'),
                 'JAVA_HOME is not defined correctly')
    Sys.setenv(JAVA_HOME = oldJavaHome)
})

test_that('successful java detection',{
    oldJavaHome = Sys.getenv('JAVA_HOME')
    Sys.setenv(JAVA_HOME = '')
    
    javaFound = findJava()
    print(javaFound)
    testthat::expect_is(javaFound,'character')
    
    annotation = 'Generic_human.txt'
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    result = ermineR(annotation = 'Generic_human.txt',
                     scoreColumn = 1,
                     scores = scores,
                     output = 'out',
                     return = TRUE,
                     geneSetDescription = 'GO.xml.gz')
    testthat::expect_is(result,'list')
    Sys.setenv(JAVA_HOME = oldJavaHome)
})

test_that('setting seed',{
    scores<-read.table("chd8.pvals.txt", header=T, row.names = 1)
    set.seed(1)
    lmebtr.enrich<-ermineR(annotation = "Generic_mouse", 
                           scores=scores,
                           scoreColumn = 6, 
                           test="GSR", 
                           stats="precisionRecall",
                           logTrans=T,
                           geneSetDescription = 'GO.xml.gz')
    set.seed(1)
    lmebtr.enrich2<-ermineR(annotation = "Generic_mouse", 
                           scores=scores,
                           scoreColumn = 6, 
                           test="GSR", 
                           stats="precisionRecall",
                           logTrans=T,
                           geneSetDescription = 'GO.xml.gz')
    testthat::expect_identical(lmebtr.enrich$results,lmebtr.enrich2$results)
})