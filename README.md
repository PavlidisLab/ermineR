
ErmineR
=======

[![Build Status](https://travis-ci.org/PavlidisLab/ermineR.svg?branch=master)](https://travis-ci.org/PavlidisLab/ermineR) [![codecov](https://codecov.io/gh/PavlidisLab/ermineR/branch/master/graph/badge.svg)](https://codecov.io/gh/PavlidisLab/ermineR) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/PavlidisLab/ermineR?branch=master&svg=true)](https://ci.appveyor.com/project/PavlidisLab/ermineR)

This is an R wrapper for Pavlidis Lab's [ermineJ](http://erminej.msl.ubc.ca/). A tool for gene set enrichment analysis with multifunctionality correction.

Usage
-----

See documentation for `ora`, `roc`, `gsr`, `precRecall` and `corr` to see how to use them.

Explanation of what each method does is explained

### Replicable go terms

Go terms are updated frequently so results can differ between versions. The default option of all ermineR functions is to get the latest GO version however this means you may get different results when you repeat the experiment later. If you want to use a specific version of GO, ermineR provides functions to deal with that.

-   `goToday`: Downloads the latest version of go to a path you provide
-   `getGoDates`: Lists all dates where a go version is available, from the most recent to oldest
-   `goAtDate`: Given a valid date, downloads the Go version from a specific date to a file path you provide

To use a specific version of GO, make sure to set `geneSetDescription` argument of all ermineR functions to the file path where you saved the go terms

### Examples

#### Use ORA with a hitlist

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

head(oraOut$results)
```

    ## # A tibble: 6 x 12
    ##   Name   ID    NumProbes NumGenes RawScore         Pval    CorrectedPvalue
    ##   <chr>  <chr>     <int>    <int>    <dbl>        <dbl>              <dbl>
    ## 1 unfol… GO:0…       115      115    115      2.29e⁻³⁰³          9.50e⁻³⁰⁰
    ## 2 prote… GO:0…        29       29     25.0    7.47e⁻ ⁵³          1.55e⁻ ⁴⁹
    ## 3 chape… GO:0…        59       59     28.0    1.67e⁻ ⁴⁷          2.31e⁻ ⁴⁴
    ## 4 'de n… GO:0…        35       35     22.0    3.72e⁻ ⁴¹          3.86e⁻ ³⁸
    ## 5 chape… GO:0…        85       85     22.0    2.51e⁻ ³⁰          2.08e⁻ ²⁷
    ## 6 respo… GO:0…       173      173     22.0    4.95e⁻ ²³          3.42e⁻ ²⁰
    ## # ... with 5 more variables: MFPvalue <dbl>, CorrectedMFPvalue <dbl>,
    ## #   Multifunctionality <dbl>, `Same as` <chr>, GeneMembers <chr>
