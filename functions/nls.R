NLS <- function(x){emsa_fit <-
    if (x$rf[1] > 0) {
        nls(rf ~ (a * primer) / (b + primer) + c, data = x, start = list(a = 1, b = 1, c = 0))
    } else{
        nls(rf ~ (a * primer) / (b + primer), data = x, start = list(a = 1, b = 1))
    }}
