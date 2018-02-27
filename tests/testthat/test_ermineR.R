context('ermineJ usage')

# utils::download.file('http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz',destfile = 'GO.xml.gz',quiet= TRUE)

test_that('ermineJ basic usage',{
    print('ermineJ basic usage')
    annotation = 'Generic_human.txt'
    scores <-read.table("scoreFile.txt", header=T, row.names = 1)
    
    result1 = ermineR(annotation = 'Generic_human.txt',
                      geneSetDescription = 'GO.xml.gz',
                      scoreColumn = 2,
                      scores = scores,
                      output = 'out',
                      return = TRUE)
    testthat::expect_is(result1,'list')
    testthat::expect_is(result1$results,'data.frame')
    
    # check column names and integers give the same results
    result2 = ermineR(annotation = 'Generic_human.txt',
                      geneSetDescription = 'GO.xml.gz',
                      scoreColumn = 'Endothelial',
                      scores = scores,
                      output = 'out',
                      return = TRUE)
    
    testthat::expect_identical(result1$results,result2$results)
    

    
    # paul's test
    scores<-read.table("chd8.pvals.txt", header=T, row.names = 1)
    lmebtr.enrich<-ermineR(annotation = "Generic_mouse", 
                           geneSetDescription = 'GO.xml.gz',
                           scores=scores,
                           scoreColumn = 6, 
                           test="GSR", 
                           stats="precisionRecall",
                           logTrans=T)
    testthat::expect_is(lmebtr.enrich,'list')
    
    # test getGoGenes 
    
    goGenes = lmebtr.enrich %>% getGoGenes('GO:0035097')
    goGenesByName = lmebtr.enrich %>% getGoGenes('histone methyltransferase complex')
    testthat::expect_identical(goGenes, goGenesByName)
    
})


test_that('setting seed',{
    print('setting seed')
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