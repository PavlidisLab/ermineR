context('ermineJ usage')

test_that('ermineJ basic usage',{
    score = 'scoreFile.txt'
    annotation = 'Generic_human.txt'
    ermineR(annotation = 'Generic_human.txt',scoreColumn = 2,scores = 'scoreFile.txt',output = 'out')
})