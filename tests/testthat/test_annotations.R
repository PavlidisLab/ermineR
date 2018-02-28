context('annotation tests')


test_that('geting annotations from gemma',{

    scores <-read.table("testFiles/scoreFile.txt", header=T, row.names = 1)
    
    
    # try to get annotation from gemma
    result = ermineR(annotation = 'Generic_human',
                     scoreColumn = 'Endothelial',
                     scores = scores,
                     return = TRUE,
                     geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_is(result,'list')
    testthat::expect_is(result$results,'data.frame')    
})


test_that('goToday, latest go and go at date test',{
    todayGo = tempfile()
    goToday(todayGo,overwrite = TRUE)
    hitlist = readLines('testFiles/hitlist')
    
    oraOut = ora(annotation = 'testFiles/chip',
                 hitlist = hitlist,
                 geneSetDescription = todayGo)
    
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
    
    oraOut2 = ora(annotation = 'testFiles/chip',
                  hitlist = hitlist,
                  geneSetDescription = 'Latest_GO')
    testthat::expect_identical(oraOut$results,oraOut2$results)
    
    validDates = getGoDates()
    
    # get latest date
    todayGo2 = tempfile()
    goAtDate(todayGo2,validDates[1],overwrite = TRUE)
    testthat::expect_equal(unname(tools::md5sum(todayGo)),unname(tools::md5sum(todayGo2)))
    
})

test_that('data.frame annotation',{
        hitlist = readLines('testFiles/hitlist')
    annotations = read.table('testFiles/chip', sep='\t', header = TRUE,
                             quote="", stringsAsFactors = F)
    
    oraOut = ora(annotation = annotations,
                 hitlist = hitlist,
                 geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
})
