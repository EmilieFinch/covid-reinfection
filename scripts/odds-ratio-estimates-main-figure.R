# ---------------------------------------------------------------
# Reinfection Odds Ratio Moving Threshold 
# Author: Emilie Finch

# ---------------------------------------------------------------
# Code to reproduce main figure (Figure 2)
# This shows odds ratio estimates comparing odds of reinfection in seropositive individuals
# with odds of primary infection in seronegative individuals.

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

# Load in data 
weekly_pcr <- read.csv(here("data/weekly-pcr-positivity-for-main-figure.csv"))
weekly_antibody <- read.csv(here("data/weekly-antibody-data-for-main-figure.csv"))
weekly_reinfected <- read.csv(here("data/weekly-reinfected-for-main-figure.csv"))
odds_ratio_estimates <- read.csv(here("data/odds-ratio-estimates.csv"))

# ---------------------------------------------------------------

# Plot Figures

# A. Weekly PCR positivity in cohort over time

weekly_pcr$date <- as.Date(weekly_pcr$date, format = "%d/%m/%Y") 

pcr_positivity_timeseries <- ggplot(weekly_pcr, aes(x=date, y = pcr_positivity, group = 1)) + geom_point(size = 0.8, color = "#081d58") +
  geom_errorbar(aes(ymax = positivity_ci_upper, ymin = positivity_ci_lower), alpha= 0.7, color = "#081d58") +
  geom_line(aes(x=date, y = pcr_positivity), linetype = "dotted", lwd = 0.3, color = "#081d58") +
  ylab("PCR Positivity") + xlab("Date") + scale_y_continuous(breaks = seq(0,100, by = 10)) + theme(strip.text.y = element_blank()) +  
  scale_x_date(limits = as.Date(c("2020-05-01", "2021-01-15")), labels = date_format("%b"), breaks = "month") +
  theme_classic()+ theme(strip.text.y = element_blank(), axis.title = element_text(size = 8), axis.text = element_text(size = 6))

# B. Weekly percentage ever seropositive in cohort over time

weekly_antibody$date <- as.Date(weekly_antibody$date, format = "%d/%m/%Y") 

adjusted_ever_seropositive_timeseries <- ggplot(subset(weekly_antibody, (rogan_gladen_estimate != 0) & date >= as.Date("2020-04-26", format = "%Y-%m-%d")), aes(x=date, y = rogan_gladen_estimate, group = 1)) + 
  geom_point(size = 0.8, color = "#993404") +
  geom_errorbar(aes(ymax = rogan_gladen_ci_upper, ymin = rogan_gladen_ci_lower), color = "#993404", alpha =  0.7, width = 8) +
  geom_line(aes(x=date, y = rogan_gladen_estimate), linetype = "dotted", lwd = 0.3, color = "#993404") +
  ylab("Percentage Ever Seropositive") + xlab("Date")  + scale_y_continuous(breaks = seq(0,9, by = 1)) +
  scale_x_date(limits = as.Date(c("2020-05-01", "2021-01-15")), labels = date_format("%b"), breaks = "month") +
  theme_classic()+ theme(strip.text.y = element_blank(), axis.title = element_text(size = 8), axis.text = element_text(size = 6), legend.position = "none")

# C. Weekly possible reinfections

weekly_reinfected$week_reinf <- as.Date(weekly_reinfected$week_reinf, format = "%d/%m/%Y") 

reinfected_bar <- ggplot(weekly_reinfected, aes(x=week_reinf)) + 
  geom_bar(width = 5, position = "stack", fill = "#7fbc41")  + labs(y = "Number Reinfected", x = "Date")  + 
  scale_x_date(limits = as.Date(c("2020-05-01", "2021-01-15")), labels = date_format("%b"), breaks = "month")  + 
  theme_classic() + theme(axis.title = element_text(size = 8), axis.text = element_text(size = 6), legend.position = "none")

# D. Adjusted odds ratio estimates over time

odds_ratio_estimates$date <- as.Date(odds_ratio_estimates$date, format = "%d/%m/%Y") 

odds_ratios_plot <- ggplot(subset(odds_ratio_estimates, complete.cases(odds_ratio_estimates)), aes(x=date, y = estimate_adj, group = 1)) + 
  geom_point(size = 1, color = "#6a51a3") + 
  geom_errorbar(aes(ymax = confint_upper_adj, ymin = confint_lower_adj), color = "#6a51a3") +
  ylab("Adjusted Odds Ratio Estimate") + xlab("Date")  +  scale_x_date(limits = as.Date(c("2020-05-01", "2021-01-15")), labels = date_format("%b"), breaks = "month") +
  theme_classic()+ theme( axis.title = element_text(size = 8), axis.text = element_text(size = 6), legend.position = "none")


odds_ratio_plot_comb <- ggarrange(pcr_positivity_timeseries, adjusted_ever_seropositive_timeseries, reinfected_bar,  odds_ratios_plot, ncol = 2, nrow = 2,  labels = c("A", "B", "C", "D", "E"), font.label = list(size = 12, face = "bold", color = "black"))
odds_ratio_plot_comb

#ggsave("odds-ratio-plot-combined_03-03-2020.png", odds_ratio_plot_comb, width = 6, height = 6)

