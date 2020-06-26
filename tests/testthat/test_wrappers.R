context('wrappers')

set.seed(1)

test_that('test wrappers',{
    scores <-read.table("testFiles/pValues", header=T, row.names = 1)
    scoresBig <-read.table("testFiles/pValuesBig", header=T, row.names = 1)
    
    oraOut = ora(annotation = 'testFiles/chip',
                 scores = scores,
                 scoreColumn = 1,
                 threshold = 0.001,
                 geneSetDescription = 'testFiles/Go.xml')
    
    testthat::expect_is(oraOut,'list')
    testthat::expect_is(oraOut$results,'data.frame')
    testthat::expect_equal(oraOut$details$classScoreMethod, 'ORA')
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
    
    oraOutBig = ora(annotation = 'testFiles/chip',
                 scores = scoresBig,
                 bigIsBetter = TRUE,
                 scoreColumn = 1,
                 threshold = 0.999,
                 geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_true(oraOutBig$results$Pval[oraOutBig$results$ID == 'GO:0051082']<0.05)
    
    gsrOut = gsr(annotation = 'testFiles/chip',
                 scores = scores,
                 scoreColumn = 1,
                 iterations = 24,
                 bigIsBetter = FALSE,
                 logTrans = FALSE,
                 geneSetDescription = 'testFiles/Go.xml')
    
    
    testthat::expect_is(gsrOut,'list')
    testthat::expect_is(gsrOut$results,'data.frame')
    testthat::expect_equal(gsrOut$details$classScoreMethod, 'GSR')
    testthat::expect_equal(gsrOut$details$rawScoreMethod, 'MEAN')
    testthat::expect_equal(gsrOut$details$iterations, 24)
    testthat::expect_true(gsrOut$results$Pval[gsrOut$results$ID == 'GO:0051082']<0.05)
    
    
    gsrOutBig = gsr(annotation = 'testFiles/chip',
                 scores = scoresBig,
                 scoreColumn = 1,
                 iterations = 21,
                 bigIsBetter = TRUE,
                 logTrans = FALSE,
                 geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_true(gsrOutBig$results$Pval[gsrOutBig$results$ID == 'GO:0051082']<0.05)
    
    precRecallOut = precRecall(annotation = 'testFiles/chip',
                               scores = scores,
                               scoreColumn = 1,
                               iterations = 24,
                               bigIsBetter = FALSE,
                               logTrans = FALSE,
                               geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_is(precRecallOut,'list')
    testthat::expect_is(precRecallOut$results,'data.frame')
    testthat::expect_equal(precRecallOut$details$classScoreMethod, 'GSR')
    testthat::expect_equal(precRecallOut$details$rawScoreMethod, 'PRECISIONRECALL')
    testthat::expect_true(precRecallOut$results$Pval[precRecallOut$results$ID == 'GO:0051082']<0.05)
    
    
    precRecallOutBig = precRecall(annotation = 'testFiles/chip',
                                  scores = scoresBig,
                                  scoreColumn = 1,
                                  iterations = 24,
                                  bigIsBetter = TRUE,
                                  logTrans = FALSE,
                                  geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_true(precRecallOutBig$results$Pval[precRecallOutBig$results$ID == 'GO:0051082']<0.05)
    
    rocOut = roc(annotation = 'testFiles/chip',
                 scores = scores,
                 scoreColumn = 1,
                 bigIsBetter = FALSE,
                 geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_is(rocOut,'list')
    testthat::expect_is(rocOut$results,'data.frame')
    testthat::expect_equal(rocOut$details$classScoreMethod, 'ROC')
    testthat::expect_true(rocOut$results$Pval[rocOut$results$ID == 'GO:0051082']<0.05)
    
    rocOutBig = roc(annotation = 'testFiles/chip',
                 scores = scoresBig,
                 scoreColumn = 1,
                 bigIsBetter = TRUE,
                 geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_true(rocOutBig$results$Pval[rocOutBig$results$ID == 'GO:0051082']<0.05)
    
    corrOut = corr(expression = 'testFiles/expression.tsv',
                   annotation = 'testFiles/GPL96_noParents.an.txt.gz',
                   iterations = 22,
                   geneSetDescription = 'testFiles/Go.xml')
    
    # corrOut = corr(expression = 'testFiles/expression',
    #                annotation = 'testFiles/chip',
    #                iterations = 22,
    #                geneSetDescription = 'testFiles/Go.xml')
    
    testthat::expect_is(corrOut,'list')
    testthat::expect_is(corrOut$results,'data.frame')
    testthat::expect_equal(corrOut$details$classScoreMethod, 'CORR')
    # testthat::expect_equal(corrOut$details$iterations, 22)
})

test_that('test hitlist input',{

    hitlist = readLines('testFiles/hitlist')
    
    oraOut = ora(annotation = 'testFiles/chip',
                 hitlist = hitlist,
                 geneSetDescription = 'testFiles/Go.xml')
    
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
})



test_that('test custom gene lists without annotation or go.xml',{
    
    scores <-read.table("testFiles/pValues", header=T, row.names = 1)
    
    precRecallOut = precRecall(# annotation = 'testFiles/chip',
                 customGeneSets = 'testFiles/customGeneSet.tsv',
                 scores = scores,
                 scoreColumn = 1,
                 geneSetDescription = NULL)
    
    testthat::expect_true(precRecallOut$results$Pval[precRecallOut$results$Name == 'GO:0051082']<0.05)
    
    
    # for this test probeset names are acting as gene symbols
    hitlist = readLines('testFiles/hitlist')
    chip = readErmineJAnnot('testFiles/chip')
    chip$GeneSymbols = chip$ProbeName
    oraOut = ora(annotation = chip,
                 hitlist = hitlist,
                 geneSetDescription = NULL,
                 customGeneSets =  'testFiles/customGeneSet.tsv')
    testthat::expect_true(precRecallOut$results$Pval[oraOut$results$Name == 'GO:0051082']<0.05)
    
    testthat::expect_error(
        ora(hitlist = hitlist,
            geneSetDescription = NULL,
            customGeneSets =  'testFiles/customGeneSet.tsv'),
        regexp = "Hitlists require an annotation file")
    
    
    
    # custom gene list as objects
    customList = readLines('testFiles/customGeneSet.tsv') %>% strsplit('\t')
    names(customList) = customList %>% purrr::map_chr(1)
    
    
})