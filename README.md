[![Licence](https://img.shields.io/badge/Licence-CC-green)](http://creativecommons.org/licenses/by-nc-sa/4.0/)
[![Version](https://img.shields.io/badge/R-4.1.2-blue)](https://www.r-project.org/)

---
title: Characterisation of a Putative Agent of Horizontal Gene Transfer Encoded by a Bacterial Prophage Region
author: Y3877831
---

## Description, 50 words or so on what the project is

## Technical Description of the project



## Software & Packages

- R version 4.1.2 or higher\

The following code can be pasted in the console to download required packages:\

``` {r}
# Required Packages
cran_packages <- c("tidyverse", "plotly", "ggpubr", "RefManageR", "kableExtra", "showtext", "devtools", "wordcountaddin")

# Extract not installed packages
not_installed <- cran_packages[!(cran_packages %in% installed.packages()[ , "Package"])]

# Install not installed packages
if(length(not_installed!="wordcountaddin")) install.packages(not_installed!="wordcountaddin") 

if(length(not_installed=="wordcountaddin")) devtools::install_github("benmarwick/wordcountaddin", type = "source", dependencies = TRUE)
```

The output of `sessionInfo()` can be found in [Session Information](session_info.md).

## Issues
* If on Mac, you will need to download the Montserrat font for the `showtext` functions. [This](https://babichmorrowc.github.io/post/2019-10-11-google-fonts/) article explains how to do this.
* Some plots are not interactive due to `plotly` being incompatible with `ggplot2`'s stat functions.

-----------------------------------------------------------------------
[![Alt text](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

'Characterisation of a Putative Agent of Horizontal Gene Transfer Encoded by a Bacterial Prophage Region' is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).
