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


#' Identify labelled variables in a data frame
#'
#' This function takes a data frame as input and returns a character vector of the names of the variables in the data frame that are labelled using the `haven` package.
#'
#' @param data A data frame to check for labelled variables.
#'
#' @return A character vector of the names of the labelled variables in the input data frame.
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
#' # Check for labelled variables
#' which_labelled(df)
#'
#'
#' @export
which_labelled <- function(data)
{
  labelled_variables <- c()
  for (x in names(data))
  {
    if (haven::is.labelled(data[[x]]))
    {
      labelled_variables <- c(labelled_variables, x)
    }
  }
  message("The following variables are labelled: Use `hcesR::split_dta()` to split the data into two separate columns.")
  return(labelled_variables)
}


#' Replace values in a column of a dataframe
#'
#' @description This function replaces values in a column of a dataframe with a new value.
#'
#' @param data The dataframe to modify.
#' @param targetColumn The name of the column to modify.
#' @param secondaryColumn The name of the column to extract values from and replace in targetColumn.
#' @param string2search The value to search. It can be the whole string or a part of it.
#'
#' @return The modified dataframe.
#'
#' @examples
#' data <- data.frame(x = c("a", "b", "c"), y = c("d", "e", "f"))
#' replace_values(data, "x", "y", "b")
replace_values <- function(data, targetColumn, secondaryColumn, string2search) {
  if (!is.data.frame(data)) {
    stop("data must be a data frame")
  }
  if (!is.character(targetColumn) || !is.character(secondaryColumn) || !is.character(string2search)) {
    stop("targetColumn, secondaryColumn, and string2search must be character strings")
  }
  if (!(targetColumn %in% names(data)) || !(secondaryColumn %in% names(data))) {
    stop("targetColumn and secondaryColumn must be valid column names in data")
  }
  data[[targetColumn]] <- ifelse(grepl(string2search, data[[targetColumn]], ignore.case=TRUE), ifelse(data[[secondaryColumn]]!= "",data[[secondaryColumn]],data[[targetColumn]]), data[[targetColumn]])
  return(data)
}


remove_unconsumed <- function(data, consCol= "consYN", consVal = "YES") {
    #' Remove unconsumed food item records
    #' @description This function removes the unconsumed food item records from the data file.
    #' @param data dataframe . The data file as a dataframe.
    #' @param consCol character . The name of the column that indicates whether the food item was consumed or not.
    #' @note the read_in_data() function should be used first to import and format the required data.
    
    message("Removing unconsumed food item records...\n")
    # Remove consYN == "NO" and consYN == "NA"
    filtered_data <- data |> dplyr::filter(!!rlang::sym(consCol) == consVal)
    # Count the number of removed records and print to console
    removed_records <- nrow(data) - nrow(filtered_data)
    cat("Unconsumed food item records removed succesfully\n")
    cat(paste0("Number of records removed : ", removed_records, "\n"))
    # Count the number of remaining records and print to screen
    remaining_records <- nrow(filtered_data)
    cat(paste0("Number of records remaining : ", remaining_records, "\n"))
    # Return the data, removed_records and remaining_records
    cat("\n...\n...\n")
    data <- filtered_data
    return(data)
}

# NOTE: This function is not currently used in the cleaning script. It is included here for future use.
create_dta_labels <- function(data) {
    #' Create labels for Stata data
    #' @description This function creates labels for all <dbl+lbl> columns in data imported from Stata data.
    #' @param data dataframe . The data file as a dataframe.
    #' @return dataframe: The data file with labels for all <dbl+lbl> columns.
    #' @note The function uses the haven package to create the labels and values columns.
    #' @note The function will only create the labels and values columns if they do not already exist. It will not overwrite existing columns.

    # Get the names of all the columns in the dataframe
    data_names <- names(data)

    # exclude columns with "label" in the name
    data_names <- data_names[!grepl("label", data_names)]

    # Loop through all the columns
    for (x in data_names) {
        # Check if the column is labelled
        if (haven::is.labelled(data[[x]])) {
            # Check if the column already has the labels and values columns
            if ("label" %in% x | paste0(x, "_code") %in% data_names) {
                # If it does, move to the next column
                next
            } else {
                # Create the column with the values
                data[[paste0(x, "_code")]] <- as.numeric(data[[x]])
                # overwrite the column with the labels
                data[[paste0(x,"_name")]] <- as.character(forcats::as_factor(data[[x]]))
                # If it doesn't, create the column with the labels
                # TODO: Decide if we want to overwrite the original column with the labels or create a new column with the labels
                # data[[paste0(x, "_label")]] <- as.character(as_factor(data[[x]]))

                # Move the labels and values columns to the right of the original column
                # data <- data |>
                #     relocate(paste0(x, "_id"), .after = x) |>
                #     relocate(paste0(x, "_label"), .after = paste0(x, "_id"))
                # TODO: Enable the option that works best between these two options
                data <- data |> dplyr::relocate(paste0(x, "_name"), .after = x)
                data <- data |> dplyr::relocate(paste0(x, "_code"), .after = x)
                data  <- data |> dplyr::select(-x)
            }
        }
    }
    return(data)
}