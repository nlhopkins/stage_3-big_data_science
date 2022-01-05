pred_intercept_emsa <- function(x) {
    if (emsa$rf[1] > 0) {
        (emsa_rf * x) / (emsa_intercept  + x) + (summary(emsa_fit)$coefficients[3, 1])
    } else{
        (emsa_rf * x) / (emsa_intercept  + x)
    }
}
