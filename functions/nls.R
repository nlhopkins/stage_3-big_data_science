# Perform the NLS using the Langmuir binding isotherm
# Depending on how you have calculated Rf you may need to include a y-intercept in your fit.
# For example, if the Rf at 0 uM doesn't equal 0,
# This code will use 2-parameter fit if Rf at 0uM is 0, and 3 parameter fit if it doesnt equal 00

NLS <- function(x) {
    emsa_fit <-
        if (x$rf[1] != 0) {
            nls(rf ~ (a * conc) / (b + conc) + c,
                data = x,
                start = list(a = 1, b = 1, c = 0))
        } else{
            nls(rf ~ (a * conc) / (b + conc),
                data = x,
                start = list(a = 1, b = 1))
        }
}
