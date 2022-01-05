pred_intercept_sec <- function(x) {
    (linear_reg$coefficients[1]) + (linear_reg$coefficients[2] * x)
}
