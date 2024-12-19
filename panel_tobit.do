* Load the data
clear
import delimited "panel_dataset.csv", clear

* Ensure panel structure is set
xtset country year

* Drop observations with missing data
drop if missing(prop_emne, prop_emne_excl_nat_res, prop_emne_excl_col_link, prop_emne_excl_qst_source, ///
    voice_and_acc, pol_stability, govt_effectiveness, reg_quality, rule_of_law, control_of_corruption, ///
    gni_per_capita, broadband_per_capita, mobiles_per_capita, phones_per_capita, geographic_proximity)

* Model 1: Dependent variable is prop_emne
xttobit prop_emne voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law ///
    control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita phones_per_capita ///
    geographic_proximity colonial_link, re

* Model 2: Dependent variable is prop_emne_excl_nat_res
xttobit prop_emne_excl_nat_res voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law ///
    control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita phones_per_capita ///
    geographic_proximity colonial_link, re

* Model 3: Dependent variable is prop_emne_excl_col_link (exclude colonial_link variable)
xttobit prop_emne_excl_col_link voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law ///
    control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita phones_per_capita ///
    geographic_proximity, re

* Model 4: Dependent variable is prop_emne_excl_qst_source
xttobit prop_emne_excl_qst_source voice_and_acc pol_stability govt_effectiveness reg_quality rule_of_law ///
    control_of_corruption gni_per_capita broadband_per_capita mobiles_per_capita phones_per_capita ///
    geographic_proximity colonial_link, re

* Save the results
estimates save model_results, replace

* End of do file
