sec_mw <-
    function(x) {
        exp((
            sec_elution(x) - lm(sec_standards$vol ~ sec_standards$logmw)$coefficients[1]
        ) / lm(sec_standards$vol ~ sec_standards$logmw)$coefficients[2]
        )
    }
