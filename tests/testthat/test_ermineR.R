context('ermineJ usage')

# utils::download.file('http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz',destfile = 'GO.xml.gz',quiet= TRUE)

test_that('ermineJ basic usage',{
    annotation = 'Generic_human.txt'
    scores <-read.table("testFiles/pValues", header=T, row.names = 1)
    
    result1 = ermineR(annotation = 'testFiles/chip',
                      geneSetDescription = 'testFiles/Go.xml',
                      scoreColumn = 1,
                      scores = scores,
                      output = 'out',
                      return = TRUE)
    testthat::expect_is(result1,'list')
    testthat::expect_is(result1$results,'data.frame')
    
    # check column names and integers give the same results
    result2 = ermineR(annotation = 'testFiles/chip',
                      geneSetDescription = 'testFiles/Go.xml',
                      scoreColumn = 'pvalue',
                      scores = scores,
                      output = 'out',
                      return = TRUE)
    
    testthat::expect_identical(result1$results,result2$results)
    
    
    # test getGoGenes 
    goGenes = result1 %>% getGoGenes('GO:0051082')
    goGenesByName = result1 %>% getGoGenes('unfolded protein binding')
    testthat::expect_identical(goGenes, goGenesByName)
    
})


test_that('setting seed',{
    scores <-read.table("testFiles/pValues", header=T, row.names = 1)
    set.seed(1)
    result1 <- ermineR(annotation = "testFiles/chip", 
                       scores=scores,
                       scoreColumn = 1, 
                       test="GSR", 
                       stats="precisionRecall",
                       logTrans=T,
                       geneSetDescription = 'testFiles/Go.xml')
    set.seed(1)
    result2 <- ermineR(annotation = "testFiles/chip", 
                       scores=scores,
                       scoreColumn = 1, 
                       test="GSR", 
                       stats="precisionRecall",
                       logTrans=T,
                       geneSetDescription = 'testFiles/Go.xml')
    set.seed(3)
    resultDifferent <- ermineR(annotation = "testFiles/chip", 
                               scores=scores,
                               scoreColumn = 1, 
                               test="GSR", 
                               stats="precisionRecall",
                               logTrans=T,
                               geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_identical(result1$results$Pval,result2$results$Pval)
    testthat::expect_false(identical(result1$results$Pval,resultDifferent$results$Pval))

})

testthat::test_that('Reading the european output',{
    result = readErmineJOutput('testFiles/europeanResults.tsv')
    testthat::expect_is(result$results$Pval,'numeric')
})