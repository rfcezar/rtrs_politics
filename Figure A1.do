*===========================================================*
*   REPLICATION DO-FILE: Estimating Donation Flows - RTRS   *
*   Paper: Do voluntary sustainability standards change     *
*          business elites' political behavior?             *
*   Figure A1 – Distribution of Donations                   *
*            - Panel (a): Donation > 0                      *
*            - Panel (b): Donation ≥ 0                      *

*===========================================================*
*--- Load Data ---*
clear all
set more off
cd "your-working-directory-path"  // Update this line with your actual working directory
sysuse RTRS_data.dta, clear


* Panel (a): Distribution of strictly positive donations
histogram Donation if Donation > 0, ///
    frequency ///
    normal ///
    bin(30) ///
    title("Figure A1(a): Distribution of Donation > 0") ///
    subtitle("With normal density overlay") ///
    xtitle("Donation Amount") ///
    ytitle("Frequency") ///
    graphregion(color(white)) ///
    saving("figA1a_donation_gt0.gph", replace)

* Panel (b): Distribution including zero donations
histogram Donation, ///
    frequency ///
    normal ///
    bin(30) ///
    title("Figure A1(b): Distribution of Donation ≥ 0") ///
    subtitle("With normal density overlay") ///
    xtitle("Donation Amount") ///
    ytitle("Frequency") ///
    graphregion(color(white)) ///
    saving("figA1b_donation_gte0.gph", replace)

* Combine the Two Graphs     *
*--------------------------------*
graph combine "figA1a_donation_gt0.gph" "figA1b_donation_gte0.gph", ///
    cols(1) iscale(.5)
