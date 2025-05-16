*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Table 5: Robustness Estimation of Donation, PL Party    *
*===========================================================*
*--- 1. Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear

*--- 2. Variable Construction ---*
* Indicator for PL party
*gen PL = (SG_PARTIDO == "PL")

* Label CU for clarity
label var CU "Number of conservation units"

* Interactions with CU and PL
gen CU_RTRS1 = CU*RTRS1
gen CU_RTRS2 = CU*RTRS2
gen CU_RTRS3 = CU*RTRS3

gen CU_PL_RTRS1 = CU*PL*RTRS1
gen CU_PL_RTRS2 = CU*PL*RTRS2
gen CU_PL_RTRS3 = CU*PL*RTRS3


** Run Estimations for RTRS1
* PPML with high-dimensional fixed effects
ppmlhdfe Donation CU_RTRS1 CU_PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO) vce(cluster NR_PARTIDO) sep(fe simplex) d
est store Column1
* Tobit model with fixed effects (dummies)
tobit Donation CU_RTRS1 CU_PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column2

** Run Estimations for RTRS2
ppmlhdfe Donation CU_RTRS2 CU_PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO) vce(cluster NR_PARTIDO) sep(fe simplex) d
est store Column3
tobit Donation CU_RTRS2 CU_PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column4

** Run Estimations for RTRS3
ppmlhdfe Donation CU_RTRS3 CU_PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO) vce(cluster NR_PARTIDO) sep(fe simplex) d
est store Column5
tobit Donation CU_RTRS3 CU_PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column6
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6] using Table5.doc, replace title("Table A1") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using Table5.doc

** Real Donation
* we focus on donation > 0
drop if Donation == 0 | missing(Donation)
** Run Estimations for RTRS1
* OLS with high-dimensional FE and jackknife standard errors
jacknife: reghdfe Donation CU_RTRS1 CU_PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column1
tobit Donation CU_RTRS1 CU_PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, vce(cluster NR_PARTIDO)
est store Column2

** Run Estimations for RTRS2
jacknife: reghdfe Donation CU_RTRS2 CU_PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column3
tobit Donation CU_RTRS2 CU_PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column4

** Run Estimations for RTRS3
jacknife: reghdfe Donation CU_RTRS3 CU_PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
est store Column5
tobit Donation CU_RTRS3 CU_PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
est store Column6
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6] using Table5.doc, replace title("Table A1") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using Table5.doc


*===========================================================*
* We provide a simpler and more systematic version of the code that produces the same outcomes as above *
* Table 5: Robustness Estimation of Donation, PL Party    *        
*===========================================================* 

* Interactions with RTRS dummies
foreach r in 1 2 3 {
    gen CU_RTRS`r' = CU * RTRS`r'
    gen CU_PL_RTRS`r' = CU * PL * RTRS`r'
}

*---------------------------*
* Main Estimations (All Observations)  
*---------------------------*

* Loop over RTRS1 to RTRS3
local models ""
forval r = 1/3 {
    * PPML with fixed effects
    ppmlhdfe Donation CU_RTRS`r' CU_PL_RTRS`r' Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc ///
        Av_Soy_Prtnr Av_Soy_Dnr Female Age, ///
        a(NR_PARTIDO) vce(cluster NR_PARTIDO) sep(fe simplex) d
    est store ppml`r'
    local models `models' ppml`r'

    * Tobit with FE (dummies)
    tobit Donation CU_RTRS`r' CU_PL_RTRS`r' Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc ///
        Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
    est store tobit`r'
    local models `models' tobit`r'
}

* Export results to Word (full sample)
outreg2 [`models'] using Table5_fullsample.doc, replace ///
    title("Table 5 - Robustness on PL Party (Full Sample)") ///
    e(r2_p chi2 F) nonote ///
    addnote("Note: (1) ***, **, * indicate significance at 1%, 5%, and 10% levels respectively.", ///
            "(2) Clustered standard errors in parentheses.") 
shellout using Table5_fullsample.doc

*---------------------------*
* Robustness: Real Donations Only (Donation > 0) 
*---------------------------*

* Drop zero and missing donations
drop if missing(Donation) | Donation == 0

* Reset model list
local models ""

* Loop again for RTRS1 to RTRS3
forval r = 1/3 {
    * OLS with high-dimensional FE and jackknife standard errors
    jackknife: reghdfe Donation CU_RTRS`r' CU_PL_RTRS`r' Av_Soy_Unt Av_Soy_Wrk ///
        Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age, ///
        a(NR_PARTIDO Municipality) vce(cluster NR_PARTIDO)
    est store ols_jk`r'
    local models `models' ols_jk`r'

    * Tobit model
    tobit Donation CU_RTRS`r' CU_PL_RTRS`r' Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc ///
        Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO, ll vce(cluster NR_PARTIDO)
    est store tobit_pos`r'
    local models `models' tobit_pos`r'
}

* Export results to Word (positive donations only)
outreg2 [`models'] using Table5_posdonations.doc, replace ///
    title("Table 5 - Robustness on PL Party (Positive Donations Only)") ///
    e(r2_p chi2 F) nonote ///
    addnote("Note: (1) ***, **, * indicate significance at 1%, 5%, and 10% levels respectively.", ///
            "(2) Clustered standard errors in parentheses.") 
shellout using Table5_posdonations.doc

*---------------------------*
* End of Do-File            *
*---------------------------*
