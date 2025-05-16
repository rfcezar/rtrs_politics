# Replication Files – Do Voluntary Sustainability Standards Change Business Elites' Political Behavior?

This repository contains the full set of replication materials for the study examining the political impacts of voluntary sustainability standards (VSS), with a focus on the RTRS (Round Table on Responsible Soy).

## Overview

The dataset was constructed to evaluate whether sustainability certification under RTRS correlates with changes in political donation behavior by Brazilian soy producers. The data construction process involved the following steps:

### 1. RTRS Certification Data (2016–2022)  
Public audit reports were scraped from the RTRS website, covering Brazilian soy farms certified between 2016 and 2022. These reports include producer names, group/farm names, municipality, and cultivated area. Individuals explicitly named were coded as directly certified.

### 2. Identification of Soy-Producing Firms and Shareholders  
Firm-level data were extracted from Brazil’s CNPJ registry using CNAE code 0115600 (soy cultivation). Each establishment’s basic CNPJ was matched with its shareholders (sócios), and individual-level metadata (name, age, municipality) were retrieved.

### 3. Ownership Network Structuring  
Each individual was matched to all CNPJs in which they had a share. Up to 25 CNPJs per person were retained in wide format. For each CNPJ, the following were computed:
- Number of shareholders
- Number of shareholders who donated to campaigns (total and by party)
- Start date
- Certification status (binary)

These metrics were then aggregated at the person level.

### 4. Integration of Political and Demographic Data  
Municipal and state-level political alignment was collected from official 2018 gubernatorial and 2020 mayoral election results (TSE). Political donations were compiled from the 2022 campaign finance records. Gender was estimated using the `genderBR` R package.

### 5. Construction of RTRS Exposure Measures  
Three distinct measures of certification exposure were created:
- **RTRS1 (Direct):** Binary indicator = 1 if individual was explicitly named in any RTRS audit report.
- **RTRS2 (Indirect):** Binary indicator = 1 if individual shared any CNPJ with someone directly certified.
- **RTRS3 (Proportional):** Continuous measure equal to the share of an individual's owned CNPJs that were certified.

---

The final dataset includes person-level records linking:
- RTRS certification exposure (direct, indirect, proportional)
- Corporate affiliation structure
- Political donations (2022, by party and candidate)
- Demographic attributes (gender, age group, municipality)
- Local political context

This structure enables empirical tests of how exposure to sustainability standards shapes political behavior in Brazil’s soy sector.

## Structure of the Repository

### 1. Data
- `RTRS_data.dta`: Main dataset used for all analyses.

### 2. Scripts (.do files for Stata)
#### Setup and Variable Description
- `0_setup.do`: Initializes environment, loads data, and sets parameters.
- `0_Variable Description.do`: Describes and summarizes variables.

#### Figures
- `Figure 2.do`, `Figure 4.do`, `Figure A1.do`: Scripts to generate figures.

#### Tables
- `Table 1.do` to `Table 5.do`, `Table A1.do`: Scripts to generate main and appendix tables.

## How to Run the Replication

1. Open Stata.
2. Set your working directory to the folder containing the files:
   ```stata
   cd "your-path-to-replication-file"
