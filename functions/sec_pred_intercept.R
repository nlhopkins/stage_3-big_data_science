sec_pred_intercept <- function(x) {
    (lm(sec_standards$vol ~ sec_standards$logmw)$coefficients[1]) + (lm(sec_standards$vol ~ sec_standards$logmw)$coefficients[2] * x)
}
