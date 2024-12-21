* Description: Greenfield panel analysis - model 5a
* Author: Andrew Kent Johnston
* Date: Dec 20, 2024

* Clear the workspace
clear all
set more off

* ----- Data Import -----
import delimited using "../processed_data/greenfield_panel_dataset.csv", clear

* ----- Data Cleaning and Filtering -----

* Convert `colonial_link` and `geographic_proximity` to dummy variables
gen colonial_link_dummy = (colonial_link == "True")
gen geographic_proximity_dummy = (geographic_proximity == "True")

* Drop the original string variables and rename the dummies
drop colonial_link geographic_proximity
rename colonial_link_dummy colonial_link
rename geographic_proximity_dummy geographic_proximity

* Dropping entities with incomplete observations for both years
egen row_missing = rowmiss(prop_emne_capital gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link)
bysort country: egen total_missing = total(row_missing)
drop if total_missing > 0

* Generating a numeric ID for countries
egen country_id = group(country)

* ----- Data Analysis -----

* Declaring the data as panel data using the new country ID
xtset country_id year

* Running a random effects panel Tobit model with bounds
log using "../results/model_5a_replication.log", replace text
xttobit prop_emne_capital gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link, ll(0) ul(1) re

* Store the results of the random effects model
estimates store re_model

* Export Tobit results to CSV (Excel-compatible)
esttab re_model using "../results/model_5a_results.csv", replace title("Random Effects Panel Tobit Results") label se b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)

log close

* Estimating a pooled Tobit model
log using "../results/model_5a_replication.log", append text
tobit prop_emne_capital gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link, ll(0) ul(1)

* Store the results of the pooled Tobit model for later comparison
estimates store pooled_model

log close

* ----- Summary Statistics and Correlation Matrix -----

* Generate and export the correlation matrix using asdoc
asdoc pwcorr prop_emne_capital gni_per_capita broadband_per_capita mobiles_per_capita geographic_proximity colonial_link, save(../results/model_5a_correlation_matrix.doc) replace title(Correlation Matrix)
