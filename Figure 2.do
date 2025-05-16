*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Figure 2:Total Donations and Certification by Party     *
*===========================================================*
*--- Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear

* Set the graph scheme for better aesthetics
set scheme modern
*------------------------------------------*
* Filter Relevant Observations for Plot *
*------------------------------------------*
* Keep only rows with positive, non-missing donations
drop if missing(Donation) | Donation == 0

*--------------------------------*
* Graph: Donations by Party  *
*--------------------------------*
graph bar (sum) Donation if Donation>0, ///
    over(SG_PARTIDO, label(angle(45) labsize(vsmall))) ///
    bar(1, color(blue)) ///
    title("Sum of Donations by Party") ///
    ytitle("Total Donations") ///
    legend(off) ///
    graphregion(margin(l=15 r=15)) ///
    plotregion(margin(b=0))
graph save "sum_donations.gph", replace

*-----------------------------------------------------------*
* Graph: Certification Measures (RTRS1, RTRS2, RTRS3) by Party *
*-----------------------------------------------------------*
graph bar (sum) RTRS1 RTRS2 RTRS3 if Donation>0, ///
    over(SG_PARTIDO, label(angle(45))) ///
    bar(1, color(red)) bar(2, color(orange)) bar(3, color(purple)) ///
    title("Sum of Certification Measures by Party") ///
    ytitle("Sum") ///
    legend(order(1 "Audited Individual" 2 "Audited Property" 3 "% Audited") ///
    position(16) ring(0) rows(1))
graph save "sum_certification.gph", replace

*--------------------------------*
* Combine the Two Graphs     *
*--------------------------------*
graph combine "sum_donations.gph" "sum_certification.gph", ///
    cols(1) iscale(.5)