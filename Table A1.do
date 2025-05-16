*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
* (Appendix) Table A1: Estimation of Donation Flows, PL Party *
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
* Table A1: Estimation of Donation Flows, PL Party    *        
*===========================================================*

* Create interaction terms
foreach var in RTRS1 RTRS2 RTRS3 {
    gen PL_`var' = PL * `var'
}

*--- Estimation Setup ---*

* List of control variables
global controls Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age

* List of FE
global fe NR_PARTIDO Municipality

* Clustered SE
global cluster vce(cluster NR_PARTIDO)

* Function to estimate models and export results
program define run_models
    syntax varname(name=mainvar) [if], suffix(name)

    * PPML with high-dimensional fixed effects
    ppmlhdfe Donation `mainvar' PL_`mainvar' $controls, a($fe) $cluster
    est store PPML_`suffix'

    * Poisson with fixed effects (dummies)
    poisson Donation `mainvar' PL_`mainvar' $controls i.NR_PARTIDO, $cluster
    est store Pois_`suffix'

    * Tobit model
    tobit Donation `mainvar' PL_`mainvar' $controls i.NR_PARTIDO, ll $cluster
    est store Tobit_`suffix'

    * Export to Word using outreg2
    outreg2 [PPML_`suffix' Pois_`suffix' Tobit_`suffix'] ///
        using Table_`suffix'.doc, replace ///
        title("Table A1 - Donation Effects: `mainvar'") ///
        e(r2_p, chi2, F) ///
        nonote ///
        addnote("Note: (1) ***, **, * indicate significance at 1%, 5%, and 10% levels, respectively.", ///
                "(2) Robust standard errors clustered at the party level.") 

    * Open the output document (optional)
    shellout using Table_`suffix'.doc
end

*--- Run Estimations ---*

run_models RTRS1, suffix(A1)
run_models RTRS2, suffix(A11)
run_models RTRS3, suffix(A12)

*--- End of Script ---*
display as text _newline "Replication complete. Tables saved as Table_A1.doc, Table_A11.doc, and Table_A12.doc."

***********************************************************************
* End of File
***********************************************************************
