sec_mw <-
    function(x) {
        exp((
            (sec %>%
                 group_by(protein) %>%
                 filter(absorbance == max(absorbance)))$vol[(sec %>%
                                                                 group_by(protein) %>%
                                                                 filter(absorbance == max(absorbance)))$protein == x] - lm(sec_standards$vol ~ sec_standards$logmw)$coefficients[1]
        ) / lm(sec_standards$vol ~ sec_standards$logmw)$coefficients[2]
        )
    }
