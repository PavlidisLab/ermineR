context('test java')

test_that('successful java detection',{
    print('successful java detection')
    
    oldJavaHome = Sys.getenv('JAVA_HOME')
    Sys.setenv(JAVA_HOME = '')
    
    javaFound = findJava()
    print(javaFound)
    testthat::expect_is(javaFound,'character')
    
    annotation = 'testFiles/chip'
    scores <-read.table("testFiles/pValues", header=T, row.names = 1)
    
    result = ermineR(annotation = annotation,
                     scoreColumn = 1,
                     scores = scores,
                     return = TRUE,
                     geneSetDescription = 'testFiles/Go.xml')
    testthat::expect_is(result,'list')
    Sys.setenv(JAVA_HOME = oldJavaHome)
})


test_that('bad java home error',{
    print('bad java home error')
    oldJavaHome = Sys.getenv('JAVA_HOME')
    Sys.setenv(JAVA_HOME = 'bahHumbug')
    
    annotation = 'testFiles/chip'
    scores <-read.table("testFiles/pValues", header=T, row.names = 1)
    
    expect_error(ermineR(annotation = annotation,
                         scoreColumn = 1,
                         scores = scores,
                         output = 'out',
                         return = TRUE,
                         geneSetDescription = 'testFiles/Go.xml'),
                 'JAVA_HOME is not defined correctly')
    Sys.setenv(JAVA_HOME = oldJavaHome)
})
