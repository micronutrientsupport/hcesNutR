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
check_hces_names <- function(data, original_data_df) {
    #' Compare column names in HCES data
    #'
    #' @description This function compares the column names in the hces data file to the standard MAPS column names. It print the changes to the console.
    #' @param data dataframe . The data file as a dataframe.
    #' @param original_data_df dataframe . The original data file as a dataframe.
    #' @return dataframe: The data file with renamed columns, converted data types and a table of the changes to the console.
    #' @export
    #' 
    # Load original column names into a dataframe
    original_colnames <- colnames(original_data_df)

    # Load renamed column names into a dataframe
    renamed_colnames <- colnames(data)

    # Check for columns that have been renamed
    changed_cols <- setdiff(renamed_colnames, original_colnames)

    # Print the changes to the console
    if (length(changed_cols) > 0) {
        changes_df <- data.frame(hces_standard_name = NULL, survey_variable_names = NULL)
        for (i in 1:length(changed_cols)) {
            changes_df <- rbind(changes_df, data.frame(hces_standard_name = changed_cols[i], survey_variable_names = original_colnames[match(changed_cols[i], renamed_colnames)]))
        }
        message(cat("\n...\nThe following columns were renamed: \n"))
        print(changes_df)
    } else {
        message(cat("No columns were renamed."))
    }
    return(data)
}
