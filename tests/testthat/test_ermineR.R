context('ermineJ usage')

test_that('ermineJ basic usage',{
    annotation = 'Generic_human.txt'
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    result1 = ermineR(annotation = 'Generic_human',
                     scoreColumn = 1,
                     scores = scores,
                     output = 'out',
                     genesOut = TRUE,
                     return = TRUE)
    testthat::expect_is(result1,'data.frame')
    
    # check column names and integers give the same results
    result2 = ermineR(annotation = 'Generic_human',
                       scoreColumn = 'Astrocyte',
                       scores = scores,
                       output = 'out',
                       genesOut = TRUE,
                       return = TRUE)
    
    testthat::expect_identical(result1,result2)
    
    
    # paul's test
    scores<-read.table("chd8.pvals.txt", header=T, row.names = 1)
    lmebtr.enrich<-ermineR(annotation = "Generic_mouse", 
                           scores=chd8pv,
                           scoreColumn = 6, 
                           test="GSR", 
                           stats="precisionRecall", 
                           genesOut=T,
                           logTrans=T)
    testthat::expect_is(lmebtr.enrich,'data.frame')
    
})
