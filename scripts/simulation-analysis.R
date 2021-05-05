
# ---------------------------------------------------------------
# Risk Ratio Moving Window Simualtion
# Author: Emilie Finch

# ---------------------------------------------------------------
# Code to reproduce risk ratio simulation analysis (Figure 4)

# install.packages("tidyverse")
# install.packages("ggpubr")
# install.packages("scales")
# install.packages("epitools")
# install.packages("binom")
# install.packages("here")

library(tidyverse)
library(ggpubr)
library(scales)
library(epitools)
library(binom)
library(here)

# ---------------------------------------------------------------
# Load in data 

by_week_pcr <- read.csv(here("data/weekly-pcr-data-for-simulation.csv"))

# Calculate incidence risk, cumulative risk and the scaled cumulative risk (this is scaled to a maximum of 0.08 to reflect overall seropositivity in the cohort)

by_week_pcr <- by_week_pcr %>%
  mutate(incidence_risk = (new_pcr_positive/(cumulative_pcr_tested - (cumulative_pcr_positive - new_pcr_positive)))) %>%
  mutate(cumulative_risk = cumsum(incidence_risk)) %>%
  mutate(cumulative_risk_scaled = rescale(cumulative_risk, to = c(0, 0.08))) 

# ---------------------------------------------------------------
# Risk ratio moving threshold simulation 

# Set seed

set.seed(7001006)

dist <- by_week_pcr$cumulative_risk_scaled 
dates <- seq(as.Date("2020-04-05"), as.Date("2021-01-31"), by = 7)
contingency_tables = list()
size = 2000

# P(Reinf | Seropositive) = 0.15

for(i in dates){
  
  j <- match(i, dates)
  
  # Simulate seropositive and seronegative individuals by timepoint i 
  sero <- sample(c('Seropositive', 'Seronegative'), size = size, replace = TRUE, prob = c(dist[j], 1-dist[j]))
  
  # Simulate of the number seropositive and seronegative by timepoint i, how many would go on to become PCR positive or remain PCR negative after timepoint i
  
  seropos <- table(sample(c('PCR_Negative', 'PCR_Positive'), size = sum(sero == "Seropositive"), replace = TRUE, prob = c(1 - (0.15*(1-prod(1 - dist[(j+1):44]))), 0.15*(1-prod(1 - dist[(j+1):44])))))
  seroneg <- table(sample(c('PCR_Negative', 'PCR_Positive'), size = sum(sero == "Seronegative"), replace = TRUE, prob = c(1 - (1-prod(1 - dist[(j+1):44])), (1-prod(1 - dist[(j+1):44])))))
  
  reinfected_samples = data.frame(PCR_Negative = NA, PCR_Positive= NA)
  
  reinfected_samples[1,1] <- seroneg["PCR_Negative"]
  reinfected_samples[1,2] <- seroneg["PCR_Positive"]
  reinfected_samples[2,1] <- seropos["PCR_Negative"]
  reinfected_samples[2,2] <- seropos["PCR_Positive"]
  
  row.names(reinfected_samples) <- c('Seronegative', 'Seropositive')
  
# Store contingency table in list
  contingency_tables[j] <- split(reinfected_samples, 2)
  print(i)  
}

rm(reinfected_samples)

# Calculate risk ratio for each week in dataset

risk_ratios <- data.frame()

for (i in dates) {
  
  skip_to_next <- FALSE
  
  tryCatch({
    j <- match(i, dates)
    risk <- riskratio(data.matrix(contingency_tables[[j]]))
    temp <- as.data.frame(risk$measure) %>%
      slice(2)
    print(temp)
    temp$week <- as.Date(i, origin = "1970-01-01")
    
    risk_ratios<- rbind(risk_ratios, temp)
  }, error = function(e) { skip_to_next <<- TRUE})
  
  if(skip_to_next) { next } 
  
}
rm(temp,risk)
rownames(risk_ratios) <- NULL

# ---------------------------------------------------------------
# Plot figures 

# Plot risk ratios 

risk_ratio_plot <- ggplot(risk_ratios, aes(x=week, y = estimate, group = 1))  +
  geom_point(size = 0.5, color = "#053061") + 
  geom_errorbar(aes(ymax = upper, ymin = lower), color = "#053061", alpha = 0.8, size = 0.4) + 
  geom_hline(yintercept = 0.15, linetype = "dashed", lwd = 0.3) +
  ylab("Risk Ratio Estimate") +
  xlab("Date")  +
  scale_x_date(limits = as.Date(c("2020-04-05", "2021-01-31")), labels = date_format("%b"), breaks = "month") +
  theme_classic()+ theme( axis.title = element_text(size = 10), axis.text = element_text(size = 8))

# Plot cumulative infection risk 

x <- dates
risk_dist <- as.data.frame(cbind(dist, x))
risk_dist$x <- as.Date(x, origin = "1970-01-01")

risk_dist_plot <- ggplot(risk_dist) + geom_line(aes(y = dist, x = x), color = "#053061") + labs(x = "Time", y = "Cumulative Risk of Infection") +
  scale_x_date(limits = as.Date(c("2020-04-05", "2021-01-31")), labels = date_format("%b"), breaks = "month") +
  theme_classic()+ theme( axis.title = element_text(size = 10), axis.text = element_text(size = 8))

# Combine two plots in one figure

risk_ratio_simulation_plot <- ggarrange(risk_dist_plot, risk_ratio_plot, ncol = 2, nrow = 1,  labels = c("A", "B"), font.label = list(size = 12, face = "bold", color = "black"))
risk_ratio_simulation_plot

#ggsave("risk-ratio-simulation-spacex.png", risk_ratio_spacex, width = 6, height = 3)
