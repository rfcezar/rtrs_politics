*=============================================================*
*  REPLICATION DO-FILE: Estimating Donation Flows - RTRS     *
*                                                             *
*  Paper Title:                                               *
*    "Do Voluntary Sustainability Standards Change            *
*     Business Elites' Political Behavior?"                   *
*                                                             *
*  Replication Package – Variable Description & Setup         *
*=============================================================*

*--- 1. Setup ---*
clear all
set more off

cd "your-working-directory-path"   // <<< Replace with your actual working directory

*--- 2. Load Dataset ---*
use RTRS_data.dta, clear

*--- 3. Variable Labels ---*

* --- Entity Information --- *
label var Donation                "Donation amount in local currency (Revenue)"
label var NR_PARTIDO              "Party number"
label var NR_CANDIDATO            "Candidate's number"
label var NM_CANDIDATO            "Candidate's full name"
label var SG_PARTIDO              "Political party acronym"

* --- RTRS Certification Measures --- *
label var RTRS1                   "Direct certification status (e.g., owns a certified farm)"
label var RTRS2                   "Extended certification status (e.g., partial certification via assets)"
label var RTRS3                   "Proportion of assets certified under RTRS"

* --- Soy Production & Workforce Variables --- *
label var Av_Soy_Wrk            "Average soy workforce in municipality"
label var Av_Soy_Prodc          "Average soy production (tons) in municipality"
label var Av_Soy_Prtnr          "Average number of soy sector partners"
label var Av_Soy_Dnr            "Average number of donors in soy sector"

* --- Trade Exposure Variables --- *
label var Av_Soy_Ex_Chn         "Average soy exports to China (USD)"
label var Av_Soy_Ex_EU          "Average soy exports to EU (USD)"

* --- Market Presence --- *
label var Av_Soy_Unt            "Average number of soy firms in municipality"
label var Soy_Municplty         "Total soy companies in municipality"

* --- Environmental Context --- *
label var CU                    "Number of conservation units in municipality"

*=============================================================*
*  End of Variable Description Section                        *
*=============================================================*
