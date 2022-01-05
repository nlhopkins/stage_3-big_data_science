# BIO00058I - Feb 2021 - Dr Michael Plevin
# This script will read in and process seAUC data and generate a figure

auc <- read.csv("data/data-raw/seauc.csv") %>%
  janitor::clean_names()

# plotting the basic functions for single species and two species in exchange

# initial parameters
vbar = 0.73 # partial specific volume, mL g-1
rho = 1.005 # density of buffer, g mL-1

# initial r value
r0 = 6.8 # cm

# different rotor speeds
rpm = 12000
omega = ((2 * pi) / 60) * rpm # rad s-1
omega_sq = omega ^ 2 # rad s-2

temp = 298 # K
rgas = 8.3144598 * 10 ^ 7 # erg K−1 mol−1 where erg = g cm2 s-2
two_rt = 2 * temp * rgas # g cm2 s-2 mol-1

# plotting the data
auc_plot <-
  ggplot(data = auc, aes(x = r, y = a280)) + geom_point(shape = 1,
                                                        size = 3,
                                                        colour = "darkgrey") + mytheme() +
  labs(y = "a280 (A.U.)") + coord_cartesian(xlim = c(6.8, 7.2), ylim = c(0, 1))
auc_plot # entering this term generates a plot

# make r and a280 data for the nonlinear analysis
r <- c(auc$r)
a280 <- c(auc$a280)


#### Analysing the AUC data using the nls() function ####

# nonlinear analysis - this modifies the parameters a0 and Mb so to optimise the function to the data (r,a280)

#                     |<---    the function you're fitting    -->|  |<---- the initial guesses ---->|
auc_fit <-
  nls(a280 ~ a0 * exp(((Mb * omega_sq) / two_rt) * (r ^ 2 - r0 ^ 2)), start = list(a0 = 1, Mb = 10000))

# don't forget to look at the output of the fit
summary(auc_fit)

# predict a280 from the nonlinear function using the function predict()
a280_pred <- predict(auc_fit)

# Add the line of best fit to the AUC data
auc_plot <-
  auc_plot + geom_line(aes(y = a280_pred), colour = "orange")
auc_plot

# You can compare the predicted with measured a280 values in a residual plot
residuals = a280 - a280_pred
res_plot <- data.frame(r, residuals)

# plot the residuals - need x=r and y=residuals
# what does this plot show?
res_plot <- ggplot(data = res_plot, aes(x = r, y = residuals)) +
  geom_point(shape = 1,
             size = 3,
             colour = "darkgrey") +
  mytheme() +
  labs(x = "r (cm)", y = "residual (A.U.)") +
  coord_cartesian(xlim = c(6.8, 7.2), ylim = c(-0.05, 0.05)) +
  geom_hline(aes(yintercept = 0), col = 'orange', size = .5)
res_plot


#### Generating the output figure ####
# Below I use grid.arrange to plot everything on the same page so that you can see the differences.

# This line remove x-axis labels and title to make a neater final figure
auc_plot <-
  auc_plot + theme(axis.title.x = element_blank(), axis.text.x = element_blank())

# Here we make a .png file that can go into your report
# The layout of data on top, residuals underneath is a style
# of data presentation that you would typically see in the literature
auc_plot_grid <-
  ggarrange(
    auc_plot,
    res_plot,
    nrow = 2,
    ncol = 1,
    widths = c(1, 1 / 2)
  )


# Extracting the predicted value of Mb from your nonlinear fit
mb_pred = summary(auc_fit)$coefficients[2, 1]

# Calculating the auc_mw of Im9-HiGam
auc_mw = mb_pred / (1 - vbar * rho)
auc_mw # this value is in Da

# So ... what does this tell you?



# Linearising the AUC data with a plot of r-squared and log(absorbance)
# Treating the data this way shows the short comings of making non-linear data set linear
# auc_plot.linear <- ggplot(data=auc, aes(x=r*r, y=log(a280)))
# auc_plot.linear <- auc_plot.linear + geom_point(shape=1, size=3, colour="darkgrey")
# auc_plot.linear
