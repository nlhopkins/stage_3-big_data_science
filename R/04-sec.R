# this calls in the main standard data and defines the x axis -----------

standards_plot <- standards %>%
    ggplot() +
    geom_line(aes(x = vol,
                  y = time,
                  colour = protein),
              show.legend = TRUE) +
    scale_colour_brewer(
        name = "Protein",
        labels = c(
            "Ferritin",
            "IgG",
            "Myoglobin",
            "Ovalbumin",
            "Thyroglobulin",
            "Transferrin",
            "Vitamin B12"
        ),
        palette = "Set2"
    ) + # colour blind friendly
    mytheme() +
    theme(plot.margin = unit(c(1, 1, 1, 1), "cm")) +
    scale_x_continuous(
        expand = c(0, 0),
        limits = c(9, 22),
        breaks = seq(9, 22, by = 1),
        name = "Elution Volume (mL)"
    ) + scale_y_continuous(
        expand = c(0, 0),
        limits = c(0, 100),
        breaks = seq(0, 100, by = 10),
        name = "A280 (A.U.)"
    )

#Analysing the SEC profile of the MW standards ---------------------------

# Getting the elution volume that corresponds to the maximum value of a curve

# the "2" is the column with volumes - Do you know a better way?

#Which max returns the max (elution vol) number in column 2 (tells us the line number)

# linking the elution volumes and molecular weights in a data.frame

mw_ev <- standards %>%
    group_by(protein) %>%
    filter(time == max(time)) %>%
    summarise(vol) %>%
    ungroup() %>%
    mutate(
        mw = recode(
            protein,
            curve_thyroglobulin = 669000,
            curve_ferritin = 440000,
            curve_ig_g = 150000,
            curve_transferrin = 81000,
            curve_ovalbumin = 43000,
            curve_myoglobin = 17000,
            curve_vitamin_b12 = 1355
        ),
        logmw = log(mw)
    )

# Plotting the data for the calibration -----------------------------------
# The relationship you need is elution volume = f(log(MW))
# Perform the linear regression and collect the output values slope and intercept
# note that this uses vol and logMW data
linear_reg <- lm(mw_ev$vol ~ mw_ev$logmw)
intercept <- linear_reg$coefficients[1] # intercept value
slope <- linear_reg$coefficients[2] # slope value

# Plotting a line of best fit - need to define a function
fun.1 <- function(x)
    intercept + (slope * x)

# Add this function to your plot using stat_function
calibration.plot <- mw_ev %>%
    ggplot(mapping = aes(y = vol, x = logmw)) +
    geom_point() +
    mytheme() +
    theme(plot.margin = unit(c(1, 1, 1, 1), "cm")) +
    scale_x_continuous(
        expand = c(0.05, 0.05),
        limits = c(7, 14),
        breaks = seq(7, 14, by = 1),
        name = "log (MW)"
    ) + scale_y_continuous(
        expand = c(0.05, 0.05),
        limits = c(9, 22),
        breaks = seq(9, 22, by = 2),
        name = "Elution Volume (mL)"
    ) +
    stat_function(fun = fun.1,
                  geom = "line",
                  colour = "#8D9FCA")

## ----✷----✷---- lm9 sec sec ----✷----✷----
# Importing the higam SEC data --------------------------------------------
# please read the CSV file this way rather than by "Import dataset"


# Plotting the sec SEC data ---------------------------------------------
sec.plot <- sec %>%
    ggplot() +
    geom_line(aes(x = vol, y = time, colour = protein), show.legend = TRUE) +
    scale_colour_brewer(name = "Protein",
                        labels = c("a280", "a254"),
                        palette = "Set2") +
    scale_x_continuous(limits = c(13, 17)) +
    mytheme() +
    xlab("Elution Volume (mL)") +
    ylab("Absorbance (mAU)")

#### Using the calibration data to estimate the MW of sec ####
# Getting the elution volume that corresponds to the maximum value of a curve

volgam <- sec %>%
    group_by(protein) %>%
    filter(vol == max(vol))

# Estimated MW from the 280 nm data
a280_mw <- exp((volgam$time[1] - intercept) / slope)

# Estimated MW from the 254 nm data
a254_mw <- exp((volgam$time[2] - intercept) / slope)
