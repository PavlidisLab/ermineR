
ErmineR <img src="inst/ermineR.png" align="right" height="100px"/>
==================================================================

[![Build Status](https://travis-ci.org/PavlidisLab/ermineR.svg?branch=master)](https://travis-ci.org/PavlidisLab/ermineR) [![codecov](https://codecov.io/gh/PavlidisLab/ermineR/branch/master/graph/badge.svg)](https://codecov.io/gh/PavlidisLab/ermineR) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/PavlidisLab/ermineR?branch=master&svg=true)](https://ci.appveyor.com/project/PavlidisLab/ermineR)

This is an R wrapper for Pavlidis Lab's [ermineJ](http://erminej.msl.ubc.ca/). A tool for gene set enrichment analysis with multifunctionality correction.

Usage
-----

See documentation for `ora`, `roc`, `gsr`, `precRecall` and `corr` to see how to use them.

An explanation of what each method does is given. We recommend users start with the `precRecall` (for gene ranking-based enrichment analysis) or `ora` (for hit-list over-representation analysis).

### Replicable go terms

GO terms are updated frequently so results can differ between versions. The default option of all ermineR functions is to get the latest GO version however this means you may get different results when you repeat the experiment later. If you want to use a specific version of GO, ermineR provides functions to deal with that.

-   `goToday`: Downloads the latest version of go to a path you provide
-   `getGoDates`: Lists all dates where a go version is available, from the most recent to oldest
-   `goAtDate`: Given a valid date, downloads the Go version from a specific date to a file path you provide

To use a specific version of GO, make sure to set `geneSetDescription` argument of all ermineR functions to the file path where you saved the go terms

### Examples

#### Use ORA with a hitlist

``` r
library(dplyr)
```

    ## Warning: package 'dplyr' was built under R version 3.4.4

``` r
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
oraOut = ora(annotation = 'Generic_human',
             hitlist = hitlist)
```

    ## Called from: (function (annotation = NULL, aspects = c("Molecular Function", 
    ##     "Cellular Component", "Biological Process"), scores = NULL, 
    ##     hitlist = NULL, scoreColumn = 1, threshold = 0.001, expression = NULL, 
    ##     bigIsBetter = FALSE, customGeneSets = NULL, geneReplicates = c("mean", 
    ##         "best"), logTrans = FALSE, pAdjust = c("FDR", "FWE"), 
    ##     test = c("ORA", "GSR", "CORR", "ROC"), iterations = NULL, 
    ##     stats = c("mean", "quantile", "meanAboveQuantile", "precisionRecall"), 
    ##     quantile = 50, geneSetDescription = "Latest_GO", output = NULL, 
    ##     return = TRUE, minClassSize = 20, maxClassSize = 200) 
    ## {
    ##     test = match.arg(test)
    ##     pAdjust = match.arg(pAdjust)
    ##     geneReplicates = match.arg(geneReplicates)
    ##     stats = match.arg(stats)
    ##     ermineJHome = system.file("ermineJ-3.1.2", package = "ermineR")
    ##     Sys.setenv(ERMINEJ_HOME = ermineJHome)
    ##     if (Sys.getenv("JAVA_HOME") == "") {
    ##         findJava()
    ##     }
    ##     arguments = list()
    ##     if ("character" %in% class(annotation)) {
    ##         if (!file.exists(annotation)) {
    ##             message("Attempting to download annotation file")
    ##             tryCatch(suppressWarnings(getGemmaAnnot(annotation, 
    ##                 chipFile = annotation, annotType = "noParents")), 
    ##                 error = function(e) {
    ##                   stop("\"annotation\" is not a valid file or exists in Pavlidis lab annotations. See http://www.chibi.ubc.ca/microannots for available options.")
    ##                 })
    ##         }
    ##     }
    ##     else if ("data.frame" %in% class(annotation)) {
    ##         temp = tempfile()
    ##         annotation %>% readr::write_tsv(temp)
    ##         annotation = temp
    ##     }
    ##     assertthat::is.string(annotation)
    ##     arguments$annotation = paste("--annots", shQuote(annotation))
    ##     if (geneSetDescription == "Latest_GO") {
    ##         temp = tempfile(fileext = ".xml.gz")
    ##         utils::download.file("http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz", 
    ##             destfile = temp, quiet = TRUE)
    ##         geneSetDescription = temp
    ##     }
    ##     else if (!file.exists(geneSetDescription)) {
    ##         message("Attempting to download gene set description from link")
    ##         temp = tempfile(fileext = "xml.gz")
    ##         download.file(url = geneSetDescription, destfile = temp, 
    ##             quiet = TRUE)
    ##         geneSetDescription = temp
    ##     }
    ##     assertthat::is.string(geneSetDescription)
    ##     arguments$geneSetDescription = paste("--classFile", shQuote(geneSetDescription))
    ##     if (test %in% c("ORA", "GSR", "ROC")) {
    ##         if (test == "ORA" & is.null(scores) & !is.null(hitlist)) {
    ##             logTrans = FALSE
    ##             bigIsBetter = FALSE
    ##             threshold = 0.5
    ##             scoreColumn = 1
    ##             browser()
    ##             annoFile = readErmineJAnnot(annotation)
    ##             allGenes = annoFile[, 1] %>% unique
    ##             scores = data.frame(scores = rep(1, length(allGenes)))
    ##             rownames(scores) = allGenes
    ##             scores[hitlist, ] = 0
    ##         }
    ##         else if (test == "ORA" & is.null(scores) & is.null(hitlist)) {
    ##             stop("ORA method requires scores or hitlist")
    ##         }
    ##         else if (!is.null(scores) & !is.null(hitlist)) {
    ##             stop("You can't provide both scores and a hitlist")
    ##         }
    ##         if (is.null(scores)) {
    ##             stop(test, " method requries a score list.")
    ##         }
    ##         assertthat::assert_that("data.frame" %in% class(scores))
    ##         temp = tempfile()
    ##         scores %>% utils::write.table(temp, sep = "\t", quote = FALSE)
    ##         arguments$scores = paste("--scoreFile", shQuote(temp))
    ##         assertthat::assert_that(assertthat::is.number(scoreColumn) | 
    ##             assertthat::is.string(scoreColumn))
    ##         if (assertthat::is.string(scoreColumn)) {
    ##             scoreColumn = which(names(scores) %in% scoreColumn)
    ##         }
    ##         scoreColumn = scoreColumn + 1
    ##         arguments$scoreColumn = paste("--scoreCol", scoreColumn)
    ##     }
    ##     else if (test == "CORR" & !is.null(scores)) {
    ##         warning("You have provided gene scores to use with correlation analysis.", 
    ##             " This is not possible. Gene scores will be ignored. Please refer", 
    ##             " to ermineJ documentation.")
    ##     }
    ##     if (test == "CORR") {
    ##         if ("data.frame" %in% class(expression)) {
    ##             temp = tempfile()
    ##             expression %>% readr::write_tsv(temp)
    ##             expression = temp
    ##         }
    ##         if (is.null(expression)) {
    ##             stop("CORR method requires expression data")
    ##         }
    ##         arguments$expression = paste("--rawData", shQuote(expression))
    ##     }
    ##     else if (test %in% c("ORA", "GSR", "ROC") & !is.null(expression)) {
    ##         warning("You have provided expression data to use with ", 
    ##             test, " method.", " This is not possible. Gene scores will be ignored. Please refer", 
    ##             " to ermineJ documentation.")
    ##     }
    ##     if (is.list(customGeneSets)) {
    ##         tempdir = tempdir()
    ##         file.create(file.path(tempdir, "customGeneSet"))
    ##         seq_along(customGeneSets) %>% lapply(function(i) {
    ##             cat(glue::glue("{names(customGeneSets)[i]}\tNA\t", 
    ##                 customGeneSets[[i]] %>% paste(collapse = "\t"), 
    ##                 "\n\n"), file = file.path(tempdir, "customGeneSet"), 
    ##                 append = TRUE)
    ##         })
    ##         customGeneSets = tempdir
    ##     }
    ##     if (!is.null(customGeneSets)) {
    ##         arguments$customGeneSets = paste("-f", shQuote(customGeneSets))
    ##     }
    ##     assertthat::assert_that(all(aspects %in% c("Molecular Function", 
    ##         "Cellular Component", "Biological Process", "C", "B", 
    ##         "M")))
    ##     arguments$aspects = aspects %>% sapply(function(x) {
    ##         out = switch(x, `Molecular Function` = "M", `Cellular Component` = "C", 
    ##             `Biological Process` = "B")
    ##         if (is.null(out)) {
    ##             out = x
    ##         }
    ##         return(out)
    ##     }) %>% paste(collapse = "") %>% paste("-aspects", .)
    ##     if (test == "ORA") {
    ##         assertthat::is.number(threshold)
    ##         arguments$threshold = paste("--threshold", threshold)
    ##     }
    ##     if (bigIsBetter) {
    ##         arguments$bigIsBetter = "-b"
    ##     }
    ##     arguments$geneReplicates = paste("--reps", toupper(geneReplicates))
    ##     if (!is.null(iterations)) {
    ##         if (test %in% c("GSR", "CORR")) {
    ##             assertthat::is.number(iterations)
    ##             arguments$iterations = paste("--iters", iterations)
    ##         }
    ##         else {
    ##             warning("You have provided an iteration count for ", 
    ##                 test, " anaylsis. ", "This is not possible. Iterations will be ignored. Please", 
    ##                 " refer to ermineJ documentation")
    ##         }
    ##     }
    ##     genesOut = TRUE
    ##     if (genesOut) {
    ##         arguments$genesOut = "--genesOut"
    ##     }
    ##     if (logTrans) {
    ##         arguments$logTrans = "--logTrans"
    ##     }
    ##     arguments$pAdjust = switch(pAdjust, FDR = "--mtc FDR", FWE = "--mtc FWE")
    ##     arguments$test = paste("--test", test)
    ##     if (!is.null(output)) {
    ##         assertthat::is.string(output)
    ##         arguments$output = paste("--output", shQuote(output))
    ##     }
    ##     else {
    ##         output = tempfile()
    ##         arguments$output = paste("--output", shQuote(output))
    ##     }
    ##     assertthat::is.number(minClassSize)
    ##     arguments$minClassSize = paste("--minClassSize", minClassSize)
    ##     assertthat::is.number(maxClassSize)
    ##     arguments$maxClassSize = paste("--maxClassSize", maxClassSize)
    ##     if (test == "GSR") {
    ##         stats = switch(stats, mean = "MEAN", quantile = "QUANTILE", 
    ##             meanAboveQuantile = "MEAN_ABOVE_QUANTILE", precisionRecall = "PRECISIONRECALL")
    ##         arguments$stats = paste("--stats", stats)
    ##         if (stats == "MEAN_ABOVE_QUANTILE") {
    ##             assertthat::is.number(quantile)
    ##             arguments$quantile = paste("--quantile", quantile)
    ##         }
    ##     }
    ##     arguments$seed = paste("-seed", runif(1) * 10^16)
    ##     if (Sys.info()["sysname"] == "Windows") {
    ##         ermineExec = file.path(ermineJHome, "bin/ermineJ.bat")
    ##     }
    ##     else {
    ##         ermineExec = file.path(ermineJHome, "bin/ermineJ.sh")
    ##     }
    ##     call = paste(shQuote(ermineExec), paste(unlist(arguments), 
    ##         collapse = " "))
    ##     response = system2(ermineExec, args = arguments, stdout = TRUE, 
    ##         stderr = TRUE)
    ##     badJavaHome = "JAVA_HOME is not defined correctly|JAVA_HOME is set to an invalid directory"
    ##     if (any(grepl(pattern = badJavaHome, x = response))) {
    ##         stop("JAVA_HOME is not defined correctly. Install rJava or use Sys.setenv() to set JAVA_HOME")
    ##     }
    ##     else if (grepl(pattern = "No usable gene scores found.", 
    ##         x = response) %>% any) {
    ##         stop("No usable gene scores found. Please check you have ", 
    ##             "selected the right column, that the file has the correct ", 
    ##             "plain text format and that it corresponds to the gene ", 
    ##             "annotation file you selected.")
    ##     }
    ##     else if (any(grepl(pattern = "Could not reserve enough space for", 
    ##         x = response))) {
    ##         stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ##     }
    ##     if (!any(grepl(pattern = "^Done!$", response))) {
    ##         stop("Something went wrong. Blame the dev\n", paste(response, 
    ##             collapse = "\n"))
    ##     }
    ##     if (return) {
    ##         out = readErmineJOutput(output)
    ##         out$details$call = call
    ##         return(out)
    ##     }
    ## })(hitlist = hitlist, annotation = "Generic_human", test = "ORA")
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#104: annoFile = readErmineJAnnot(annotation)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#106: allGenes = annoFile[, 1] %>% unique
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#108: scores = data.frame(scores = rep(1, length(allGenes)))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#109: rownames(scores) = allGenes
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#111: scores[hitlist, ] = 0
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#121: if (is.null(scores)) {
    ##     stop(test, " method requries a score list.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#124: assertthat::assert_that("data.frame" %in% class(scores))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#125: temp = tempfile()
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#126: scores %>% utils::write.table(temp, sep = "\t", quote = FALSE)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#127: arguments$scores = paste("--scoreFile", shQuote(temp))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#131: assertthat::assert_that(assertthat::is.number(scoreColumn) | 
    ##     assertthat::is.string(scoreColumn))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#135: if (assertthat::is.string(scoreColumn)) {
    ##     scoreColumn = which(names(scores) %in% scoreColumn)
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#138: scoreColumn = scoreColumn + 1
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#139: arguments$scoreColumn = paste("--scoreCol", scoreColumn)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#148: if (test == "CORR") {
    ##     if ("data.frame" %in% class(expression)) {
    ##         temp = tempfile()
    ##         expression %>% readr::write_tsv(temp)
    ##         expression = temp
    ##     }
    ##     if (is.null(expression)) {
    ##         stop("CORR method requires expression data")
    ##     }
    ##     arguments$expression = paste("--rawData", shQuote(expression))
    ## } else if (test %in% c("ORA", "GSR", "ROC") & !is.null(expression)) {
    ##     warning("You have provided expression data to use with ", 
    ##         test, " method.", " This is not possible. Gene scores will be ignored. Please refer", 
    ##         " to ermineJ documentation.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#148: if (test %in% c("ORA", "GSR", "ROC") & !is.null(expression)) {
    ##     warning("You have provided expression data to use with ", 
    ##         test, " method.", " This is not possible. Gene scores will be ignored. Please refer", 
    ##         " to ermineJ documentation.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#166: if (is.list(customGeneSets)) {
    ##     tempdir = tempdir()
    ##     file.create(file.path(tempdir, "customGeneSet"))
    ##     seq_along(customGeneSets) %>% lapply(function(i) {
    ##         cat(glue::glue("{names(customGeneSets)[i]}\tNA\t", customGeneSets[[i]] %>% 
    ##             paste(collapse = "\t"), "\n\n"), file = file.path(tempdir, 
    ##             "customGeneSet"), append = TRUE)
    ##     })
    ##     customGeneSets = tempdir
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#177: if (!is.null(customGeneSets)) {
    ##     arguments$customGeneSets = paste("-f", shQuote(customGeneSets))
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#182: assertthat::assert_that(all(aspects %in% c("Molecular Function", 
    ##     "Cellular Component", "Biological Process", "C", "B", "M")))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#185: arguments$aspects = aspects %>% sapply(function(x) {
    ##     out = switch(x, `Molecular Function` = "M", `Cellular Component` = "C", 
    ##         `Biological Process` = "B")
    ##     if (is.null(out)) {
    ##         out = x
    ##     }
    ##     return(out)
    ## }) %>% paste(collapse = "") %>% paste("-aspects", .)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#197: if (test == "ORA") {
    ##     assertthat::is.number(threshold)
    ##     arguments$threshold = paste("--threshold", threshold)
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#198: assertthat::is.number(threshold)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#199: arguments$threshold = paste("--threshold", threshold)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#202: if (bigIsBetter) {
    ##     arguments$bigIsBetter = "-b"
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#207: arguments$geneReplicates = paste("--reps", toupper(geneReplicates))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#209: if (!is.null(iterations)) {
    ##     if (test %in% c("GSR", "CORR")) {
    ##         assertthat::is.number(iterations)
    ##         arguments$iterations = paste("--iters", iterations)
    ##     }
    ##     else {
    ##         warning("You have provided an iteration count for ", 
    ##             test, " anaylsis. ", "This is not possible. Iterations will be ignored. Please", 
    ##             " refer to ermineJ documentation")
    ##     }
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#220: genesOut = TRUE
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#221: if (genesOut) {
    ##     arguments$genesOut = "--genesOut"
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#222: arguments$genesOut = "--genesOut"
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#224: if (logTrans) {
    ##     arguments$logTrans = "--logTrans"
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#227: arguments$pAdjust = switch(pAdjust, FDR = "--mtc FDR", FWE = "--mtc FWE")
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#232: arguments$test = paste("--test", test)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#235: if (!is.null(output)) {
    ##     assertthat::is.string(output)
    ##     arguments$output = paste("--output", shQuote(output))
    ## } else {
    ##     output = tempfile()
    ##     arguments$output = paste("--output", shQuote(output))
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#239: output = tempfile()
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#240: arguments$output = paste("--output", shQuote(output))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#243: assertthat::is.number(minClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#244: arguments$minClassSize = paste("--minClassSize", minClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#245: assertthat::is.number(maxClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#246: arguments$maxClassSize = paste("--maxClassSize", maxClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#248: if (test == "GSR") {
    ##     stats = switch(stats, mean = "MEAN", quantile = "QUANTILE", 
    ##         meanAboveQuantile = "MEAN_ABOVE_QUANTILE", precisionRecall = "PRECISIONRECALL")
    ##     arguments$stats = paste("--stats", stats)
    ##     if (stats == "MEAN_ABOVE_QUANTILE") {
    ##         assertthat::is.number(quantile)
    ##         arguments$quantile = paste("--quantile", quantile)
    ##     }
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#263: arguments$seed = paste("-seed", runif(1) * 10^16)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#266: if (Sys.info()["sysname"] == "Windows") {
    ##     ermineExec = file.path(ermineJHome, "bin/ermineJ.bat")
    ## } else {
    ##     ermineExec = file.path(ermineJHome, "bin/ermineJ.sh")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#267: ermineExec = file.path(ermineJHome, "bin/ermineJ.bat")
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#274: call = paste(shQuote(ermineExec), paste(unlist(arguments), collapse = " "))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#276: response = system2(ermineExec, args = arguments, stdout = TRUE, 
    ##     stderr = TRUE)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#278: badJavaHome = "JAVA_HOME is not defined correctly|JAVA_HOME is set to an invalid directory"
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#281: if (any(grepl(pattern = badJavaHome, x = response))) {
    ##     stop("JAVA_HOME is not defined correctly. Install rJava or use Sys.setenv() to set JAVA_HOME")
    ## } else if (grepl(pattern = "No usable gene scores found.", x = response) %>% 
    ##     any) {
    ##     stop("No usable gene scores found. Please check you have ", 
    ##         "selected the right column, that the file has the correct ", 
    ##         "plain text format and that it corresponds to the gene ", 
    ##         "annotation file you selected.")
    ## } else if (any(grepl(pattern = "Could not reserve enough space for", 
    ##     x = response))) {
    ##     stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#281: if (grepl(pattern = "No usable gene scores found.", x = response) %>% 
    ##     any) {
    ##     stop("No usable gene scores found. Please check you have ", 
    ##         "selected the right column, that the file has the correct ", 
    ##         "plain text format and that it corresponds to the gene ", 
    ##         "annotation file you selected.")
    ## } else if (any(grepl(pattern = "Could not reserve enough space for", 
    ##     x = response))) {
    ##     stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#281: if (any(grepl(pattern = "Could not reserve enough space for", 
    ##     x = response))) {
    ##     stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#292: if (!any(grepl(pattern = "^Done!$", response))) {
    ##     stop("Something went wrong. Blame the dev\n", paste(response, 
    ##         collapse = "\n"))
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#302: if (return) {
    ##     out = readErmineJOutput(output)
    ##     out$details$call = call
    ##     return(out)
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#303: out = readErmineJOutput(output)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#304: out$details$call = call
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#305: return(out)

``` r
head(oraOut$results) %>% knitr::kable()
```

| Name                                        | ID           |  NumProbes|  NumGenes|  RawScore|  Pval|  CorrectedPvalue|  MFPvalue|  CorrectedMFPvalue|  Multifunctionality| Same as | GeneMembers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|:--------------------------------------------|:-------------|----------:|---------:|---------:|-----:|----------------:|---------:|------------------:|-------------------:|:--------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unfolded protein binding                    | <GO:0051082> |        123|       123|       114|     0|                0|         0|                  0|               0.641| NA      | AAMP|AFG3L2|AHSP|AIP|AIPL1|APCS|BBS12|CALR|CALR3|CANX|CCDC115|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CDC37|CDC37L1|CHAF1A|CHAF1B|CLGN|CLN3|CLPX|CRYAA|CRYAB|DNAJA1|DNAJA2|DNAJA3|DNAJA4|DNAJB1|DNAJB11|DNAJB13|DNAJB2|DNAJB4|DNAJB5|DNAJB6|DNAJB8|DNAJC4|DZIP3|ERLEC1|ERO1B|FYCO1|GRPEL1|GRPEL2|HEATR3|HSP90AA1|HSP90AA2P|HSP90AA4P|HSP90AA5P|HSP90AB1|HSP90AB2P|HSP90AB3P|HSP90AB4P|HSP90B1|HSP90B2P|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPB6|HSPD1|HSPE1|HSPH1|HTRA2|HYOU1|LMAN1|MDN1|MKKS|NAP1L4|NDUFAF1|NPM1|NUDC|NUDCD2|NUDCD3|NWD2|PDRG1|PET100|PFDN1|PFDN2|PFDN4|PFDN5|PFDN6|PIKFYVE|PPIA|PPIB|PTGES3|RP2|RUVBL2|SCAP|SCG5|SERPINH1|SHQ1|SIL1|SPG7|SRSF10|SRSF12|ST13|SYVN1|TAPBP|TCP1|TMEM67|TOMM20|TOR1A|TRAP1|TTC1|TUBB4B|UGGT1|UGGT2|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                          |
| chaperone-mediated protein folding          | <GO:0061077> |         81|        81|        37|     0|                0|         0|                  0|               0.679| NA      | BAG1|BBS12|CALR|CANX|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CHORDC1|CLU|CRTAP|CSNK2A1|DFFA|DNAJB1|DNAJB12|DNAJB14|DNAJB2|DNAJB8|DNAJC24|DNAJC7|ERO1A|FKBP10|FKBP11|FKBP14|FKBP1A|FKBP1B|FKBP2|FKBP3|FKBP4|FKBP5|FKBP6|FKBP7|FKBP8|FKBP9|FYCO1|GAK|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPB1|HSPB6|HSPD1|HSPE1|HSPH1|HYOU1|MKKS|P3H1|PDIA4|PEX19|PIKFYVE|PPIB|PPID|PTGES3|ST13|ST13P4|ST13P5|TCP1|TOR1A|TOR1B|TOR2A|TRAP1|UNC45A|UNC45B|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| protein binding involved in protein folding | <GO:0044183> |         43|        43|        31|     0|                0|         0|                  0|               0.642| NA      | BBS12|CALR|CALR3|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CLGN|DFFA|DNAJB8|FYCO1|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPB1|HSPD1|HSPH1|HYOU1|MKKS|PDCL3|PFDN1|PFDN2|PIKFYVE|RIC3|TCP1|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| 'de novo' protein folding                   | <GO:0006458> |         54|        54|        31|     0|                0|         0|                  0|               0.708| NA      | BAG1|BBS12|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CHCHD4|DNAJB1|DNAJB12|DNAJB14|DNAJC2|DNAJC7|ENTPD5|ERO1A|FKBP1A|FKBP1B|FYCO1|GAK|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPD1|HSPE1|HSPH1|HYOU1|MKKS|PIKFYVE|PTGES3|SELENOF|ST13|TCP1|TOR1A|TOR1B|TOR2A|UGGT1|UGGT2|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| chaperone binding                           | <GO:0051087> |         96|        96|        23|     0|                0|         0|                  0|               0.758| NA      | AHSA1|AHSA2P|ALB|AMFR|ATP1A1|ATP1A2|ATP1A3|ATP7A|BAG1|BAG2|BAG3|BAG4|BAG5|BAK1|BAX|BIN1|BIRC2|BIRC5|CALR|CDC25A|CDC37|CDC37L1|CDKN1B|CLU|CP|CTSC|DNAJA1|DNAJA2|DNAJA4|DNAJB1|DNAJB2|DNAJB4|DNAJB5|DNAJB6|DNAJB7|DNAJB8|DNAJB9|DNAJC1|DNAJC10|DNAJC3|DNLZ|ERP29|FGB|FICD|FN1|FNIP1|FNIP2|GAK|GET4|GNB5|GRPEL1|GRPEL2|HES1|HSCB|HSPA5|HSPB6|HSPD1|HSPE1|HYOU1|KSR1|LRP2|MAPT|OGDH|PACRG|PDPN|PFDN4|PFDN6|PIH1D3|PLG|PRKN|PRNP|PTGES3|PTGES3L|RNF207|SACS|SDF2L1|SLC25A17|SOD1|ST13|STIP1|SYVN1|TBCA|TBCC|TBCD|TBCE|TERT|TIMM10|TIMM44|TIMM9|TP53|TSACC|TSC1|UBL4A|USP13|VWF|WRAP53|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| response to topologically incorrect protein | <GO:0035966> |        182|       182|        26|     0|                0|         0|                  0|               0.903| NA      | ACADVL|ADD1|AMFR|ANKZF1|ARFGAP1|ASNA1|ASNS|ATF3|ATF4|ATF6|ATF6B|ATP6V0D1|ATXN3|BAG6|BHLHA15|CALR|CCL2|CCND1|CDK5RAP3|CHAC1|CLU|CREB3|CREB3L1|CREB3L2|CREB3L3|CREB3L4|CREBRF|CTDSP2|CTH|CUL3|CUL7|CXCL8|CXXC1|DAXX|DCTN1|DDIT3|DDX11|DERL1|DERL2|DERL3|DNAJA1|DNAJB1|DNAJB11|DNAJB12|DNAJB2|DNAJB4|DNAJB5|DNAJB9|DNAJC3|DNAJC4|DZIP3|EDEM1|EDEM2|EDEM3|EIF2AK2|EIF2AK3|EIF2S1|EP300|ERN1|ERO1A|ERP44|EXTL1|EXTL2|EXTL3|F12|FAF2|FBXO6|FGF21|FICD|FKBP14|GFPT1|GOSR2|GSK3A|HDAC6|HDGF|HERPUD1|HERPUD2|HSF1|HSP90AA1|HSP90AB1|HSP90B1|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPB1|HSPB2|HSPB3|HSPB7|HSPD1|HSPE1|HSPH1|HYOU1|IGFBP1|JKAMP|KDELR3|KLHDC3|KLHL15|LMNA|MANF|MBTPS1|MBTPS2|MFN2|MMP24-AS1-EDEM2|MYDGF|NFE2L2|OPTN|PACRG|PARP16|PDIA5|PDIA6|PLA2G4B|POMT1|POMT2|PPP2R5B|PREB|PRKN|PTPN1|RHBDD1|RNF121|RNF126|RNF175|RNF185|RNF5|SDF2|SDF2L1|SEC31A|SEC61A1|SEC61A2|SEC61B|SEC61G|SEC62|SEC63|SELENOS|SERP1|SERP2|SERPINH1|SHC1|SRPRA|SRPRB|SSR1|STC2|STT3B|STUB1|SULT1A3|SYVN1|TATDN2|TBL2|THBS1|THBS4|TLN1|TM7SF3|TMBIM6|TMEM129|TOR1A|TOR1B|TPP1|TSPYL2|TUSC1|UBE2J2|UBE2W|UBXN4|UFD1|UGGT1|UGGT2|VAPB|VCP|WFS1|WIPI1|XBP1|YIF1A|YOD1|ZBTB17| |

#### Using your own GO annotations

If you want to use your own GO annotations instead of getting files provided by Pavlidis Lab, you can use `makeAnnotation` after turning your annotations into a list. See the example below

``` r
library('org.Hs.eg.db') # get go terms from bioconductor 
goAnnots = as.list(org.Hs.egGO)
goAnnots = goAnnots %>% lapply(names)
goAnnots %>% head
```

    ## $`1`
    ## [1] "GO:0002576" "GO:0008150" "GO:0005576" "GO:0005576" "GO:0005615"
    ## [6] "GO:0031093" "GO:0070062" "GO:0072562" "GO:0003674"
    ## 
    ## $`2`
    ##  [1] "GO:0001869" "GO:0002576" "GO:0007597" "GO:0010951" "GO:0022617"
    ##  [6] "GO:0043547" "GO:0048863" "GO:0051056" "GO:0005576" "GO:0005576"
    ## [11] "GO:0005829" "GO:0031093" "GO:0070062" "GO:0072562" "GO:0002020"
    ## [16] "GO:0004867" "GO:0005096" "GO:0005102" "GO:0005515" "GO:0019838"
    ## [21] "GO:0019899" "GO:0019959" "GO:0019966" "GO:0043120" "GO:0048306"
    ## 
    ## $`3`
    ## NULL
    ## 
    ## $`9`
    ## [1] "GO:0006805" "GO:0005829" "GO:0004060"
    ## 
    ## $`10`
    ## [1] "GO:0006805" "GO:0005829" "GO:0004060"
    ## 
    ## $`11`
    ## NULL

The goAnnots object we created has go terms per entrez ID. Similar lists can be obtained from other species db packages in bioconductor and some array annotation packages. We will now use the `makeAnnotation` function to create our annotation file. This file will have the names of this list (entrez IDs) as gene identifiers so any score or hitlist file you provide should have the entrez IDs as well.

`makeAnnotation` only needs the list with gene identifiers and go terms to work. But if you want to have a complete annotation file you can also provide gene symbols and gene names. Gene names have no effect on the analysis. Gene symbols matter if you are [providing custom gene sets](http://erminej.msl.ubc.ca/help/input-files/gene-sets/) and using "Option 2" or if same genes are represented by multiple gene identifiers (eg. probes). Gene symbols will also be returned in the `GeneMembers` column of the output. If they are not provided, gene IDs will also be used as gene symbols

Here we'll set them both for good measure.

``` r
geneSymbols = as.list(org.Hs.egSYMBOL) %>% unlist
geneName = as.list(org.Hs.egGENENAME) %>% unlist

annotation = makeAnnotation(goAnnots,
                            symbol = geneSymbols,
                            name = geneName,
                            output = NULL, # you can choose to save the annotation to a file
                            return = TRUE) # if you only want to save it to a file, you don't need to return
```

Now that we have the annotation object, we can use it to run an analysis. We'll try to generate a hitlist only composed of genes annotated with <GO:0051082>.

``` r
mockHitlist = goAnnots %>% sapply(function(x){'GO:0051082' %in% x}) %>% 
    {goAnnots[.]} %>% 
    names

mockHitlist %>% head
```

    ## [1] "14"  "325" "811" "821" "871" "908"

``` r
oraOut = ora(annotation = annotation,
             hitlist = mockHitlist)
```

    ## Called from: (function (annotation = NULL, aspects = c("Molecular Function", 
    ##     "Cellular Component", "Biological Process"), scores = NULL, 
    ##     hitlist = NULL, scoreColumn = 1, threshold = 0.001, expression = NULL, 
    ##     bigIsBetter = FALSE, customGeneSets = NULL, geneReplicates = c("mean", 
    ##         "best"), logTrans = FALSE, pAdjust = c("FDR", "FWE"), 
    ##     test = c("ORA", "GSR", "CORR", "ROC"), iterations = NULL, 
    ##     stats = c("mean", "quantile", "meanAboveQuantile", "precisionRecall"), 
    ##     quantile = 50, geneSetDescription = "Latest_GO", output = NULL, 
    ##     return = TRUE, minClassSize = 20, maxClassSize = 200) 
    ## {
    ##     test = match.arg(test)
    ##     pAdjust = match.arg(pAdjust)
    ##     geneReplicates = match.arg(geneReplicates)
    ##     stats = match.arg(stats)
    ##     ermineJHome = system.file("ermineJ-3.1.2", package = "ermineR")
    ##     Sys.setenv(ERMINEJ_HOME = ermineJHome)
    ##     if (Sys.getenv("JAVA_HOME") == "") {
    ##         findJava()
    ##     }
    ##     arguments = list()
    ##     if ("character" %in% class(annotation)) {
    ##         if (!file.exists(annotation)) {
    ##             message("Attempting to download annotation file")
    ##             tryCatch(suppressWarnings(getGemmaAnnot(annotation, 
    ##                 chipFile = annotation, annotType = "noParents")), 
    ##                 error = function(e) {
    ##                   stop("\"annotation\" is not a valid file or exists in Pavlidis lab annotations. See http://www.chibi.ubc.ca/microannots for available options.")
    ##                 })
    ##         }
    ##     }
    ##     else if ("data.frame" %in% class(annotation)) {
    ##         temp = tempfile()
    ##         annotation %>% readr::write_tsv(temp)
    ##         annotation = temp
    ##     }
    ##     assertthat::is.string(annotation)
    ##     arguments$annotation = paste("--annots", shQuote(annotation))
    ##     if (geneSetDescription == "Latest_GO") {
    ##         temp = tempfile(fileext = ".xml.gz")
    ##         utils::download.file("http://archive.geneontology.org/latest-termdb/go_daily-termdb.rdf-xml.gz", 
    ##             destfile = temp, quiet = TRUE)
    ##         geneSetDescription = temp
    ##     }
    ##     else if (!file.exists(geneSetDescription)) {
    ##         message("Attempting to download gene set description from link")
    ##         temp = tempfile(fileext = "xml.gz")
    ##         download.file(url = geneSetDescription, destfile = temp, 
    ##             quiet = TRUE)
    ##         geneSetDescription = temp
    ##     }
    ##     assertthat::is.string(geneSetDescription)
    ##     arguments$geneSetDescription = paste("--classFile", shQuote(geneSetDescription))
    ##     if (test %in% c("ORA", "GSR", "ROC")) {
    ##         if (test == "ORA" & is.null(scores) & !is.null(hitlist)) {
    ##             logTrans = FALSE
    ##             bigIsBetter = FALSE
    ##             threshold = 0.5
    ##             scoreColumn = 1
    ##             browser()
    ##             annoFile = readErmineJAnnot(annotation)
    ##             allGenes = annoFile[, 1] %>% unique
    ##             scores = data.frame(scores = rep(1, length(allGenes)))
    ##             rownames(scores) = allGenes
    ##             scores[hitlist, ] = 0
    ##         }
    ##         else if (test == "ORA" & is.null(scores) & is.null(hitlist)) {
    ##             stop("ORA method requires scores or hitlist")
    ##         }
    ##         else if (!is.null(scores) & !is.null(hitlist)) {
    ##             stop("You can't provide both scores and a hitlist")
    ##         }
    ##         if (is.null(scores)) {
    ##             stop(test, " method requries a score list.")
    ##         }
    ##         assertthat::assert_that("data.frame" %in% class(scores))
    ##         temp = tempfile()
    ##         scores %>% utils::write.table(temp, sep = "\t", quote = FALSE)
    ##         arguments$scores = paste("--scoreFile", shQuote(temp))
    ##         assertthat::assert_that(assertthat::is.number(scoreColumn) | 
    ##             assertthat::is.string(scoreColumn))
    ##         if (assertthat::is.string(scoreColumn)) {
    ##             scoreColumn = which(names(scores) %in% scoreColumn)
    ##         }
    ##         scoreColumn = scoreColumn + 1
    ##         arguments$scoreColumn = paste("--scoreCol", scoreColumn)
    ##     }
    ##     else if (test == "CORR" & !is.null(scores)) {
    ##         warning("You have provided gene scores to use with correlation analysis.", 
    ##             " This is not possible. Gene scores will be ignored. Please refer", 
    ##             " to ermineJ documentation.")
    ##     }
    ##     if (test == "CORR") {
    ##         if ("data.frame" %in% class(expression)) {
    ##             temp = tempfile()
    ##             expression %>% readr::write_tsv(temp)
    ##             expression = temp
    ##         }
    ##         if (is.null(expression)) {
    ##             stop("CORR method requires expression data")
    ##         }
    ##         arguments$expression = paste("--rawData", shQuote(expression))
    ##     }
    ##     else if (test %in% c("ORA", "GSR", "ROC") & !is.null(expression)) {
    ##         warning("You have provided expression data to use with ", 
    ##             test, " method.", " This is not possible. Gene scores will be ignored. Please refer", 
    ##             " to ermineJ documentation.")
    ##     }
    ##     if (is.list(customGeneSets)) {
    ##         tempdir = tempdir()
    ##         file.create(file.path(tempdir, "customGeneSet"))
    ##         seq_along(customGeneSets) %>% lapply(function(i) {
    ##             cat(glue::glue("{names(customGeneSets)[i]}\tNA\t", 
    ##                 customGeneSets[[i]] %>% paste(collapse = "\t"), 
    ##                 "\n\n"), file = file.path(tempdir, "customGeneSet"), 
    ##                 append = TRUE)
    ##         })
    ##         customGeneSets = tempdir
    ##     }
    ##     if (!is.null(customGeneSets)) {
    ##         arguments$customGeneSets = paste("-f", shQuote(customGeneSets))
    ##     }
    ##     assertthat::assert_that(all(aspects %in% c("Molecular Function", 
    ##         "Cellular Component", "Biological Process", "C", "B", 
    ##         "M")))
    ##     arguments$aspects = aspects %>% sapply(function(x) {
    ##         out = switch(x, `Molecular Function` = "M", `Cellular Component` = "C", 
    ##             `Biological Process` = "B")
    ##         if (is.null(out)) {
    ##             out = x
    ##         }
    ##         return(out)
    ##     }) %>% paste(collapse = "") %>% paste("-aspects", .)
    ##     if (test == "ORA") {
    ##         assertthat::is.number(threshold)
    ##         arguments$threshold = paste("--threshold", threshold)
    ##     }
    ##     if (bigIsBetter) {
    ##         arguments$bigIsBetter = "-b"
    ##     }
    ##     arguments$geneReplicates = paste("--reps", toupper(geneReplicates))
    ##     if (!is.null(iterations)) {
    ##         if (test %in% c("GSR", "CORR")) {
    ##             assertthat::is.number(iterations)
    ##             arguments$iterations = paste("--iters", iterations)
    ##         }
    ##         else {
    ##             warning("You have provided an iteration count for ", 
    ##                 test, " anaylsis. ", "This is not possible. Iterations will be ignored. Please", 
    ##                 " refer to ermineJ documentation")
    ##         }
    ##     }
    ##     genesOut = TRUE
    ##     if (genesOut) {
    ##         arguments$genesOut = "--genesOut"
    ##     }
    ##     if (logTrans) {
    ##         arguments$logTrans = "--logTrans"
    ##     }
    ##     arguments$pAdjust = switch(pAdjust, FDR = "--mtc FDR", FWE = "--mtc FWE")
    ##     arguments$test = paste("--test", test)
    ##     if (!is.null(output)) {
    ##         assertthat::is.string(output)
    ##         arguments$output = paste("--output", shQuote(output))
    ##     }
    ##     else {
    ##         output = tempfile()
    ##         arguments$output = paste("--output", shQuote(output))
    ##     }
    ##     assertthat::is.number(minClassSize)
    ##     arguments$minClassSize = paste("--minClassSize", minClassSize)
    ##     assertthat::is.number(maxClassSize)
    ##     arguments$maxClassSize = paste("--maxClassSize", maxClassSize)
    ##     if (test == "GSR") {
    ##         stats = switch(stats, mean = "MEAN", quantile = "QUANTILE", 
    ##             meanAboveQuantile = "MEAN_ABOVE_QUANTILE", precisionRecall = "PRECISIONRECALL")
    ##         arguments$stats = paste("--stats", stats)
    ##         if (stats == "MEAN_ABOVE_QUANTILE") {
    ##             assertthat::is.number(quantile)
    ##             arguments$quantile = paste("--quantile", quantile)
    ##         }
    ##     }
    ##     arguments$seed = paste("-seed", runif(1) * 10^16)
    ##     if (Sys.info()["sysname"] == "Windows") {
    ##         ermineExec = file.path(ermineJHome, "bin/ermineJ.bat")
    ##     }
    ##     else {
    ##         ermineExec = file.path(ermineJHome, "bin/ermineJ.sh")
    ##     }
    ##     call = paste(shQuote(ermineExec), paste(unlist(arguments), 
    ##         collapse = " "))
    ##     response = system2(ermineExec, args = arguments, stdout = TRUE, 
    ##         stderr = TRUE)
    ##     badJavaHome = "JAVA_HOME is not defined correctly|JAVA_HOME is set to an invalid directory"
    ##     if (any(grepl(pattern = badJavaHome, x = response))) {
    ##         stop("JAVA_HOME is not defined correctly. Install rJava or use Sys.setenv() to set JAVA_HOME")
    ##     }
    ##     else if (grepl(pattern = "No usable gene scores found.", 
    ##         x = response) %>% any) {
    ##         stop("No usable gene scores found. Please check you have ", 
    ##             "selected the right column, that the file has the correct ", 
    ##             "plain text format and that it corresponds to the gene ", 
    ##             "annotation file you selected.")
    ##     }
    ##     else if (any(grepl(pattern = "Could not reserve enough space for", 
    ##         x = response))) {
    ##         stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ##     }
    ##     if (!any(grepl(pattern = "^Done!$", response))) {
    ##         stop("Something went wrong. Blame the dev\n", paste(response, 
    ##             collapse = "\n"))
    ##     }
    ##     if (return) {
    ##         out = readErmineJOutput(output)
    ##         out$details$call = call
    ##         return(out)
    ##     }
    ## })(hitlist = mockHitlist, annotation = annotation, test = "ORA")
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#104: annoFile = readErmineJAnnot(annotation)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#106: allGenes = annoFile[, 1] %>% unique
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#108: scores = data.frame(scores = rep(1, length(allGenes)))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#109: rownames(scores) = allGenes
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#111: scores[hitlist, ] = 0
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#121: if (is.null(scores)) {
    ##     stop(test, " method requries a score list.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#124: assertthat::assert_that("data.frame" %in% class(scores))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#125: temp = tempfile()
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#126: scores %>% utils::write.table(temp, sep = "\t", quote = FALSE)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#127: arguments$scores = paste("--scoreFile", shQuote(temp))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#131: assertthat::assert_that(assertthat::is.number(scoreColumn) | 
    ##     assertthat::is.string(scoreColumn))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#135: if (assertthat::is.string(scoreColumn)) {
    ##     scoreColumn = which(names(scores) %in% scoreColumn)
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#138: scoreColumn = scoreColumn + 1
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#139: arguments$scoreColumn = paste("--scoreCol", scoreColumn)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#148: if (test == "CORR") {
    ##     if ("data.frame" %in% class(expression)) {
    ##         temp = tempfile()
    ##         expression %>% readr::write_tsv(temp)
    ##         expression = temp
    ##     }
    ##     if (is.null(expression)) {
    ##         stop("CORR method requires expression data")
    ##     }
    ##     arguments$expression = paste("--rawData", shQuote(expression))
    ## } else if (test %in% c("ORA", "GSR", "ROC") & !is.null(expression)) {
    ##     warning("You have provided expression data to use with ", 
    ##         test, " method.", " This is not possible. Gene scores will be ignored. Please refer", 
    ##         " to ermineJ documentation.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#148: if (test %in% c("ORA", "GSR", "ROC") & !is.null(expression)) {
    ##     warning("You have provided expression data to use with ", 
    ##         test, " method.", " This is not possible. Gene scores will be ignored. Please refer", 
    ##         " to ermineJ documentation.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#166: if (is.list(customGeneSets)) {
    ##     tempdir = tempdir()
    ##     file.create(file.path(tempdir, "customGeneSet"))
    ##     seq_along(customGeneSets) %>% lapply(function(i) {
    ##         cat(glue::glue("{names(customGeneSets)[i]}\tNA\t", customGeneSets[[i]] %>% 
    ##             paste(collapse = "\t"), "\n\n"), file = file.path(tempdir, 
    ##             "customGeneSet"), append = TRUE)
    ##     })
    ##     customGeneSets = tempdir
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#177: if (!is.null(customGeneSets)) {
    ##     arguments$customGeneSets = paste("-f", shQuote(customGeneSets))
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#182: assertthat::assert_that(all(aspects %in% c("Molecular Function", 
    ##     "Cellular Component", "Biological Process", "C", "B", "M")))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#185: arguments$aspects = aspects %>% sapply(function(x) {
    ##     out = switch(x, `Molecular Function` = "M", `Cellular Component` = "C", 
    ##         `Biological Process` = "B")
    ##     if (is.null(out)) {
    ##         out = x
    ##     }
    ##     return(out)
    ## }) %>% paste(collapse = "") %>% paste("-aspects", .)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#197: if (test == "ORA") {
    ##     assertthat::is.number(threshold)
    ##     arguments$threshold = paste("--threshold", threshold)
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#198: assertthat::is.number(threshold)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#199: arguments$threshold = paste("--threshold", threshold)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#202: if (bigIsBetter) {
    ##     arguments$bigIsBetter = "-b"
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#207: arguments$geneReplicates = paste("--reps", toupper(geneReplicates))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#209: if (!is.null(iterations)) {
    ##     if (test %in% c("GSR", "CORR")) {
    ##         assertthat::is.number(iterations)
    ##         arguments$iterations = paste("--iters", iterations)
    ##     }
    ##     else {
    ##         warning("You have provided an iteration count for ", 
    ##             test, " anaylsis. ", "This is not possible. Iterations will be ignored. Please", 
    ##             " refer to ermineJ documentation")
    ##     }
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#220: genesOut = TRUE
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#221: if (genesOut) {
    ##     arguments$genesOut = "--genesOut"
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#222: arguments$genesOut = "--genesOut"
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#224: if (logTrans) {
    ##     arguments$logTrans = "--logTrans"
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#227: arguments$pAdjust = switch(pAdjust, FDR = "--mtc FDR", FWE = "--mtc FWE")
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#232: arguments$test = paste("--test", test)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#235: if (!is.null(output)) {
    ##     assertthat::is.string(output)
    ##     arguments$output = paste("--output", shQuote(output))
    ## } else {
    ##     output = tempfile()
    ##     arguments$output = paste("--output", shQuote(output))
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#239: output = tempfile()
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#240: arguments$output = paste("--output", shQuote(output))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#243: assertthat::is.number(minClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#244: arguments$minClassSize = paste("--minClassSize", minClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#245: assertthat::is.number(maxClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#246: arguments$maxClassSize = paste("--maxClassSize", maxClassSize)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#248: if (test == "GSR") {
    ##     stats = switch(stats, mean = "MEAN", quantile = "QUANTILE", 
    ##         meanAboveQuantile = "MEAN_ABOVE_QUANTILE", precisionRecall = "PRECISIONRECALL")
    ##     arguments$stats = paste("--stats", stats)
    ##     if (stats == "MEAN_ABOVE_QUANTILE") {
    ##         assertthat::is.number(quantile)
    ##         arguments$quantile = paste("--quantile", quantile)
    ##     }
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#263: arguments$seed = paste("-seed", runif(1) * 10^16)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#266: if (Sys.info()["sysname"] == "Windows") {
    ##     ermineExec = file.path(ermineJHome, "bin/ermineJ.bat")
    ## } else {
    ##     ermineExec = file.path(ermineJHome, "bin/ermineJ.sh")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#267: ermineExec = file.path(ermineJHome, "bin/ermineJ.bat")
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#274: call = paste(shQuote(ermineExec), paste(unlist(arguments), collapse = " "))
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#276: response = system2(ermineExec, args = arguments, stdout = TRUE, 
    ##     stderr = TRUE)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#278: badJavaHome = "JAVA_HOME is not defined correctly|JAVA_HOME is set to an invalid directory"
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#281: if (any(grepl(pattern = badJavaHome, x = response))) {
    ##     stop("JAVA_HOME is not defined correctly. Install rJava or use Sys.setenv() to set JAVA_HOME")
    ## } else if (grepl(pattern = "No usable gene scores found.", x = response) %>% 
    ##     any) {
    ##     stop("No usable gene scores found. Please check you have ", 
    ##         "selected the right column, that the file has the correct ", 
    ##         "plain text format and that it corresponds to the gene ", 
    ##         "annotation file you selected.")
    ## } else if (any(grepl(pattern = "Could not reserve enough space for", 
    ##     x = response))) {
    ##     stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#281: if (grepl(pattern = "No usable gene scores found.", x = response) %>% 
    ##     any) {
    ##     stop("No usable gene scores found. Please check you have ", 
    ##         "selected the right column, that the file has the correct ", 
    ##         "plain text format and that it corresponds to the gene ", 
    ##         "annotation file you selected.")
    ## } else if (any(grepl(pattern = "Could not reserve enough space for", 
    ##     x = response))) {
    ##     stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#281: if (any(grepl(pattern = "Could not reserve enough space for", 
    ##     x = response))) {
    ##     stop("Java could not reserve space. You may be running 32 bit Java. 32 bit java is bad java.")
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#292: if (!any(grepl(pattern = "^Done!$", response))) {
    ##     stop("Something went wrong. Blame the dev\n", paste(response, 
    ##         collapse = "\n"))
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#302: if (return) {
    ##     out = readErmineJOutput(output)
    ##     out$details$call = call
    ##     return(out)
    ## }
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#303: out = readErmineJOutput(output)
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#304: out$details$call = call
    ## debug at E:\gitRepos\ermineR/R/ermineR.R#305: return(out)

``` r
head(oraOut$results) %>% knitr::kable()
```

| Name                                        | ID           |  NumProbes|  NumGenes|  RawScore|  Pval|  CorrectedPvalue|  MFPvalue|  CorrectedMFPvalue|  Multifunctionality| Same as | GeneMembers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|:--------------------------------------------|:-------------|----------:|---------:|---------:|-----:|----------------:|---------:|------------------:|-------------------:|:--------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unfolded protein binding                    | <GO:0051082> |        105|       105|       105|     0|                0|         0|                  0|               0.617| NA      | AAMP|AFG3L2|AHSP|AIP|AIPL1|APCS|CALR|CALR3|CANX|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CDC37|CDC37L1|CHAF1A|CHAF1B|CLGN|CLN3|CLPX|CRYAA|CRYAB|DNAJA1|DNAJA2|DNAJA3|DNAJA4|DNAJB1|DNAJB11|DNAJB13|DNAJB2|DNAJB4|DNAJB5|DNAJB6|DNAJB8|DNAJC4|ERLEC1|ERO1B|GRPEL1|GRPEL2|GRXCR2|HSP90AA1|HSP90AA2P|HSP90AA4P|HSP90AA5P|HSP90AB1|HSP90AB2P|HSP90AB3P|HSP90AB4P|HSP90B1|HSP90B2P|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA5|HSPA6|HSPA8|HSPA9|HSPD1|HSPE1|HTRA2|LMAN1|LRPAP1|MDN1|MKKS|NAP1L4|NDUFAF1|NPM1|NUDC|NUDCD2|NUDCD3|PDRG1|PFDN1|PFDN2|PFDN4|PFDN5|PFDN6|PPIA|PPIB|PTGES3|RP2|RUVBL2|SCAP|SCG5|SERPINH1|SIL1|SPG7|SRSF10|SRSF12|ST13|SYVN1|TAPBP|TCP1|TMEM67|TOMM20|TOR1A|TRAP1|TTC1|TUBB4B|UGGT1|UGGT2|                                                                                                                                                                                                                                                                                                                                                                                        |
| chaperone binding                           | <GO:0051087> |         76|        76|        21|     0|                0|         0|                  0|               0.702| NA      | AHSA1|AHSA2|ALB|AMFR|ATP1A1|ATP1A2|ATP1A3|BAG1|BAG2|BAG3|BAG4|BAG5|BAK1|BIRC5|CALR|CDC37|CDC37L1|CDKN1B|CLU|CP|CTSC|DNAJA1|DNAJA2|DNAJA4|DNAJB1|DNAJB2|DNAJB4|DNAJB5|DNAJB6|DNAJB7|DNAJB8|DNAJC1|DNAJC10|DNAJC3|DNLZ|ERP29|FGB|GET4|GNB5|GRPEL1|GRPEL2|HES1|HSCB|HSPA5|HSPD1|HSPE1|HYOU1|OGDH|PACRG|PARK2|PFDN4|PFDN6|PIH1D3|PRNP|RNF207|SACS|SDF2L1|SLC25A17|SOD1|ST13|STIP1|SYVN1|TBCA|TBCC|TBCD|TBCE|TIMM10|TIMM44|TIMM9|TP53|TSACC|TSC1|UBL4A|USP13|VWF|WRAP53|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| response to topologically incorrect protein | <GO:0035966> |        166|       166|        23|     0|                0|         0|                  0|               0.903| NA      | AARS|ACADVL|ADD1|AMFR|ANKZF1|ARFGAP1|ASNA1|ASNS|ATF3|ATF4|ATF6|ATF6B|ATP6V0D1|ATXN3|BHLHA15|CALR|CASP12|CCL2|CCND1|CDK5RAP3|CHAC1|CLU|CREB3|CREB3L1|CREB3L2|CREB3L3|CREB3L4|CREBRF|CTDSP2|CTH|CUL7|CXCL8|CXXC1|DCTN1|DDIT3|DDX11|DERL1|DERL2|DERL3|DNAJA1|DNAJB1|DNAJB11|DNAJB2|DNAJB4|DNAJB5|DNAJB9|DNAJC3|DNAJC4|EDEM1|EDEM2|EDEM3|EIF2AK2|EIF2AK3|EIF2S1|EP300|ERN1|ERO1A|ERP44|EXTL3|F12|FAF2|FBXO6|FGF21|FKBP14|GFPT1|GOSR2|GSK3A|HDAC6|HDGF|HERPUD1|HERPUD2|HSP90AA1|HSP90AB1|HSP90B1|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA8|HSPB1|HSPB2|HSPB3|HSPB7|HSPD1|HSPE1|HSPH1|HYOU1|IFNG|IGFBP1|JKAMP|KDELR3|KLHDC3|LMNA|MANF|MBTPS1|MBTPS2|MFN2|MYDGF|NFE2L2|PACRG|PARK2|PARP16|PDIA5|PDIA6|PLA2G4B|POMT1|POMT2|PPP1R15A|PPP2R5B|PREB|PTPN1|RHBDD1|RNF121|RNF126|RNF175|RNF185|RNF5|SDF2|SDF2L1|SEC31A|SEC61A1|SEC61A2|SEC61B|SEC61G|SEC62|SEC63|SELENOS|SERP1|SERP2|SERPINH1|SHC1|SRPRA|SRPRB|SSR1|STC2|STT3B|STUB1|SULT1A3|SYVN1|TATDN2|TBL2|THBS1|THBS4|TLN1|TMBIM6|TMEM129|TOR1A|TOR1B|TPP1|TSPYL2|UBE2J2|UBE2W|UBXN4|UFD1L|UGGT1|UGGT2|VAPB|VCP|WFS1|WIPI1|XBP1|YIF1A|YOD1|ZBTB17| |
| response to unfolded protein                | <GO:0006986> |        151|       151|        22|     0|                0|         0|                  0|               0.901| NA      | AARS|ACADVL|ADD1|AMFR|ARFGAP1|ASNA1|ASNS|ATF3|ATF4|ATF6|ATF6B|ATP6V0D1|BHLHA15|CALR|CASP12|CCL2|CCND1|CDK5RAP3|CHAC1|CREB3|CREB3L1|CREB3L2|CREB3L3|CREB3L4|CREBRF|CTDSP2|CTH|CUL7|CXCL8|CXXC1|DCTN1|DDIT3|DDX11|DERL1|DERL2|DERL3|DNAJA1|DNAJB1|DNAJB11|DNAJB2|DNAJB4|DNAJB5|DNAJB9|DNAJC3|DNAJC4|EDEM1|EDEM2|EDEM3|EIF2AK2|EIF2AK3|EIF2S1|EP300|ERN1|ERO1A|ERP44|EXTL3|FAF2|FBXO6|FGF21|FKBP14|GFPT1|GOSR2|GSK3A|HDGF|HERPUD1|HERPUD2|HSP90AA1|HSP90AB1|HSP90B1|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA8|HSPB1|HSPB2|HSPB3|HSPB7|HSPD1|HSPE1|HSPH1|HYOU1|IFNG|IGFBP1|JKAMP|KDELR3|KLHDC3|LMNA|MANF|MBTPS1|MBTPS2|MFN2|MYDGF|NFE2L2|PACRG|PARK2|PARP16|PDIA5|PDIA6|PLA2G4B|PPP1R15A|PPP2R5B|PREB|PTPN1|RHBDD1|RNF121|RNF175|SEC31A|SEC61A1|SEC61A2|SEC61B|SEC61G|SEC62|SEC63|SELENOS|SERP1|SERP2|SERPINH1|SHC1|SRPRA|SRPRB|SSR1|STC2|STT3B|STUB1|SULT1A3|SYVN1|TATDN2|TBL2|THBS1|THBS4|TLN1|TMBIM6|TMEM129|TOR1B|TPP1|TSPYL2|UBE2J2|UBXN4|UGGT1|UGGT2|VAPB|VCP|WFS1|WIPI1|XBP1|YIF1A|YOD1|ZBTB17|                                                                                         |
| protein stabilization                       | <GO:0050821> |        128|       128|        19|     0|                0|         0|                  0|               0.946| NA      | A1CF|AAK1|AHSP|ANK2|APOA1|ATP1B1|ATP1B2|ATP1B3|BAG3|BAG6|CALR|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT7|CCT8|CDC37|CDC37L1|CDKN1A|CHEK2|CHP1|CLU|COG3|COG7|CPN2|CREB1|CREBL2|CRTAP|CSN3|DNLZ|DSG1|DVL1|DVL3|EP300|FBXW7|FKBPL|FLNA|FLOT2|GAPDH|GNAQ|GOLGA7|GPIHBP1|GTPBP4|GTSE1|HCFC1|HIST1H1B|HPS4|HSP90AA1|HSP90AB1|HSPA1A|HSPA1B|HSPD1|IFI30|IFT46|IGF1|LAMP1|LAMP2|MDM4|MORC3|MSX1|MT3|MUL1|NAA15|NAA16|NAPG|NLK|P3H1|PARK2|PARK7|PDCD10|PER3|PEX19|PEX6|PFN1|PFN2|PHB|PHB2|PIK3R1|PIM2|PIN1|PINK1|PLPP3|PPARGC1A|PPIB|PRKCD|PTEN|RASSF2|SAV1|SEL1L|SMAD3|SMAD7|SMO|SOX17|SOX4|STK3|STK4|STX12|STXBP1|STXBP4|SUMO1|SWSAP1|SYVN1|TAF9|TAF9B|TBRG1|TCP1|TELO2|TESC|TMEM88|TNIP2|TSC1|TSPAN1|UBE2B|USP13|USP19|USP2|USP27X|USP33|USP7|VHL|WFS1|WIZ|WNT10B|ZBED3|ZNF207|ZSWIM7|                                                                                                                                                                                                                                                                                                                         |
| heat shock protein binding                  | <GO:0031072> |         82|        82|        15|     0|                0|         0|                  0|               0.804| NA      | ADORA1|AHR|APAF1|ARNTL|BAG6|BAK1|BCOR|CDC37|CDC37L1|CDK1|CDKN1B|CHORDC1|CREB1|CSNK2A1|DAXX|DMPK|DNAJA1|DNAJA2|DNAJA3|DNAJA4|DNAJB1|DNAJB6|DNAJC10|DNAJC2|DNAJC7|DNAJC9|EIF2AK3|ERN1|FAF1|FGF1|FKBP4|FKBP5|FKBP6|GBP1|GPR37|GRXCR2|HDAC2|HDAC6|HDAC8|HIF1A|HIKESHI|HSF1|HSPA1A|HSPA1B|HSPA1L|HSPA6|HSPA8|IQCG|IRAK1|KCNJ11|KDR|KPNB1|LIMK1|LMAN2|METTL21A|MVD|NASP|NFKBIA|NOD2|NPAS2|NUP62|OGDH|PACRG|PARK2|PDXP|PPEF2|PPID|PPP5C|RNF207|RPS3|SACS|ST13|STIP1|STUB1|TELO2|TFAM|TOMM34|TPR|UNC45A|UNC45B|USP19|ZFP36|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |

We can see <GO:0051082> is the top scoring hit as expected.
