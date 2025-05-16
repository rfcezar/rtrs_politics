*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Table 2: Estimation of Donations to Centrão (CP Party)  *
*===========================================================*
*--- 1. Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear

*--- 2. Variable Construction ---*
* Define CP (Centrão Party) binary indicator
label variable CP "Centrão Party"

* Interactions with CP
gen CP_RTRS1 = CP*RTRS1
gen CP_RTRS2 = CP*RTRS2
gen CP_RTRS3 = CP*RTRS3

** Run Estimations for RTRS1
* PPML with high-dimensional fixed effects
ppmlhdfe Donation RTRS1 CP_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column1
* Poisson with fixed effects (dummies)
poisson Donation RTRS1 CP_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column2
* Tobit model with fixed effects (dummies)
tobit Donation RTRS1 CP_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column3

** Run Estimations for RTRS2
ppmlhdfe Donation RTRS2 CP_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column4
poisson Donation RTRS2 CP_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column5
tobit Donation RTRS2 CP_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column6

** Run Estimations for RTRS3
ppmlhdfe Donation RTRS3 CP_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column7
poisson Donation RTRS3 CP_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column8
tobit Donation RTRS3 CP_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column9
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6 Column7 Column8 Column9] using Table2.doc, replace title("Table A1") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using Table2.doc




*===========================================================*
* We provide a simpler and more systematic version of the code that produces the same outcomes as above *
* Table 2: Estimation of Donations to Centrão (CP Party)     *        
*===========================================================*

* Create interaction terms with CP
foreach var in RTRS1 RTRS2 RTRS3 {
    gen CP_`var' = CP * `var'
}

*--- Estimation Setup ---*

* Control variables
global controls Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age

* Fixed effects
global fe NR_PARTIDO Municipality

* Clustered standard errors
global cluster vce(cluster NR_PARTIDO)

* Define estimation function
program define run_cp_models
    syntax varname(name=mainvar) [if], suffix(name)

    * PPML estimation with high-dimensional fixed effects
    ppmlhdfe Donation `mainvar' CP_`mainvar' $controls, a($fe) $cluster
    est store PPML_`suffix'

    * Poisson with party fixed effects as dummies
    poisson Donation `mainvar' CP_`mainvar' $controls i.NR_PARTIDO, $cluster
    est store Pois_`suffix'

    * Tobit with lower limit at 0
    tobit Donation `mainvar' CP_`mainvar' $controls i.NR_PARTIDO, ll $cluster
    est store Tobit_`suffix'

    * Export results to Word document
    outreg2 [PPML_`suffix' Pois_`suffix' Tobit_`suffix'] ///
        using Table2_`suffix'.doc, replace ///
        title("Table 2 - Centrão Donations: `mainvar'") ///
        e(r2_p, chi2, F) ///
        nonote ///
        addnote("Note: (1) ***, **, * indicate significance at 1%, 5%, and 10% levels.", ///
                "(2) Standard errors clustered at party level (NR_PARTIDO).")

    * Open the Word document (optional)
    shellout using Table2_`suffix'.doc
end

*--- 4. Run Estimations for CP Party ---*

run_cp_models RTRS1, suffix(C1)
run_cp_models RTRS2, suffix(C2)
run_cp_models RTRS3, suffix(C3)

*--- End of Script ---*
display as text _newline "Table 2 replication complete. Files: Table2_C1.doc, Table2_C2.doc, Table2_C3.doc."

***********************************************************************
* End of File
***********************************************************************
