# covid-reinfection

This repository contains data and code to produce the figures and simulation analysis presented in "SARS-CoV-2 infection and reinfection in a seroepidemiological workplace cohort in the United States".

The data used for both is located in the folder `data`. As this analysis used individual-level data, we did not include the full dataset in order to preserve the confidentiality and anonymity of participants. This repository includes aggregated PCR and serology data, as well as a file containing unadjusted and adjusted odds ratio estimates for reinfection obtained through logistic regression on the full dataset.

The following scripts are included in the repository:

-`odds-ratio-estimates-main-figure.R` - to reproduce the main figure (Figure 2) showing the adjusted odds ratio moving threshold analysis.

-`simulation-analysis.R` - to reproduce the simulation analysis presented in Figure 4.

-`odds-ratio-comparison-figure.R` - to reproduce Figure 3 comparing unadjusted and adjusted odds ratios.


### Reference

Finch E, Lowe R, Fischinger S et al. SARS-CoV-2 infection and reinfection in a seroepidemiological workplace cohort in the United States, 2021.
