library(here)
library(dplyr)
library(magrittr)
devtools::load_all()
set.seed(1)

# genes for GO:0051082

getGemmaAnnot("GPL96", here('tests/testthat/testFiles/chip'),overwrite = TRUE)
getGemmaAnnot("GPL96", here('tests/testthat/testFiles/chipFull'),overwrite = TRUE,annotType = 'allParents')

annot = read.table(here('tests/testthat/testFiles/chipFull'),sep ='\t', header = TRUE,stringsAsFactors = FALSE)
annot %<>% filter(!grepl('\\|',GeneSymbols))
hitlist = annot %>% filter(grepl('GO:0051082', GOTerms)) %$% GeneSymbols

randomGenes = sample(unique(annot$GeneSymbols),50)
# randomGenes = unique(annot$GeneSymbols)
randomGenes = randomGenes[!randomGenes %in% hitlist]
hitlistGenes = hitlist[1:40]
# hitlistGenes = hitlist


annot %<>% filter(GeneSymbols %in% c(randomGenes, hitlistGenes))

write.table(annot,file = here('tests/testthat/testFiles/chip'),quote = FALSE,sep = '\t',row.names = FALSE)

pValues = data.frame(gene = c(annot$ProbeName[annot$GeneSymbols %in% randomGenes],
                              annot$ProbeName[annot$GeneSymbols %in% hitlistGenes]),
                     pvalue = c(runif(length(annot %>% filter(GeneSymbols %in% randomGenes) %$% ProbeName),
                                      min = 0.0001,max = 1),
                                runif(length(annot %>% filter(GeneSymbols %in% hitlistGenes) %$% ProbeName),
                                      min = 0.0001, max = 0.001)))


pValuesBig = pValues
pValuesBig$pvalue = 1-pValuesBig$pvalue

write.table(pValues, file =  here('tests/testthat/testFiles/pValues'),quote = FALSE, sep = '\t', row.names = FALSE)
write.table(pValuesBig, file =  here('tests/testthat/testFiles/pValuesBig'),quote = FALSE, sep = '\t', row.names = FALSE)

hitlist = pValues %>% filter(pvalue <= 0.001) %$% gene

write.table(hitlist,file = here('tests/testthat/testFiles/hitlist'),quote =FALSE, row.names = FALSE,col.names = FALSE)

# expression file this doesn't work for now

randomDat = runif(length(annot$ProbeName[annot$GeneSymbols %in% randomGenes])*10,0,16) %>% matrix(ncol = 10)

correlatedDat = rep(runif(10,0,16),length(annot %>% filter(GeneSymbols %in% hitlistGenes) %$% ProbeName)) %>% 
    {. + runif(length(.),0,1)} %>% 
    matrix(ncol = 10,byrow = TRUE)


expression = rbind(randomDat, correlatedDat)
expression = data.frame(gene = c(annot$ProbeName[annot$GeneSymbols %in% randomGenes],
                    annot %>% filter(GeneSymbols %in% hitlistGenes) %$% ProbeName),
           expression)

write.table(expression,file = here('tests/testthat/testFiles/expression'),sep = '\t',
            quote = FALSE,row.names = FALSE)

# get go ontology

goAtDate(here('tests/testthat/testFiles/Go.xml'),'2018-02-27',overwrite = TRUE)
