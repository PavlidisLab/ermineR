
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

head(oraOut$results) %>% knitr::kable()
```

| Name                                        | ID           |  NumProbes|  NumGenes|  RawScore|  Pval|  CorrectedPvalue|  MFPvalue|  CorrectedMFPvalue|  Multifunctionality| Same as | GeneMembers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|:--------------------------------------------|:-------------|----------:|---------:|---------:|-----:|----------------:|---------:|------------------:|-------------------:|:--------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unfolded protein binding                    | <GO:0051082> |        123|       123|       114|     0|                0|         0|                  0|               0.641| NA      | AAMP|AFG3L2|AHSP|AIP|AIPL1|APCS|BBS12|CALR|CALR3|CANX|CCDC115|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CDC37|CDC37L1|CHAF1A|CHAF1B|CLGN|CLN3|CLPX|CRYAA|CRYAB|DNAJA1|DNAJA2|DNAJA3|DNAJA4|DNAJB1|DNAJB11|DNAJB13|DNAJB2|DNAJB4|DNAJB5|DNAJB6|DNAJB8|DNAJC4|DZIP3|ERLEC1|ERO1B|FYCO1|GRPEL1|GRPEL2|HEATR3|HSP90AA1|HSP90AA2P|HSP90AA4P|HSP90AA5P|HSP90AB1|HSP90AB2P|HSP90AB3P|HSP90AB4P|HSP90B1|HSP90B2P|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPB6|HSPD1|HSPE1|HSPH1|HTRA2|HYOU1|LMAN1|MDN1|MKKS|NAP1L4|NDUFAF1|NPM1|NUDC|NUDCD2|NUDCD3|NWD2|PDRG1|PET100|PFDN1|PFDN2|PFDN4|PFDN5|PFDN6|PIKFYVE|PPIA|PPIB|PTGES3|RP2|RUVBL2|SCAP|SCG5|SERPINH1|SHQ1|SIL1|SPG7|SRSF10|SRSF12|ST13|SYVN1|TAPBP|TCP1|TMEM67|TOMM20|TOR1A|TRAP1|TTC1|TUBB4B|UGGT1|UGGT2|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                          |
| chaperone-mediated protein folding          | <GO:0061077> |         81|        81|        37|     0|                0|         0|                  0|               0.679| NA      | BAG1|BBS12|CALR|CANX|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CHORDC1|CLU|CRTAP|CSNK2A1|DFFA|DNAJB1|DNAJB12|DNAJB14|DNAJB2|DNAJB8|DNAJC24|DNAJC7|ERO1A|FKBP10|FKBP11|FKBP14|FKBP1A|FKBP1B|FKBP2|FKBP3|FKBP4|FKBP5|FKBP6|FKBP7|FKBP8|FKBP9|FYCO1|GAK|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPB1|HSPB6|HSPD1|HSPE1|HSPH1|HYOU1|MKKS|P3H1|PDIA4|PEX19|PIKFYVE|PPIB|PPID|PTGES3|ST13|ST13P4|ST13P5|TCP1|TOR1A|TOR1B|TOR2A|TRAP1|UNC45A|UNC45B|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| protein binding involved in protein folding | <GO:0044183> |         43|        43|        31|     0|                0|         0|                  0|               0.641| NA      | BBS12|CALR|CALR3|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CLGN|DFFA|DNAJB8|FYCO1|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPB1|HSPD1|HSPH1|HYOU1|MKKS|PDCL3|PFDN1|PFDN2|PIKFYVE|RIC3|TCP1|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| 'de novo' protein folding                   | <GO:0006458> |         54|        54|        31|     0|                0|         0|                  0|               0.707| NA      | BAG1|BBS12|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CHCHD4|DNAJB1|DNAJB12|DNAJB14|DNAJC2|DNAJC7|ENTPD5|ERO1A|FKBP1A|FKBP1B|FYCO1|GAK|HSPA13|HSPA14|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA7|HSPA8|HSPA9|HSPD1|HSPE1|HSPH1|HYOU1|MKKS|PIKFYVE|PTGES3|SELENOF|ST13|TCP1|TOR1A|TOR1B|TOR2A|UGGT1|UGGT2|ZFYVE21|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
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
    ##  [1] "GO:0002576" "GO:0008150" "GO:0043312" "GO:0005576" "GO:0005576"
    ##  [6] "GO:0005615" "GO:0031012" "GO:0031093" "GO:0034774" "GO:0070062"
    ## [11] "GO:0072562" "GO:1904813" "GO:0003674"
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
    ## [1] "GO:0006805" "GO:0005829" "GO:0004060" "GO:0005515"
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

head(oraOut$results) %>% knitr::kable()
```

