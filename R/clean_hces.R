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

rename_hces <- function(data,country_name,survey_name) {
    #' Rename data columns in HCES data
    #'
    #' @description This function renames the columns in the hces data file to the standard MAPS column names.
    #' @param data dataframe . The data file as a dataframe.
    #' @param column_mapping dataframe . The column mapping file as a dataframe.
    #' @note the read_in_data() function should be used first to import and format the required data.
    #' @return dataframe: The data file with renamed columns.
    #' @export

    # Extraxt column mappings from the internal database
    column_mapping <- hcesR::get_hces_mappings(country_name,survey_name) |>
        # Remove rows with no standard name
        dplyr::filter(hces_standard_name != "") |>
        # Remove rows with no survey variable name in the original data
        dplyr::filter(survey_variable_names %in% colnames(data))

    # Create a copy of the data
    original_data_df <- data

    for (i in 1:nrow(column_mapping)) {
        data <- dplyr::rename(data, !!rlang::sym(column_mapping$hces_standard_name[i]) := !!rlang::sym(column_mapping$survey_variable_names[i]))
    }

    # Check for columns that have been renamed
    data <- hcesR::check_hces_names(data, original_data_df)

    return(data)
}

#' Split a labelled variable into two new variables
#'
#' This function splits a labelled variable into two new variables: one containing
#' the numeric values and one containing the character labels. The new variables
#' are added to the input data frame and the original variable is dropped by default.
#'
#' @param data A data frame containing the input variable.
#' @param split_var A character string specifying the name of labelled the input variable to split.
#' @param val_to A character string specifying the name of the new variable to contain the numeric values.
#' @param lab_to A character string specifying the name of the new variable to contain the character labels.
#' @param drop_split_var A logical value indicating whether to drop the original variable (default is TRUE).
#'
#' @return A data frame with the new variables added and the original variable dropped (if specified).
#'
#' @examples
#' library(haven)
# Create dummy data frame
#' df <- data.frame(
#'   HHID = c(rep("hh01",5),rep("hh02",5)),
#'   food_item = (rep(101:105,2)),
#'   consYN = sample(1:2,10,replace = TRUE)
#' ) 
#' 
#' # Add value labels
#' df$food_item <- labelled(df$food_item, c("maize" = 101, "wheat" = 102, "rice" = 103, "meat" = 104, "fish" = 105))
#' df$consYN <- labelled(df$consYN, c("Yes" = 1, "No" = 2))
#' 
#' # Print data frame
#' df
#' 
#' # Split the food_item column into two new columns
#' split_dta(df, "food_item", "food_item_id", "food_item_lab")
#'
split_dta <- function(data, split_var, val_to, lab_to, drop_split_var = TRUE) {
  if (!is.data.frame(data)) {
    stop("Input data is not a data frame.")
  }
  if (!is.character(split_var) || !is.character(val_to) || !is.character(lab_to)) {
    stop("Input variable names must be character strings.")
  }
  if (!split_var %in% names(data)) {
    stop("Split variable not found in data.")
  }
  if (haven::is.labelled(data[[split_var]])) {
    data[[val_to]] <- as.numeric(data[[split_var]])
    data[[lab_to]] <- as.character(forcats::as_factor(data[[split_var]]))
    message("Variable ", split_var, " has been split into ", val_to, " and ", lab_to, ".")
    if (drop_split_var) {
      data <- data |> dplyr::select(-!!rlang::sym(split_var))
      message("Variable ", split_var, " has been dropped.")
    }
    # if (split_var != lab_to) {
    #   data <- data |> dplyr::relocate(val_to, .before = split_var)
    #   data <- data |> dplyr::relocate(lab_to, .after = val_to)
    # }
  } else {
    message("Variable ", split_var, " is not labelled.")
  }
  return(data)
}
