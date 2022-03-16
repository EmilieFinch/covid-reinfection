# covid-reinfection

This repository contains data and code to produce the figures and simulation analysis presented in "SARS-CoV-2 antibodies protect against reinfection for at least 6 months in a multicentre seroepidemiological workplace cohort" *PLOS Biology* ([https://doi.org/10.1371/journal.pbio.3001531](https://doi.org/10.1371/journal.pbio.3001531))

A previous version of this analysis was published as a preprint in May 2021 and is available on [medrxiv](https://www.medrxiv.org/content/10.1101/2021.05.04.21256609v1).

The data used for both is located in the folder `data`. As this analysis used individual-level data, we did not include the full dataset in order to preserve the confidentiality and anonymity of participants. This repository includes aggregated PCR and serology data, as well as a file containing unadjusted and adjusted odds ratio estimates for reinfection obtained through logistic regression on the full dataset.

The following scripts are included in the repository:

-`odds-ratio-estimates-main-figure.R` - to reproduce the main figure (Figure 2) showing the adjusted odds ratio moving threshold analysis.

-`simulation-analysis.R` - to reproduce the simulation analysis presented in Figure 4.

-`odds-ratio-comparison-figure.R` - to reproduce Figure 3 comparing unadjusted and adjusted odds ratios.


### Reference

Finch E, Lowe R, Fischinger S et al. SARS-CoV-2 antibodies protect against reinfection for at least 6 months in a multicentre seroepidemiological workplace cohort, 2022
