sec_pred_intercept <- function(x) {
    (linear_reg$coefficients[1]) + (linear_reg$coefficients[2] * x)
}
