#structure
str(emsa_calibration)

#lm
emsa_mod <- lm(data = emsa_calibration, log ~ rf)

plot(emsa_mod, which = 1)

#plot

emsa_calibration_plot <- emsa_calibration %>%
    ggplot(aes(x = rf, y = log)) +
    geom_point(shape = 18,
               size = 2,
               colour = "#D23681") +
    ggtitle("Calibration Plot for EMSA Migration") +
    scale_x_continuous(
        expand = c(0.02, 0.02),
        breaks = seq(0, 1, by = 0.05),
        name = expression(paste("R"["f"]))
    ) +
    scale_y_continuous(
        expand = c(0, 0.2),
        breaks = seq(5.4, 7, by = 0.2),
        name = "log(DNA Molecular Weight in bp)"
    ) +
    geom_smooth(
        method = lm,
        formula = y ~ x,
        se = FALSE,
        colour = "#29a198",
        linetype = 2,
        size = 0.5
    ) +
    mytheme()

## ----✷----✷---- analysis of EMSa DNa binding data for Im9-HiGam.R ----✷----✷----
# This script will analyse EMSa data to determine a macroscopy binding affinity and and generate a figure
# molecular weight standards to estimate the molecular weight of HiGam


## Read in Data
## read in x and y data (separately in this case; there are other ways to do this too)
# IMPORTaNT: THIS IS JUST EXaMPLE DaTa. You will need to use your own values.

emsa

## NOTE: depending on how you have calculated your rf values, you may need to adjust them.
# If your rf values are largest for lower protein concentration and get smaller as the
# protein concentration increases, e.g.
# rf<-c(1.0,0.7,0.5,0.4,0.4,0.4,0.4)
# then you'll need to do the following:
# rf = 1 - rf
# You can then make the data.frame as above


# Plot --------------------------------------------------------------------

# Perform the NLS using the Langmuir binding isotherm

emsa_fit <-
    if (emsa$rf[1] > 0) {
        nls(rf ~ (a * conc) / (b + conc) + c, data = emsa, start = list(a = 1, b = 1, c = 0))
    } else{
        nls(rf ~ (a * conc) / (b + conc), data = emsa, start = list(a = 1, b = 1))
    }

# NOTE 2: Depending on how you have calculated rf you may need to include a y-intercept in your fit.
# For example, if the rf at 0 uM doesn't equal 0, e.g. rf <- c(0.3,0.55,0.6,0.65,0.67,0.67,0.67)
# then you may need to include an intercept. Note that this would now perform a 3-parameter fit
# To do this: emsa_fit <- nls(rf ~ (a *conc)/(b+conc) + C, start = list(a = 1, b = 1, C = 0))
# also note that a 3-parameter fit of the data always looks better than a 2-parameter fit.
# You have to be able to justify why you have chose 3 over 2 parameters.

# look at the summary of the fit calculation
summary(emsa_fit)

# Extract the predictions of rf_max and Kd
rf_max = summary(emsa_fit)$coefficients[1, 1]

kd = summary(emsa_fit)$coefficients[2, 1]

# You'll need to extract the prediction of the intercept if used
#intercept = summary(emsa_fit)$coefficients[,1] ; intercept

# Define a function based on your predicted values from the fit
pred_intercept <- function(x)
    (rf_max * x) / (kd + x)

# alternatively, including an intercept:
# pred_intercept <- function(x) (rf_max * x)/(Kd + x) + intercept

# add the line of best fit to the plot
emsa_plot <- emsa %>%
    ggplot(aes(x = conc, y = rf)) +
    geom_point(shape = 20,
               size = 3,
               colour = "black") +
    stat_function(fun = pred_intercept, colour = "#66C2A4") +
    mytheme() +
    scale_y_continuous(limits = c(0, 0.6),
                       breaks = seq(0, 7, by = 0.15)) +
    scale_x_continuous(
        expand = c(0.02, 0.02),
        limits = c(0, 8),
        breaks = seq(0, 8, by = 1)
    ) +
    xlab(NULL) +
    ylab(expression(paste(bold(
        "Relative Front (a.U.)"
    ))))

# Calculate the difference between the measured rf and predicted rf value
# This is needed for the residuals
emsa_pred <- predict(emsa_fit)

# Calculate residuals to the fit
emsa_res <- emsa %>%
    mutate(residuals = rf - emsa_pred)

# Plot the residuals and a line showing y = 0
emsa_res_plot <- emsa_res %>%
    ggplot(aes(x = conc, y = residuals)) +
    geom_point(shape = 20,
               size = 3,
               colour = "black") +
    geom_hline(aes(yintercept = 0),
               col = '#66C2A4',
               size = .5) +
    scale_x_continuous(
        expand = c(0.02, 0.02),
        limits = c(0, 8),
        breaks = seq(0, 8, by = 1),
        name = (expression(bold(
            atop("Protein Concentration (μM)", "Im9"["dimer"])
        )))
    ) +
    scale_y_continuous(
        expand = c(0.01, 0.01),
        limits = c(-0.10, 0.10),
        breaks = seq(-0.10, 0.10, by = 0.1),
        name = "Residual (a.U.)"
    ) + mytheme()

ga <- ggplotGrob(emsa_plot)
gb <- ggplotGrob(emsa_res_plot)

emsa_grid_plot <-
    grid.arrange(ga, gb, nrow = 2, heights = c(1, 1 / 2))

