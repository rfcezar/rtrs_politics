*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Table 3: Donation is Larger than $0, PL Party           *
*===========================================================*
*--- 1. Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear

*--- 2. Variable Construction ---*
* Indicator for PL party
*gen PL = (SG_PARTIDO == "PL")

* Interactions with PL
gen PL_RTRS1 = PL*RTRS1
gen PL_RTRS2 = PL*RTRS2
gen PL_RTRS3 = PL*RTRS3

*--- 3. Restrict Sample ---*
* Focus only on actual donations
keep if Donation>0

** Run Estimations for RTRS1
* PPML with high-dimensional fixed effects
ppmlhdfe Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column1
* Poisson with fixed effects (dummies)
poisson Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column2
* Tobit model with fixed effects (dummies)
tobit Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column3

** Run Estimations for RTRS2
ppmlhdfe Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column4
poisson Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column5
tobit Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column6

** Run Estimations for RTRS3
ppmlhdfe Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column7
poisson Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column8
tobit Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column9
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6 Column7 Column8 Column9] using TableA1.doc, replace title("Table A1") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using TableA1.doc


*===========================================================*
* We provide a simpler and more systematic version of the code that produces the same outcomes as above *
* Table 3: Donation is Larger than $0, PL Party     *        
*===========================================================*

* Create interaction terms with PL
foreach var in RTRS1 RTRS2 RTRS3 {
    gen PL_`var' = PL * `var'
}

*--- Estimation Setup ---*

* Control variables
global controls Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age

* Fixed effects
global fe NR_PARTIDO Municipality

* Clustered standard errors
global cluster vce(cluster NR_PARTIDO)

* Define estimation function
program define run_pl_models_pos
    syntax varname(name=mainvar) [if], suffix(name)

    * PPML estimation with high-dimensional fixed effects
    ppmlhdfe Donation `mainvar' PL_`mainvar' $controls, a($fe) $cluster
    est store PPML_`suffix'

    * Poisson with fixed effects (dummies)
    poisson Donation `mainvar' PL_`mainvar' $controls i.NR_PARTIDO, $cluster
    est store Pois_`suffix'

    * Tobit model
    tobit Donation `mainvar' PL_`mainvar' $controls i.NR_PARTIDO, ll $cluster
    est store Tobit_`suffix'

    * Export results to Word document
    outreg2 [PPML_`suffix' Pois_`suffix' Tobit_`suffix'] ///
        using Table3_`suffix'.doc, replace ///
        title("Table 3 - PL Donations > $0: `mainvar'") ///
        e(r2_p, chi2, F) ///
        nonote ///
        addnote("Note: (1) ***, **, * indicate significance at 1%, 5%, and 10% levels.", ///
                "(2) Standard errors clustered at party level (NR_PARTIDO).")

    * Open the Word document (optional)
    shellout using Table3_`suffix'.doc
end

*--- 5. Run Estimations ---*

run_pl_models_pos RTRS1, suffix(P1)
run_pl_models_pos RTRS2, suffix(P2)
run_pl_models_pos RTRS3, suffix(P3)

*--- End of Script ---*
display as text _newline "Table 3 replication complete. Files: Table3_P1.doc, Table3_P2.doc, Table3_P3.doc."
