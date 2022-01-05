pred_intercept_emsa <- function(x) {
    (emsa_rf * x) / (emsa_intercept  + x)
}
