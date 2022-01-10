sec_elution <-
    function(x) {(sec %>%
    group_by(protein) %>%
    filter(absorbance == max(absorbance)))$vol[(sec %>%
                                                    group_by(protein) %>%
                                                    filter(absorbance == max(absorbance)))$protein == x]}
