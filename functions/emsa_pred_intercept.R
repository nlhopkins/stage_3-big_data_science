emsa_pred_intercept <- function(x) {
    if (emsa$rf[1] > 0) {
        ((summary(NLS(emsa))$coefficients[1, 1]) * x) / ((summary(NLS(emsa))$coefficients[2, 1])  + x) + (summary(NLS(emsa))$coefficients[3, 1])
    } else{
        ((summary(NLS(emsa))$coefficients[1, 1]) * x) / ((summary(NLS(emsa))$coefficients[2, 1]))
    }
}
