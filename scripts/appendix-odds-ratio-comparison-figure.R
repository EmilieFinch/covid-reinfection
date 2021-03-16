# ---------------------------------------------------------------
# Adjusted and Unadjusted Odds Ratios Figure
# Author: Emilie Finch

# ---------------------------------------------------------------
# Code to reproduce Appendix Figure 2 contrasting unadjusted odds ratios and adjusted odds ratios
# install.packages("tidyverse")
# install.packages("ggpubr")
# install.packages("scales")
# install.packages("epitools")
# install.packages("binom")

library(tidyverse)
library(ggpubr)
library(scales)
library(epitools)
library(binom)
library(here)

# ---------------------------------------------------------------

# Load in the data

odds_ratio_estimates <- read.csv(here("data/odds-ratio-estimates.csv"))

# Ensure date column is date class

odds_ratio_estimates$date <- as.Date(odds_ratio_estimates$date, format = "%d/%m/%Y") 

# ---------------------------------------------------------------

# Plot Figure

# A. Unadjusted

odds_ratios_unadj_plot <- ggplot(subset(odds_ratio_estimates, complete.cases(odds_ratio_estimates)), aes(x=date, y = estimate_unadj, group = 1)) + geom_point(size = 1, color = "#6a51a3") + 
  geom_errorbar(aes(ymax = confint_upper_unadj, ymin = confint_lower_unadj), color = "#6a51a3") +
  ylab("Unadjusted Odds Ratio Estimate") + xlab("Date") + 
  geom_hline(yintercept = 1, linetype = "dashed", lwd = 0.3) +
  scale_y_continuous(breaks = 0:12) + coord_cartesian(ylim = c(0,4)) +
  scale_x_date(limits = as.Date(c("2020-05-01", "2021-01-15")), labels = date_format("%b"), breaks = "month") +
  theme_classic()+ theme( axis.title = element_text(size = 8), axis.text = element_text(size = 6), legend.position = "none")

# B. Adjusted

odds_ratios_plot <- ggplot(subset(odds_ratio_estimates, complete.cases(odds_ratio_estimates)), aes(x=date, y = estimate_adj, group = 1)) + 
  geom_point(size = 1, color = "#6a51a3") + 
  geom_errorbar(aes(ymax = confint_upper_adj, ymin = confint_lower_adj), color = "#6a51a3") +
  geom_hline(yintercept = 1, linetype = "dashed", lwd = 0.3) +
  ylab("Adjusted Odds Ratio Estimate") + xlab("Date")  +  scale_x_date(limits = as.Date(c("2020-05-01", "2021-01-15")), labels = date_format("%b"), breaks = "month") +
  coord_cartesian(ylim = c(0,4)) +
  theme_classic()+ theme( axis.title = element_text(size = 8), axis.text = element_text(size = 6), legend.position = "none")

odds_ratio_comparison <- ggarrange(odds_ratios_unadj_plot, odds_ratios_plot, ncol = 2, nrow = 1,  labels = c("A", "B"), font.label = list(size = 12, face = "bold", color = "black"))

odds_ratio_comparison
#ggsave("odds-ratio-plot-combined_12-03-2021.png", odds_ratio_comparison, width = 6, height = 3)


