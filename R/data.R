#' @docType data
#' @name standard_name_mappings_pairs
#' @title Standard HCES Variable Name Mappings
#' @description A data frame containing standard variable name mapping pairs for the IHS5 survey.
"standard_name_mappings_pairs" <- suppressMessages(readRDS(here::here("data", "standard_name_mappings_pairs.rds")))


#' @docType data
#' @name standard_food_list
#' @title Standard Food Names and Codes
#' @description A data frame containing food names and codes of surveys supported by this package.
"standard_food_list" <- suppressMessages(readRDS(here::here("data", "standard_food_list.rds")))


#' @docType data
#' @name non_standard_food_list
#' @title Non Standard Food Names and Codes
#' @description A data frame containing non-standard food names and codes of surveys supported by this package.
"non_standard_food_list" <- suppressMessages(readRDS(here::here("data", "non_standard_food_list.rds")))

#' @docType data
#' @name combined_food_list
#' @title Food Names and Codes Supported by this Package
#' @description A data frame containing both standard and non-standard food names and codes of surveys supported by this package.
"combined_food_list" <- suppressMessages(readRDS(here::here("data", "combined_food_list_v26072023.rds")))

#' @docType data
#' @name unit_names_n_codes_df
#' @title Food Unit Names and Unit Codes Supported by this Package
#' @description A data frame containing both standard and non-standard food unit names and unit codes of surveys supported by this package.
"unit_names_n_codes_df" <- suppressMessages(readRDS(here::here("data", "consumption_unit_matches_v4_20092023.rds")))

#' @docType data
#' @name food_list_df
#' @title Food Item Names and Codes Supported by this Package
#' @description A data frame containing both standard and non-standard food item names and codes of surveys supported by this package.
"food_list_df" <- suppressMessages(readRDS(here::here("data", "matched_food_items_and_codes_v2_0_1_26092023.rds")))
# TODO: Change the way this is handled so that the rds file is created once unlike the current situation where three files are used to create the rds file.


#' @docType data
#' @name unit_names_n_codes_df
#' @title Food Unit Names and Unit Codes Supported by this Package
#' @description A data frame containing both standard and non-standard food unit names and unit codes of surveys supported by this package.
#' @examples
#' unit_names_n_codes_df
#' @export
#' @keywords datasets
#' @format A data frame with 3 columns and 4 rows
#' \describe{
#' \item{country}{Country name}
#' \item{survey}{Survey name}
#' \item{unit_name}{Name of the food unit}
#' \item{unit_code}{Code of the food unit}
#' \entries_count{Number of survey responses with this unit name}
#' \priority{Priority of the unit name (1 being the highest)}}
"unit_names_n_codes_df" <- suppressMessages(readRDS(here::here("data", "consumption_unit_matches_v4_20092023.rds")))

#' @docType data
#' @name hh_mod_a_filt_vMAPS
#' @title Module A: Household Identification (household level data)
#' @description Randomly Generated Samaple Data Resembling Data collected through Household Questionnaire, Module A: Household Identification (household level data)
#' - This module household identifiers, the sample weights, information on household location, date of interview, supervisor and enumerator codes. Additionally, this module contains filters for subsequent modules.
#' @export 
#' @keywords datasets
#' @format A data frame 
"hh_mod_a_filt_vMAPS" <- suppressMessages(haven::read_dta(here::here("data","mwi-ihs5-sample-data","hh_mod_a_filt_vMAPS.dta")))
