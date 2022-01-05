# Separate the PCR data set by DNA library for analysis
gdna <- pcr %>% # gDNA PCR data
    filter(library == "gDNA")

cdna <- pcr %>% # cDNA
    filter(library == "cDNA")

## ----✷----✷---- gDNA ----✷----✷----

#lm
gdna_mod <- lm(data = gdna_calibration, log ~ rf)

plot(gdna_mod, which = 1)



logarithm <- function(v, x){
    (v$rf * x$coefficients[2]) + x$coefficients[1]
}


#data
gdna <- gdna %>%
    mutate(
        rf = ((gel_length - distance) / gel_length),
        log = ((rf * gdna_mod$coefficients[2]) + gdna_mod$coefficients[1]),
        actual_size = (10 ^ log),
        diff = ((expected_size - actual_size) / expected_size * 100)
    )

## ----✷----✷---- cDNA ----✷----✷----
#lm
cdna_mod <- lm(data = cdna_calibration, log ~ rf)

plot(cdna_mod, which = 1)

cdna <- cdna %>%
    mutate(
        rf = ((gel_length - distance) / gel_length),
        log = ((rf * cdna_mod$coefficients[2]) + cdna_mod$coefficients[1]),
        actual_size = (10 ^ log),
        diff = ((expected_size - actual_size) / expected_size * 100)
    )

## ----✷----✷---- plot ----✷----✷----

pcr_full <- full_join(gdna, cdna, by = NULL) %>%
    rename(Gene = gene,
           Difference = diff,
           Library = library)

pcr_plot <- pcr_full %>%
    ggplot(aes(
        x = Gene,
        y = Difference,
        fill = Library,
        text = paste(
            "Expected Size (bp): ",
            expected_size,
            "<br>Actual Size (bp):",
            round(actual_size)
        )
    )) + geom_col(position = "dodge") +
    geom_hline(yintercept = 0, size = 0.25) +
    mytheme() +
    scale_fill_brewer(name = "DNA Library",
                      labels = c("cDNA", "gDNA"),
                      palette = "Set3",) +
    labs(y = "Percentage Difference to Expected Size", x = "Gene")

pcr_interactive <- pcr_plot %>%
    ggplotly()
