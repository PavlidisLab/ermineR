context('ermineJ usage')

test_that('ermineJ basic usage',{
    annotation = 'Generic_human.txt'
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    result1 = ermineR(annotation = 'Generic_human.txt',
                     scoreColumn = 1,
                     scores = scores,
                     output = 'out',
                     genesOut = TRUE,
                     return = TRUE)
    testthat::expect_is(result1,'list')
    testthat::expect_is(result1$results,'data.frame')
    
    # check column names and integers give the same results
    result2 = ermineR(annotation = 'Generic_human.txt',
                       scoreColumn = 'Astrocyte',
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
})
