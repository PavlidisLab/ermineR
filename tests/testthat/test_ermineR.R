context('ermineJ usage')

test_that('ermineJ basic usage',{
    score = 'scoreFile.txt'
    annotation = 'Generic_human.txt'
    result = ermineR(annotation = 'Generic_human.txt',
                     scoreColumn = 2,
                     scores = 'scoreFile.txt',
                     output = 'out',
                     genesOut = TRUE,
                     return = TRUE)
    testthat::expect_is(result,'data.frame')
})