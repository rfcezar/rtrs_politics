*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Table 4: Donation Across Administrative Levels          *
*===========================================================*
*--- Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear

*--- Variable Construction ---*
* Indicator for PL party
*gen PL = (SG_PARTIDO == "PL")

* Interactions with PL
gen PL_RTRS1 = PL*RTRS1
gen PL_RTRS2 = PL*RTRS2
gen PL_RTRS3 = PL*RTRS3

**** Define administrative levels
* Four administrative levels: President of the Republic and Governor, Senators, Federal Deputies, and State Deputies
gen SN=0
replace SN=1 if NR_CANDIDATO>=1 &  NR_CANDIDATO<100
replace SN=2 if NR_CANDIDATO>=100 &  NR_CANDIDATO<1000
replace SN=3 if NR_CANDIDATO>=1000 &  NR_CANDIDATO<10000
replace SN=4 if NR_CANDIDATO>=10000

* Label SN levels for easier interpretation
label define SN_lbl 1 "President/Governor" 2 "Senators" 3 "Federal Deputies" 4 "State Deputies"
label values SN SN_lbl

*===========================================================*
** Run Estimations for RSN==1
*===========================================================*
jacknife: reghdfe Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==1 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column1
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==1 , ll 
est store Column2
jacknife: reghdfe Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==1 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column3
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==1 , ll
est store Column4
jacknife: reghdfe Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==1 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column5
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==1 , ll
est store Column6
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6] using Table4.doc, replace title("Table 4: ") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using Table4.doc
*===========================================================*
** Run Estimations for RSN==2
*===========================================================*
jacknife: reghdfe Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==2 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column1
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==2 , ll 
est store Column2
jacknife: reghdfe Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==2 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column3
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==2 , ll
est store Column4
jacknife: reghdfe Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==2 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column5
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==2 , ll
est store Column6
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6] using Table4.doc, replace title("Table 4: ") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using Table4.doc
*===========================================================*
** Run Estimations for RSN==3
*===========================================================*
jacknife: reghdfe Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==3 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column1
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==3 , ll 
est store Column2
jacknife: reghdfe Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==2 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column3
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==3 , ll
est store Column4
jacknife: reghdfe Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==3 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column5
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==3 , ll
est store Column6
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6] using Table4.doc, replace title("Table 4: ") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using Table4.doc
*===========================================================*
** Run Estimations for RSN==4
*===========================================================*
jacknife: reghdfe Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==4 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column1
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS1 PL_RTRS1 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==4 , ll 
est store Column2
jacknife: reghdfe Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==4 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column3
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS2 PL_RTRS2 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==4 , ll
est store Column4
jacknife: reghdfe Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age if SN==4 , a(NR_PARTIDO) vce(cluster NR_PARTIDO)
est store Column5
bootstrap _b, reps(50) strata(NR_PARTIDO) seed(1234): tobit Donation RTRS3 PL_RTRS3 Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age i.NR_PARTIDO if SN==4 , ll
est store Column6
outreg2 [Column1 Column2 Column3 Column4 Column5 Column6] using Table4.doc, replace title("Table 4: ") e(r2_p, chi2, F) nonote addnote("Note:(1)***,**,* represent significance at 1%,5% and 10% level respectively;","(2)standard errors in parentheses.") 
shellout using Table4.doc



*===========================================================*
* We provide a simpler and more systematic version of the code that produces the same outcomes as above *
* Table 4: Donation Across Administrative Levels, PL Party    *        
*===========================================================*

*---------------------------*
*  Variable Construction  *
*---------------------------*

foreach t in 1 2 3 {
    gen PL_RTRS`t' = PL * RTRS`t'
}

* Define administrative levels
gen SN = 0
replace SN = 1 if inrange(NR_CANDIDATO, 1, 99)
replace SN = 2 if inrange(NR_CANDIDATO, 100, 999)
replace SN = 3 if inrange(NR_CANDIDATO, 1000, 9999)
replace SN = 4 if NR_CANDIDATO >= 10000

* Label SN levels for easier interpretation
label define SN_lbl 1 "President/Governor" 2 "Senators" 3 "Federal Deputies" 4 "State Deputies"
label values SN SN_lbl

*---------------------------*
* Estimation Routines    *
*---------------------------*
* Loop over SN levels
forvalues sn = 1/4 {
    display "Running regressions for administrative level SN = `sn'"

    * Loop over RTRS versions (1, 2, 3)
    forvalues t = 1/3 {
        local col = 2 * (`t' - 1) + 1   // reghdfe column
        local next = `col' + 1         // tobit column

        * REGHDFE
        quietly jackknife: reghdfe Donation RTRS`t' PL_RTRS`t' ///
            Av_Soy_Unt Av_Soy_Wrk Av_Soy_Prodc Av_Soy_Prtnr ///
            Av_Soy_Dnr Female Age if SN == `sn', ///
            absorb(NR_PARTIDO) vce(cluster NR_PARTIDO)
        est store Column`col'

        * TOBIT
        quietly bootstrap _b, reps(50) seed(1234) strata(NR_PARTIDO): ///
            tobit Donation RTRS`t' PL_RTRS`t' Av_Soy_Unt Av_Soy_Wrk ///
            Av_Soy_Prodc Av_Soy_Prtnr Av_Soy_Dnr Female Age ///
            i.NR_PARTIDO if SN == `sn', ll
        est store Column`next'
    }

    * Export results to Word
    local filename = "Table4_SN`sn'.doc"
    outreg2 [Column1 Column2 Column3 Column4 Column5 Column6] using `filename', ///
        replace title("Table 4 - Level: `: label (SN_lbl) `sn''") ///
        e(r2_p chi2 F) nonote ///
        addnote("Note: (1) ***, **, * indicate significance at 1%, 5%, and 10%, respectively;", ///
                "(2) Standard errors in parentheses.") 

    shellout using `filename'
}

*---------------------------*
* End of Script          *
*---------------------------*
display "Replication for Table 4 complete. Files saved for each administrative level."
