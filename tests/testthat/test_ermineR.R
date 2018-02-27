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

test_that('geting annotations from gemma',{
    print('geting annotations from gemma')
    
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
    print('test wrappers')
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
    print('bad java home error')
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
    print('successful java detection')
    
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

# genes for GO:0051082
hitlist = c("AAMP", "AFG3L2", "AHSP", "AIP", "AIPL1", "APCS", "BBS12", 
            "CALR", "CALR3", "CANX", "CCDC115", "CCT2", "CCT3", "CCT4", "CCT5", 
            "CCT6A", "CCT6B", "CCT7", "CCT8", "CCT8L1P", "CCT8L2", "CDC37", 
            "CDC37L1", "CHAF1A", "CHAF1B", "CLGN", "CLN3", "CLPX", "CRYAA", 
            "CRYAB", "DNAJA1", "DNAJA2", "DNAJA3", "DNAJA4", "DNAJB1", "DNAJB11", 
            "DNAJB13", "DNAJB2", "DNAJB4", "DNAJB5", "DNAJB6", "DNAJB8", 
            "DNAJC4", "DZIP3", "ERLEC1", "ERO1B", "FYCO1", "GRPEL1", "GRPEL2", 
            "GRXCR2", "HEATR3", "HSP90AA1", "HSP90AA2P", "HSP90AA4P", "HSP90AA5P", 
            "HSP90AB1", "HSP90AB2P", "HSP90AB3P", "HSP90AB4P", "HSP90B1", 
            "HSP90B2P", "HSPA1A", "HSPA1B", "HSPA1L", "HSPA2", "HSPA5", "HSPA6", 
            "HSPA8", "HSPA9", "HSPB6", "HSPD1", "HSPE1", "HTRA2", "LMAN1", 
            "MDN1", "MKKS", "NAP1L4", "NDUFAF1", "NPM1", "NUDC", "NUDCD2", 
            "NUDCD3", "PDRG1", "PET100", "PFDN1", "PFDN2", "PFDN4", "PFDN5", 
            "PFDN6", "PIKFYVE", "PPIA", "PPIB", "PTGES3", "RP2", "RUVBL2", 
            "SCAP", "SCG5", "SERPINH1", "SHQ1", "SIL1", "SPG7", "SRSF10", 
            "SRSF12", "ST13", "SYVN1", "TAPBP", "TCP1", "TMEM67", "TOMM20", 
            "TOR1A", "TRAP1", "TTC1", "TUBB4B", "UGGT1", "ZFYVE21")
    
test_that('test hitlist input',{
    print('test hitlist input')
    
    oraOut = ora(annotation = 'Generic_human.txt',
                 hitlist = hitlist,
                 geneSetDescription = 'GO.xml.gz')
    
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
})

test_that('goToday, latest go and go at date test',{
    print('goToday, latest go and go at date test')
    goToday('todayGo',overwrite = TRUE)
    oraOut = ora(annotation = 'Generic_human.txt',
                 hitlist = hitlist,
                 geneSetDescription = 'todayGo')
    
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
    
    oraOut2 = ora(annotation = 'Generic_human.txt',
                  hitlist = hitlist,
                  geneSetDescription = 'Latest_GO')
    testthat::expect_identical(oraOut$results,oraOut2$results)
    
    validDates = getGoDates()
    
    # get latest date
    goAtDate('todayGo2',validDates[1],overwrite = TRUE)
    testthat::expect_equal(unname(tools::md5sum('todayGo')),unname(tools::md5sum('todayGo2')))
    
})

test_that('data.frame annotation',{
    
    print('data.frame annotation')
    
    annotations = read.table('Generic_human.txt', sep='\t', header = TRUE,
                             quote="", stringsAsFactors = F)
    
    oraOut = ora(annotation = annotations,
                 hitlist = hitlist,
                 geneSetDescription = 'GO.xml.gz')
    testthat::expect_true(oraOut$results$Pval[oraOut$results$ID == 'GO:0051082']<0.05)
})