| Name                                        | ID           |  NumProbes|  NumGenes|  RawScore|  Pval|  CorrectedPvalue|  MFPvalue|  CorrectedMFPvalue|  Multifunctionality| Same as | GeneMembers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|:--------------------------------------------|:-------------|----------:|---------:|---------:|-----:|----------------:|---------:|------------------:|-------------------:|:--------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unfolded protein binding                    | <GO:0051082> |        113|       113|       113|     0|                0|         0|                  0|               0.644| NA      | AAMP|AFG3L2|AHSP|AIP|AIPL1|APCS|BBS12|CALR|CALR3|CANX|CCDC115|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CDC37|CDC37L1|CHAF1A|CHAF1B|CLGN|CLN3|CLPX|CRYAA|CRYAB|DNAJA1|DNAJA2|DNAJA3|DNAJA4|DNAJB1|DNAJB11|DNAJB13|DNAJB2|DNAJB4|DNAJB5|DNAJB6|DNAJB8|DNAJC4|DZIP3|ERLEC1|ERO1B|FYCO1|GRPEL1|GRPEL2|HEATR3|HSP90AA1|HSP90AA2P|HSP90AA4P|HSP90AA5P|HSP90AB1|HSP90AB2P|HSP90AB3P|HSP90AB4P|HSP90B1|HSP90B2P|HSPA1A|HSPA1B|HSPA1L|HSPA2|HSPA5|HSPA6|HSPA8|HSPA9|HSPB6|HSPD1|HSPE1|HTRA2|LMAN1|MDN1|MKKS|NAP1L4|NDUFAF1|NPM1|NUDC|NUDCD2|NUDCD3|PDRG1|PET100|PFDN1|PFDN2|PFDN4|PFDN5|PFDN6|PPIA|PPIB|PTGES3|RP2|RUVBL2|SCAP|SCG5|SERPINH1|SHQ1|SIL1|SPG7|SRSF10|SRSF12|ST13|SYVN1|TAPBP|TCP1|TMEM67|TOMM20|TOR1A|TRAP1|TTC1|TUBB4B|UGGT1|UGGT2|                                                                                                                                                                                                                                                                                                                                                                                                                            |
| protein binding involved in protein folding | <GO:0044183> |         28|        28|        23|     0|                0|         0|                  0|               0.543| NA      | BBS12|CALR|CALR3|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CLGN|DFFA|DNAJB8|FYCO1|HSPA1A|HSPA1B|HSPB1|HSPD1|MKKS|PDCL3|PFDN1|PFDN2|RIC3|TCP1|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| chaperone-mediated protein folding          | <GO:0061077> |         60|        60|        26|     0|                0|         0|                  0|               0.674| NA      | BBS12|CALR|CANX|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CHORDC1|CLU|CRTAP|CSNK2A1|DFFA|DNAJB1|DNAJB12|DNAJB14|DNAJB2|DNAJB8|DNAJC24|ERO1A|FKBP10|FKBP11|FKBP14|FKBP1A|FKBP1B|FKBP2|FKBP3|FKBP4|FKBP5|FKBP6|FKBP7|FKBP8|FKBP9|FYCO1|GAK|HSPA8|HSPB1|HSPB6|HSPD1|HSPE1|HSPH1|MKKS|P3H1|PDIA4|PEX19|PPIB|PPID|TCP1|TOR1A|TOR1B|TOR2A|TRAP1|UNC45A|UNC45B|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| 'de novo' protein folding                   | <GO:0006458> |         36|        36|        21|     0|                0|         0|                  0|               0.661| NA      | BBS12|CCT2|CCT3|CCT4|CCT5|CCT6A|CCT6B|CCT7|CCT8|CCT8L1P|CCT8L2|CD74|CHCHD4|DNAJB1|DNAJB12|DNAJB14|DNAJC2|ENTPD5|ERO1A|FKBP1A|FKBP1B|FYCO1|GAK|HSPA14|HSPA8|HSPD1|HSPE1|HSPH1|MKKS|SELENOF|TCP1|TOR1A|TOR1B|TOR2A|UGGT1|UGGT2|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| chaperone binding                           | <GO:0051087> |         89|        89|        22|     0|                0|         0|                  0|               0.765| NA      | AHSA1|AHSA2|ALB|AMFR|ATP1A1|ATP1A2|ATP1A3|ATP7A|BAG1|BAG2|BAG3|BAG4|BAG5|BAK1|BAX|BIRC2|BIRC5|CALR|CDC25A|CDC37|CDC37L1|CDKN1B|CLU|CP|CTSC|DNAJA1|DNAJA2|DNAJA4|DNAJB1|DNAJB2|DNAJB4|DNAJB5|DNAJB6|DNAJB7|DNAJB8|DNAJC1|DNAJC10|DNAJC3|DNLZ|ERP29|FGB|FN1|FNIP1|FNIP2|GAK|GET4|GNB5|GRPEL1|GRPEL2|HES1|HSCB|HSPA5|HSPB6|HSPD1|HSPE1|HYOU1|LRP2|OGDH|PACRG|PDPN|PFDN4|PFDN6|PIH1D3|PLG|PRKN|PRNP|RNF207|SACS|SDF2L1|SLC25A17|SOD1|ST13|STIP1|SYVN1|TBCA|TBCC|TBCD|TBCE|TERT|TIMM10|TIMM44|TIMM9|TP53|TSACC|TSC1|UBL4A|USP13|VWF|WRAP53|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| response to topologically incorrect protein | <GO:0035966> |        179|       179|        25|     0|                0|         0|                  0|               0.907| NA      | ACADVL|ADD1|AMFR|ANKZF1|ARFGAP1|ASNA1|ASNS|ATF3|ATF4|ATF6|ATF6B|ATP6V0D1|ATXN3|ATXN3L|BAG6|BHLHA15|CALR|CASP12|CCL2|CCND1|CDK5RAP3|CHAC1|CLU|CREB3|CREB3L1|CREB3L2|CREB3L3|CREB3L4|CREBRF|CTDSP2|CTH|CUL3|CUL7|CXCL8|CXXC1|DAXX|DCTN1|DDIT3|DDX11|DERL1|DERL2|DERL3|DNAJA1|DNAJB1|DNAJB11|DNAJB12|DNAJB2|DNAJB4|DNAJB5|DNAJB9|DNAJC3|DNAJC4|DZIP3|EDEM1|EDEM2|EDEM3|EIF2AK2|EIF2AK3|EIF2S1|EP300|ERN1|ERO1A|ERP44|EXTL1|EXTL2|EXTL3|F12|FAF2|FBXO6|FGF21|FKBP14|GFPT1|GOSR2|GSK3A|HDAC6|HDGF|HERPUD1|HERPUD2|HSF1|HSP90AA1|HSP90AB1|HSP90B1|HSPA1A|HSPA1L|HSPA2|HSPA4|HSPA4L|HSPA5|HSPA6|HSPA8|HSPB1|HSPB2|HSPB3|HSPB7|HSPD1|HSPE1|HSPH1|HYOU1|IFNG|IGFBP1|JKAMP|KDELR3|KLHDC3|KLHL15|LMNA|MANF|MBTPS1|MBTPS2|MFN2|MMP24-AS1-EDEM2|MYDGF|NFE2L2|OPTN|PACRG|PARP16|PDIA5|PDIA6|PLA2G4B|POMT1|POMT2|PPP1R15A|PPP2R5B|PREB|PRKN|PTPN1|RHBDD1|RNF121|RNF126|RNF175|RNF185|RNF5|SDF2|SDF2L1|SEC31A|SEC61A1|SEC61A2|SEC61B|SEC61G|SEC62|SEC63|SELENOS|SERP1|SERP2|SERPINH1|SHC1|SRPRA|SRPRB|SSR1|STC2|STT3B|STUB1|SULT1A3|SYVN1|TATDN2|TBL2|THBS1|THBS4|TLN1|TM7SF3|TMBIM6|TMEM129|TOR1A|TOR1B|TPP1|TSPYL2|UBE2J2|UBE2W|UBXN4|UFD1|UGGT1|UGGT2|VAPB|VCP|WFS1|WIPI1|XBP1|YIF1A|YOD1|ZBTB17| |

We can see <GO:0051082> is the top scoring hit as expected.
