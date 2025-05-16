*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Table 1: Baseline Estimation for Donation Flows, PL     *
*===========================================================*
*--- 1. Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear

*--- 2. Variable Construction ---*
* Indicator for PL party, we already defined
*gen PL = (SG_PARTIDO == "PL")
label var PL "Partido Liberal (PL) as Bolsonaro's party" 

* Interactions with PL
gen PL_RTRS1 = PL*RTRS1
gen PL_RTRS2 = PL*RTRS2
gen PL_RTRS3 = PL*RTRS3

*--- 3. Estimation Function (Helper for Reusability) ---*
*===========================================================*
** Run Estimations for RTRS1
*===========================================================*
*** Column 1: Jackknife + FE OLS
jacknife: reghdfe Donation RTRS1 PL_RTRS1, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column1
*** Column 2: Poisson Pseudo-Maximum Likelihood (PPML)
ppmlhdfe Donation RTRS1 PL_RTRS1, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO) sep(fe simplex) d
est store Column2
*** Column 3: Poisson with FEs via i. factor
poisson Donation RTRS1 PL_RTRS1 i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column3
*** Column 4: Bootstrap Poisson
bootstrap _b: poisson Donation RTRS1 PL_RTRS1, vce(cluster NR_PARTIDO)
est store Column4
* Tobit regression of Donation, specifying that y is censored at 0, lower-censoring limit is zero
*** Column 5: Tobit with Party FEs
tobit Donation RTRS1 PL_RTRS1 i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column5
*** Column 6: Bootstrap Tobit
bootstrap _b: tobit Donation RTRS1 PL_RTRS1, ll vce(cluster NR_PARTIDO)
est store Column6
*** Column 7: Tobit
tobit Donation RTRS1 PL_RTRS1, ll vce(cluster NR_PARTIDO)
est store Column7
* Output results
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6 Column7] using RTRS1.doc, replace title("Table 1: Basiline Result of Pool Estimation") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using RTRS1.doc

*===========================================================*
** Run Estimations for RTRS2
*===========================================================*
jacknife: reghdfe Donation RTRS2 PL_RTRS2, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column1
ppmlhdfe Donation RTRS2 PL_RTRS2, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO) sep(fe simplex) d
est store Column2
poisson Donation RTRS2 PL_RTRS2 i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column3
bootstrap: poisson Donation RTRS2 PL_RTRS2, vce(cluster NR_PARTIDO)
est store Column4
tobit Donation RTRS2 PL_RTRS2 i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column5
bootstrap: tobit Donation RTRS2 PL_RTRS2, ll vce(cluster NR_PARTIDO)
est store Column6
tobit Donation RTRS2 PL_RTRS2, ll vce(cluster NR_PARTIDO)
est store Column7
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6 Column7] using RTRS2.doc, replace title("Table 1: Basiline Result of Pool Estimation") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using RTRS2.doc

*===========================================================*
** Run Estimations for RTRS3
*===========================================================*
jacknife: reghdfe Donation RTRS3 PL_RTRS3, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column1
ppmlhdfe Donation RTRS3 PL_RTRS3, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO) sep(fe simplex) d
est store Column2
poisson Donation RTRS3 PL_RTRS3 i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column3
bootstrap: poisson Donation RTRS3 PL_RTRS3, vce(cluster NR_PARTIDO)
est store Column4
tobit Donation RTRS3 PL_RTRS3 i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column5
bootstrap: tobit Donation RTRS3 PL_RTRS3, ll vce(cluster NR_PARTIDO)
est store Column6
tobit Donation RTRS3 PL_RTRS3, ll vce(cluster NR_PARTIDO)
est store Column7
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6 Column7] using RTRS3.doc, replace title("Table 1: Basiline Result of Pool Estimation") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using RTRS3.doc


*===========================================================*
* We provide a simpler and more systematic version of the code that produces the same outcomes as above *
* Table 1: Baseline Estimates of Donation      *        
*===========================================================*

program define run_models
    syntax varlist(min=2 max=2)
    local audit = word("`varlist'", 1)
    local interaction = word("`varlist'", 2)

    * Column 1: Jackknife + FE OLS
    jackknife: reghdfe Donation `audit' `interaction', a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
    est store Column1

    * Column 2: Poisson Pseudo-Maximum Likelihood (PPML)
    ppmlhdfe Donation `audit' `interaction', a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO) sep(fe simplex) d
    est store Column2

    * Column 3: Poisson with FEs via i. factor
    poisson Donation `audit' `interaction' i.NR_PARTIDO, vce(cluster NR_PARTIDO)
    est store Column3

    * Column 4: Bootstrap Poisson
    bootstrap _b: poisson Donation `audit' `interaction', vce(cluster NR_PARTIDO)
    est store Column4

    * Column 5: Tobit with Party FEs
    tobit Donation `audit' `interaction' i.NR_PARTIDO, ll(0) vce(cluster NR_PARTIDO)
    est store Column5

    * Column 6: Bootstrap Tobit
    bootstrap _b: tobit Donation `audit' `interaction', ll(0) vce(cluster NR_PARTIDO)
    est store Column6

    * Column 7: Tobit
    tobit Donation `audit' `interaction', ll(0) vce(cluster NR_PARTIDO)
    est store Column7

    * Output results
    local docname = upper("`audit'")
    outreg2 [Column1 Column2 Column3 Column4 Column5 Column6 Column7] using `docname'.doc, ///
        replace title("Table 1: Baseline Results – `audit'") e(r2_p, chi2, F) nonote ///
        addnote("Note: (1) ***, **, * indicate significance at 1%, 5%, and 10% levels, respectively;", ///
                "(2) Standard errors clustered at party or municipality level as specified.")
    
    shellout using `docname'.doc
end

* Run Estimations for Each RTRS Measure *

run_models RTRS1 PL_RTRS1
run_models RTRS2 PL_RTRS2
run_models RTRS3 PL_RTRS3

***********************************************************************
* End of File
***********************************************************************