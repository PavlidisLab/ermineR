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


test_that('goToday, latest go, go at date test and get go from link',{
    testthat::skip_on_travis()
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
    testthat::expect_identical(oraOut$results$Name,oraOut2$results$Name)

    
    oraOut3 = ora(annotation = 'testFiles/chip',
                  hitlist = hitlist,
                  geneSetDescription = 'http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz')
    testthat::expect_identical(oraOut$results$Name,oraOut3$results$Name)
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


test_that('make annotation',{
    hitlist = readLines('testFiles/hitlist')
    annot =  read.table('testFiles/chip',sep ='\t', header = TRUE,stringsAsFactors = FALSE)
    annotList = annot$GOTerms %>% strsplit('\\|')
    names(annotList) = annot$ProbeName
    genes = annot$GeneSymbols
    names = annot$GeneNames
    annotations = makeAnnotation(annotList,symbol = genes,name = names)
    
    oraOut = ora(annotation = annotations,
                 hitlist = hitlist,
                 geneSetDescription = 'testFiles/Go.xml')
    
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
    
})