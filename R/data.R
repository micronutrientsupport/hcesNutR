#' @docType data
#' @name standard_name_mappings_pairs
#' @title Standard HCES Variable Name Mappings
#' @description A data frame containing standard variable name mapping pairs for the IHS5 survey.
"standard_name_mappings_pairs" <- suppressMessages(readRDS(here::here("data","standard_name_mappings_pairs.rds")))


#' @docType data
#' @name standard_food_list
#' @title Standard Food Names and Codes
#' @description A data frame containing food names and codes of surveys supported by this package.
"standard_food_list" <- suppressMessages(readRDS(here::here("data","standard_food_list.rds")))


#' @docType data
#' @name non_standard_food_list
#' @title Non Standard Food Names and Codes
#' @description A data frame containing non-standard food names and codes of surveys supported by this package.
"non_standard_food_list" <- suppressMessages(readRDS(here::here("data","non_standard_food_list.rds")))

#' @docType data
#' @name combined_food_list
#' @title Food Names and Codes Supported by this Package
#' @description A data frame containing both standard and non-standard food names and codes of surveys supported by this package.
"combined_food_list" <- suppressMessages(readRDS(here::here("data","combined_food_list_v26072023.rds")))