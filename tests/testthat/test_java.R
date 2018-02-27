context('test java')

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
