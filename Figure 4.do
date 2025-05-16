*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Figure 4: Aggregate Donations & RTRS Holders by Party   *
*===========================================================*
*--- Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear

*-----------------------------*
* Categorize Donation Level (SN)
*-----------------------------*
* Categorize NR_CANDIDATO into 4 strata:
* SN1: National (President/Governor), SN2: Senators,
* SN3: Federal Deputies, SN4: State Deputies

gen byte SN = .
replace SN = 1 if inrange(NR_CANDIDATO, 1, 99)
replace SN = 2 if inrange(NR_CANDIDATO, 100, 999)
replace SN = 3 if inrange(NR_CANDIDATO, 1000, 9999)
replace SN = 4 if NR_CANDIDATO >= 10000

label define SNlbl 1 "SN1: National" 2 "SN2: Senators" 3 "SN3: Fed. Deputies" 4 "SN4: State Deputies"
label values SN SNlbl

*-----------------------------*
* Plot Donations by Party & SN
*-----------------------------*

foreach level in 1 2 3 4 {
    graph bar (sum) Donation if SN==`level', over(SG_PARTIDO, label(angle(45) labsize(small))) ///
        title("Donation: `: label SNlbl `level''", size(medium)) ///
        ytitle("Total Donations", size(small)) ///
        graphregion(margin(l=10 r=10)) ///
        plotregion(margin(b=5))
    graph save "fig_donation_SN`level'.gph", replace
}

* Combine donation graphs
graph combine fig_donation_SN1.gph fig_donation_SN2.gph fig_donation_SN3.gph fig_donation_SN4.gph, ///
    cols(2) iscale(0.47) ///
    title("Aggregate Donations by Party and Office Level", size(medsmall))
graph save "fig_donations_combined.gph", replace

*-----------------------------*
* Plot Certification by Party & SN
*-----------------------------*
* Variables: RTRS1 = Audited Individual, RTRS2 = Audited Property, RTRS3 = % Audited

foreach level in 1 2 3 4 {
    graph bar (sum) RTRS1 RTRS2 RTRS3 if SN==`level', over(SG_PARTIDO, label(angle(45))) ///
        bar(1, color(red)) bar(2, color(orange)) bar(3, color(purple)) ///
        title("Certification: `: label SNlbl `level''", size(medium)) ///
        ytitle("Total Certification", size(small)) ///
        legend(order(1 "Audited Individual" 2 "Audited Property" 3 "% Audited") ///
        position(16) ring(0) rows(1)) ///
        graphregion(margin(l=10 r=10))
    graph save "fig_cert_SN`level'.gph", replace
}

* Combine certification graphs
graph combine fig_cert_SN1.gph fig_cert_SN2.gph fig_cert_SN3.gph fig_cert_SN4.gph, ///
    cols(2) iscale(0.47) ///
    title("RTRS Certification by Party and Office Level", size(medsmall))
graph save "fig_certification_combined.gph", replace

*-----------------------------*
* Clean Exit
*-----------------------------*
display "Replication for Figure 4 completed successfully."
