[![Licence](https://img.shields.io/badge/Licence-CC-green)](http://creativecommons.org/licenses/by-nc-sa/4.0/)
[![Version](https://img.shields.io/badge/R-4.1.2-blue)](https://www.r-project.org/)

---
title: Characterisation of a Putative Agent of Horizontal Gene Transfer Encoded by a Bacterial Prophage Region
---
# Overview
This project was completed as a requirement for the University of York, Department of Biology, M-level module: Data Science option of BIO00058M Data Analysis. The project tidies, processes, and analyses data obtained from University of York, Department of Biology, C-level module: Bioscience Techniques strand of BIO00058I Laboratory and Professional Skills for Bioscientists II.

# Requirements
- R version 4.1.2 or higher\
- RStudio
- The output of `sessionInfo()` can be found in [Session Information](session_info.md).
- CRAN packages: `tidyverse`, `plotly`, `ggpubr`, `RefManageR`, `kableExtra`, `showtext`, `devtools`.
- Github package: `wordcountaddin`. 
- Required packages can be downloaded using the following code:
```
# Required Packages
cran_packages <- c("tidyverse", "plotly", "ggpubr", "RefManageR", "kableExtra", "showtext", "devtools", "wordcountaddin")

# Extract not installed packages
not_installed <- cran_packages[!(cran_packages %in% installed.packages()[ , "Package"])]

# Install not installed packages from CRAN
if(length(not_installed!="wordcountaddin"))install.packages(not_installed!="wordcountaddin") 

# Install not installed packages from Github
if(length(not_installed=="wordcountaddin"))devtools::install_github("benmarwick/wordcountaddin", type = "source", dependencies = TRUE)
```

# Issues
* If on Mac, you will need to download the *Montserrat* font to use alternative fonts `showtext` functions. [This](https://babichmorrowc.github.io/post/2019-10-11-google-fonts/) article explains how to do this.
* Some plots are not interactive due to `plotly` being incompatible with `ggplot2`'s stat functions.

# Materials
[![Alt text](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

'Characterisation of a Putative Agent of Horizontal Gene Transfer Encoded by a Bacterial Prophage Region' by Y3877831 is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).
