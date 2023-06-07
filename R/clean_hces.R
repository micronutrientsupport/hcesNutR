get_hces_mappings <- function(country_name, survey_name) {
    #' Get column mapping for a given country and survey
    #'
    #' @description This function returns the column mapping for a given country and survey
    #' @param country_name character The country name in ISO3 format.
    #' @param survey_name character The survey name in short form.
    #' @return dataframe: The column mapping for the given country and survey.
    #' @export

    # Extract column mappings from the internal database
    column_mapping <- hcesR::standard_name_mappings_pairs |>
        dplyr::filter(country == country_name & survey == survey_name) |>
        dplyr::filter(!is.na(hces_standard_name))

    return(column_mapping)
}