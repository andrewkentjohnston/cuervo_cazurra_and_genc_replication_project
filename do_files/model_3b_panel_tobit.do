* Description: Cuervo-Cazurra and Genc (2008) replication - model 3b (updated data version)
* Author: Andrew Kent Johnston
* Date: Dec 19, 2024

* Clear the workspace
clear all
set more off

* ----- Data Import -----
import delimited using "../processed_data/panel_dataset.csv", clear

* ----- Data Cleaning and Filtering -----

* Convert `colonial_link` and `geographic_proximity` to dummy variables
* Check unique values in these variables
list geographic_proximity colonial_link if missing(geographic_proximity) | missing(colonial_link)

gen colonial_link_dummy = (colonial_link == "True")
gen geographic_proximity_dummy = (geographic_proximity == "True")

* Verify the conversion
tabulate colonial_link_dummy
tabulate geographic_proximity_dummy

* Drop the original string variables and rename the dummies
drop colonial_link geographic_proximity
rename colonial_link_dummy colonial_link
rename geographic_proximity_dummy geographic_proximity

* Dropping entities with incomplete observations for both years
egen row_missing = rowmiss(prop_emne_excl_col_link voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link)
bysort country: egen total_missing = total(row_missing)
drop if total_missing > 0

* Generating a numeric ID for countries
egen country_id = group(country)

* ----- Data Analysis -----

* Declaring the data as panel data using the new country ID
xtset country_id year

* Running a random effects panel Tobit model with bounds
log using "../results/model_3b_replication.log", replace text
xttobit prop_emne_excl_col_link voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link, ll(0) ul(1) re

* Store the results of the random effects model
estimates store re_model

log close

* Estimating a pooled Tobit model
log using "../results/model_3b_replication.log", append text
tobit prop_emne_excl_col_link voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link, ll(0) ul(1)

* Store the results of the pooled Tobit model for later comparison
estimates store pooled_model

log close

* ----- Summary Statistics and Correlation Matrix -----

* Log the summary statistics and correlation matrix
log using "../results/model_3b_replication.log", append text
summarize prop_emne_excl_col_link voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link
pwcorr prop_emne_excl_col_link voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link, star(0.05)
log close
