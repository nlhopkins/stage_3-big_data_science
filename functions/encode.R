encode <- function(x, y) {
    readBin(x, y, file.info(x)$size) %>%
        openssl::base64_encode()
}
