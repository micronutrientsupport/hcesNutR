get_hces_mappings <- function(country_name, survey_name) {
    #' Get column mapping for a given country and survey
    #'
    #' @description This function returns the column mapping for a given country and survey
    #' @param country_name character The country name in ISO3 format.
    #' @param survey_name character The survey name in short form.
    #' @return dataframe: The column mapping for the given country and survey.
    #' @export

    # Extract column mappings from the internal database
    column_mapping <- hcesNutR::standard_name_mappings_pairs |>
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

# TODO: Add external csv support
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
    column_mapping <- hcesNutR::get_hces_mappings(country_name,survey_name) |>
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
    data <- hcesNutR::check_hces_names(data, original_data_df)

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
  message("The following variables are labelled: Use `hcesNutR::split_dta()` to split the data into two separate columns.")
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
    data <- filtered_data |> dplyr::select(-!!rlang::sym(consCol))
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

# NOTE: All function above where developed before the ANH2023 conference. The functions below were developed after the conference.

#' Concatenate values in multiple columns into a single column
#'
#' This function concatenates the values in multiple columns of a data frame into a single column. It filters out blank, NA, and excluded values before concatenating the remaining values with a space in between. 
#' It also removes parenthesis and extra spaces from the concatenated string, unless specified otherwise.
#'
#' @param data A data frame containing the columns to concatenate
#' @param columns A character vector of column names to concatenate
#' @param exclude_value A character vector of strings to exclude from the concatenated values
#' @param new_column_name A character string of the name of the new column to create. This column can be one of the existing columns used to concatenate.
#' @param keep_parenthesis A boolean indicating whether to keep parenthesis in the concatenated string (default is TRUE)
#'
#' @return A modified data frame with a new column containing the concatenated values
#'
#' @examples
#' # Concatenate consumption unit columns in IHS5 data
#' hces_data <- data.frame(
#' food_item_code = c(101, 102, 103, 104),
#' cons_unit_name = c("OTHER (SPECIFY)", "BASIN", "PIECE", "OTHER (SPECIFY)"),
#' cons_unit_oth = c("HEAP", NA, "Soy", "TUBE"),
#' cons_unit_size_name = c("SMALL", "HEAPED", NA, "LARGE")
#' )
#'
#' # Concatenate food item columns in HCES data
#' hces_data <- concatenate_columns(data = hces_data, columns = c("cons_unit_name", "cons_unit_oth","cons_unit_size_name"), exclude_value = c("SPECIFY", "OTHER"), new_column_name="survey_food_item", keep_parenthesis = FALSE)
#'
#' @import stringr
#' @importFrom dplyr select mutate
#' @importFrom haven read_dta
#' @importFrom readr read_csv
#' @importFrom here here
#' @export
concatenate_columns <- function(data, columns, exclude_value, new_column_name, keep_parenthesis = TRUE) {
    # Check if all input columns exist
    if (!all(columns %in% names(data))) {
        stop("One or more input columns do not exist in the data frame.")
    }
    # Define a function to concatenate the values in a row
    concatenate_row <- function(row) {
        # Filter out blank, NA, and excluded values
        filtered_values <- row[!is.na(row) & row != "" & !grepl(paste(exclude_value, collapse = "|"), row, ignore.case = TRUE)]
        # Concatenate the filtered values with a space in between
        concatenated_string <- paste(filtered_values, collapse = " ")
        # Add spaces before "("
        concatenated_string <- gsub("\\(", " (", concatenated_string)
        # Add a . after NO if it is a whole word (i.e. not part of another word) and not already follwed by a . Ignore case.
        concatenated_string <- gsub("\\bNO\\b", "NO.", concatenated_string, ignore.case = TRUE)
        # Remove parenthesis and extra spaces, if specified
        if (!keep_parenthesis) {
          # Remove all parenthesis
          concatenated_string <- gsub("\\(|\\)", " ", concatenated_string)
        }
        # Remove extra spaces
        concatenated_string <- gsub("\\s+", " ", concatenated_string)
        # Return the concatenated string
        return(concatenated_string)
    }
    # Apply the concatenate_row function to each row of the specified columns
    concatenated_values <- apply(data[, columns], 1, concatenate_row)
    # Drop the specified columns from the data frame
    data <- data |> dplyr::select(-columns)
    # Assign the concatenated values to a new column in the data frame
    data[[new_column_name]] <- stringr::str_to_upper(concatenated_values)
    # Return the modified data frame
    return(data)
}


#' Match food names in a dataset to an internal standard food list
#'
#' This function matches food names in a dataset to a standard food list based on the closest string distance match. It then appends the food item code, standard food name, source and match confidence level to the dataset.
#'
#' @param data A data frame containing the food names to be matched.
#' @param country A character string specifying the country for which the food list should be generated.
#' @param survey A character string specifying the survey for which the food list should be generated.
#' @param food_name_col A character string specifying the name of the column in \code{data} that contains the food names to be matched.
#' @param match_confidence A numeric value specifying the minimum match confidence level required for a match to be considered valid. Defaults to 90.
#'
#' @return A data frame with the following columns:
#' \item{food_item_code}{A character string containing the standard food item code for the matched food item.}
#' \item{standard_original_food_name}{A character string containing the standard food name for the matched food item.}
#' \item{food_match_source}{A character string containing the source of the matched food item.}
#' \item{food_match_confidence}{A numeric value containing the match confidence level for the matched food item.}
#'
#' @importFrom dplyr filter mutate select slice_min ungroup group_by left_join
#' @importFrom stringdist stringdistmatrix
#' @importFrom tidyselect sym
#' @import hcesNutR
#'
#' @examples
#' data <- data.frame(food_name = c("EGGS", "SALT", "PUPWE"))
#' match_food_names(data, "MWI, "IHS5", "food_name",99)
#'
#' @export
match_food_names_v1 <- function(data, country, survey, food_name_col, match_confidence = 90) {
  # Create a food list of food items corresponding to the selected country.
  # Include only items with standard_original_food_name.
  food_list <- hcesNutR::combined_food_list |>
    dplyr::filter(country == country, survey == survey) |>
    dplyr::filter(!is.na(standard_original_food_name))

  # Initialise the food_item_code, standard_original_food_name and match_source columns
  data$standard_original_food_name <- NA
  data$food_item_code <- NA
  data$food_match_source <- NA
  data$food_match_confidence <- NA

  # Cycle through each unique food item in data and find the closest match in the internal food_list generated above.
  for(i in dplyr::pull(unique(data[food_name_col]))){
    # Calculate the string distances between the target character and each element in the vector
    string_distances <- stringdist::stringdistmatrix(toupper(i), toupper(food_list$survey_food_item_name))

    # Calculate the match confidence
    match_confidence_level <- round((1 - min(string_distances) / max(string_distances))*100,2)

    # If the closest match is below the match_confidence threshold, then add the food_item_code to data
    if(match_confidence_level >= match_confidence){
      # Add the food_item_code to data
      data$food_item_code[data[food_name_col] == i] <- food_list$standard_original_food_id[which.min(string_distances)]

      # Add standard_original_food_name to data
      data$standard_original_food_name[data[food_name_col] == i] <- food_list$standard_original_food_name[which.min(string_distances)]

      # Add source to data
      data$food_match_source[data[food_name_col] == i] <- food_list$source[which.min(string_distances)]

      # Add match confidence to data
      data$food_match_confidence[data[food_name_col] == i] <- match_confidence_level
    }else{
      # Add the food_item_code to data
      data$food_item_code[data[food_name_col] == i] <- "NO MATCH"

      # Add standard_original_food_name to data
      data$standard_original_food_name[data[food_name_col] == i] <- "NO MATCH"

      # Add source to data
      data$food_match_source[data[food_name_col] == i] <- "NO MATCH"

        # Add match confidence to data. This will allows users to adjust the match_confidence threshold to see if there are any matches that are just below the threshold.
      data$food_match_confidence[data[food_name_col] == i] <- match_confidence_level
    }
  }
  return(data)
}

#' Remove special characters from a column in a dataframe
#' @description This function removes special characters from a specified column in a dataframe. It also adds a period after 'NO' if it is a whole word and not already followed by a period.
#' @param data dataframe. The dataframe to modify.
#' @param column character. The name of the column to modify.
#' @param keep_parenthesis logical. If TRUE, parenthesis are kept in the column. If FALSE, parenthesis are removed. Default is TRUE.
#' @return dataframe. The modified dataframe.
#' @examples
#' data <- data.frame(x = c("NO", "YES (maybe)", "NO (definitely)"))
#' remove_spec_char_v1(data, "x", FALSE)
#' @export
remove_spec_char_v1 <- function(data, column, keep_parenthesis = TRUE) {
    # Check if the input column exists
    if (!column %in% names(data)) {
        stop("The input column does not exist in the data frame.")
    }
    # Define a function to process the values in a column
    process_column <- function(col) {
        
        # Add a . after NO if it is a whole word (i.e. not part of another word) and not already followed by a . Ignore case.
        processed_string <- gsub("\\bNO\\b", "NO.", col, ignore.case = TRUE)
        # Remove extra periods
        processed_string <- gsub("(\\.)\\1+", ".", processed_string)
        # Remove parenthesis and extra spaces, if specified
        if (!keep_parenthesis) {
          # Replace all opening parenthesis with -
          processed_string <- gsub("\\(", "-", processed_string)

          # Replace all closing parenthesis with " "
          processed_string <- gsub("\\)", " ", processed_string)

          # processed_string <- gsub("\\(|\\)", " ", processed_string)
        }
        # Remove all extra spaces
        processed_string <- gsub("\\s+", " ", processed_string)

        # Remove spaces at the end of the string
        processed_string <- gsub("\\s+$", "", processed_string)

        # Upper case the string
        processed_string <- stringr::str_to_upper(processed_string)

        # Return the processed string
        return(processed_string)
    }
    # Apply the process_column function to the specified column
    data[[column]] <- sapply(data[[column]], process_column)
    # Return the modified data frame
    return(data)
}

#' Assign unit codes to a data frame based on a unit codes CSV file
#'
#' This function assigns unit codes to a data frame based on a unit codes CSV file. 
#' The CSV file must contain a column with unit names and a column with corresponding unit codes.
#' The function removes special characters from the unit names before matching them to the data frame.
#' 
#' @param data A data frame to modify.
#' @param country A character string specifying the country of the data.
#' @param survey A character string specifying the survey of the data.
#' @param unit_codes_csv A character string specifying the file path of the unit codes CSV file.
#' If NULL, the internal data hcesNutR::unit_codes will be used.
#' @param unit_code_col A character string specifying the name of the column in the data frame to store the unit codes.
#' @param unit_name_col A character string specifying the name of the column in the data frame to match the unit names.
#' @return A modified data frame with unit codes assigned.
#' @examples
#' @export
match_unit_names_v1 <- function(data, country, survey, unit_code_col, unit_name_col,unit_codes_csv=NULL) {
    # Import csv file from parameters and check if the unit_name and unit_code columns exists, else throw an error.
    
    # If no unit_codes_csv file is passed, use the internal data
    if (is.null(unit_codes_csv)) {
        unit_codes_df <- hcesNutR::unit_names_n_codes_df |> dplyr::filter(country == country, survey == survey)
    } else {
        # Import the unit_codes_csv file
        unit_codes_df <- readr::read_csv(unit_codes_csv)
        if (!("unit_name" %in% colnames(unit_codes_df))) {
            stop("unit_name column does not exist in the unit_codes_csv file.")
        }
        if (!("unit_code" %in% colnames(unit_codes_df))) {
            stop("unit_code column does not exist in the unit_codes_csv file.")
        }
        # Remove special characters from the unit_name column
        unit_codes_df <- remove_spec_char(unit_codes_df, "unit_name", FALSE)
    }
    
    # Assign unit codes to the data
    for (i in 1:nrow(unit_codes_df)) {
        row <- unit_codes_df[i, ]
        data[[unit_code_col]][data[[unit_name_col]] == row$unit_name] <- row$unit_code
    }
    return(data)
}

#' Create a measure ID column based on selected columns
#'
#' This function creates a measure ID column in a data frame based on selected columns. 
#' The measure ID is a string that concatenates the values of the selected columns with hyphens.
#' The measure ID can optionally include the country and survey strings.
#' 
#' @param data A data frame to modify.
#' @param country A character string specifying the country of the data.
#' @param survey A character string specifying the survey of the data.
#' @param cols A character vector specifying the names of the columns to include in the measure ID.
#' @param include_ISOs A logical value indicating whether to include the country and survey strings in the measure ID.
#' @return A modified data frame with a measure ID column added.
#' @examples
#' data <- data.frame(unit_name = c("kg", "g", "lb", "oz"), unit_code = c("KGM", "GRM", "LBR", "ONZ"), region = c("A", "B", "C", "D"))
#' create_measure_id(data, "USA", "NHANES", c("unit_name", "unit_code", "region"), TRUE)
#' @export
create_measure_id <- function(data, country, survey, cols, include_ISOs = FALSE) {
    # Create a measure ID column
    if(include_ISOs) {
        data <- data |> dplyr::mutate(measure_id = paste0(country, "-", survey, "-", do.call(paste, c(data[, cols], sep = "-"))))
    } else {
        data <- data |> dplyr::mutate(measure_id = (do.call(paste, c(data[, cols], sep = "-"))))
    }
    return(data)
}


#' Match food names to a standard list of food items
#'
#' This function matches food names to a standard list of food items and returns a data frame with the matched food names and codes. The function can use an internal food list or a user-provided food list to perform the matching. The function also provides diagnostics on the number of rows with no matches found and the list of foods with no matches found.
#'
#' @param data A data frame containing the food names and codes to be matched.
#' @param country A character string specifying the country for which the food items should be matched.
#' @param survey A character string specifying the survey for which the food items should be matched.
#' @param food_name_col A character string specifying the name of the column in \code{data} containing the food names.
#' @param food_code_col A character string specifying the name of the column in \code{data} containing the food codes.
#' @param matches_csv A character string specifying the path to a user-provided CSV file containing the food list to be used for matching. If \code{NULL}, the function uses an internal food list.
#' @param overwrite A logical value indicating whether to overwrite the original food name and code columns in \code{data} with the matched food names and codes. If \code{TRUE}, the original columns are overwritten. If \code{FALSE}, new columns are created for the matched food names and codes.
#'
#' @return A data frame with the matched food names and codes.
#'
#' @examples
#' \dontrun{
#' # Load the MWI data
#' data("mwi_data", package = "hcesNutR")
#'
#' # Match the food names to the standard list of food items
#' matched_data <- match_food_names_v2(data = mwi_data, 
#'                                     country = "MWI", 
#'                                     survey = "IHS5", 
#'                                     food_name_col = "food_item_name", 
#'                                     food_code_col = "food_item_code")
#' }
#'
#' @importFrom dplyr filter distinct arrange relocate pull
#' @importFrom here here
#' @importFrom hcesNutR food_list_df
#' @importFrom readr read_csv
#' @importFrom utils head
#' @importFrom crayon red
#' @importFrom stats round
#' @importFrom base sum nrow is.na stop
#' @importFrom base %in%
#'
#' @export
#' @aliases match_food_names_v2
match_food_names_v2 <- function(data, country, survey, food_name_col, food_code_col, matches_csv = NULL, overwrite = FALSE) {
    # Create a food list of food items corresponding to the selected country.
    # Include only items with standard_original_food_name.
    # Check if the food_name_col and food_code_col are in the data. Throw error and stop processing if not.
    if (!(food_name_col %in% names(data))) {
        stop("food_name_col not in data")
    }
    if (!(food_code_col %in% names(data))) {
        stop("food_code_col not in data")
    }
    # Check if country and survey are supported by the package. If not suggest that they use their own csv file for the matches.
    if (is.null(matches_csv)) {
        if (!(country %in% hcesNutR::food_list_df$country)) {
            stop("Country not supported by the package. Please use your own csv file for the matches.")
        }
        if (!(survey %in% hcesNutR::food_list_df$survey)) {
            stop("Survey not supported by the package. Please use your own csv file for the matches.")
        }
        # Use internal food list
        food_list <- hcesNutR::food_list_df |>
            dplyr::filter(country == country, survey == survey) |>
            # Remove any rows with NA in standard_original_food_name
            dplyr::filter(!is.na(standard_food_name))
    } else {
        # Use user provided food list and check that it has the required columns
        food_list <- read_csv(matches_csv)
        if (!("standard_food_name" %in% names(food_list))) {
            stop("standard_food_name not in food_list")
        }
        if (!("standard_food_code" %in% names(food_list))) {
            stop("standard_food_code not in food_list")
        }
        if (!("item_code_name" %in% names(food_list))) {
            stop("item_code_name not in food_list")
        }
        if (!("source" %in% names(food_list))) {
            stop("source not in food_list")
        }
    }

    if (overwrite) {
        # Create column to store source
        data <- data |> dplyr::mutate(food_match_source = "NO-MATCH") 
        # Rename the columns to be overwriten
        data <- data |> dplyr::rename(matched_food_name = {{food_name_col}}, matched_food_code = {{food_code_col}})

        # Assing the new columns to the original column names for downstream processing
        food_name_col <- "matched_food_name"
        food_code_col <- "matched_food_code"

        # Move the original columns to after hhid for easy diagnostics
        data <- data |> dplyr::relocate(food_code_col, .after = hhid)
        data <- data |> dplyr::relocate(food_name_col, .after = food_code_col)
        data <- data |> dplyr::relocate(cons_unit_name, .after = food_name_col)

        # Move the new columns to after the ones they are replacing for easy diagnostics
        data <- data |> dplyr::relocate(matched_food_name, .after = food_name_col) 
        data <- data |> dplyr::relocate(matched_food_code, .after = food_code_col) 
        data <- data |> dplyr::relocate(food_match_source, .after = matched_food_name)

        # perform matches
        for (i in dplyr::pull(unique(data[food_name_col]))) {
            if (i %in% (unique(food_list$item_code_name))) {
                # Add the food_item_code to data
                data$matched_food_code[data[food_name_col] == i] <- food_list$standard_food_code[food_list$item_code_name == i]

                # Add standard_original_food_name to data
                data$matched_food_name[data[food_name_col] == i] <- food_list$standard_food_name[food_list$item_code_name == i]

                # Add source to data
                data$food_match_source[data[food_name_col] == i] <- food_list$source[food_list$item_code_name == i]
            }
        }
    } else {
        # Initialise the food_item_code, standard_original_food_name and match_source columns
        data$matched_food_name <- NA_character_
        data$matched_food_code <- NA_character_
        data$food_match_source <- "NO-MATCH"

        # Move the original columns to after hhid for easy diagnostics
        data <- data |> dplyr::relocate(food_code_col, .after = hhid)
        data <- data |> dplyr::relocate(food_name_col, .after = food_code_col)
        data <- data |> dplyr::relocate(cons_unit_name, .after = food_name_col)

        # Move the new columns to after the ones they are replacing for easy diagnostics
        data <- data |> dplyr::relocate(matched_food_name, .after = food_name_col) 
        data <- data |> dplyr::relocate(matched_food_code, .after = food_code_col) 
        data <- data |> dplyr::relocate(food_match_source, .after = matched_food_name)

        # Cycle through each unique food item in data and find the closest match in the internal food_list generated above.
        for (i in dplyr::pull(unique(data[food_name_col]))) {
            if (i %in% (unique(food_list$item_code_name))) {
                # Add the food_item_code to data
                data$matched_food_code[data[food_name_col] == i] <- food_list$standard_food_code[food_list$item_code_name == i]

                # Add standard_original_food_name to data
                data$matched_food_name[data[food_name_col] == i] <- food_list$standard_food_name[food_list$item_code_name == i]

                # Add source to data
                data$food_match_source[data[food_name_col] == i] <- food_list$source[food_list$item_code_name == i]
            }
        }
    }
    # Print to the console the number of rows with no match found
    cat(crayon::red(paste0("\n There are ",
    sum(data$food_match_source == "NO-MATCH"), 
    " out of ", nrow(data), 
    " rows, which represents ", 
    round(sum(data$food_match_source == "NO-MATCH")/nrow(data)*100, 2), 
    "% of the data. The missing values are shown in the pop up view: \n")))

    data |> dplyr::filter(food_match_source == "NO-MATCH") |> dplyr::select({{food_name_col}}, {{food_code_col}}) |> dplyr::distinct() |> dplyr::arrange({{food_name_col}}) |> View()

    return(data)
}


#' Remove special characters and spaces from a string vector and capitalize the result
#'
#' This function takes a vector of strings as input, removes all special characters and spaces from each string, and returns a new vector of strings where each string is collapsed into one string and capitalized.
#'
#' @param str_vec A vector of strings to be processed
#'
#' @return A vector of strings where each string is collapsed into one string and capitalized
#'
#' @examples
#' rm_special_chars_v2(c("PACKET (LARGE)", "BAG (SMALL)", "BOX (MEDIUM)"))
#'
#' @export
#' @importFrom stringr str_to_upper
#' @importFrom base gsub
rm_special_chars_v2 <- function(str_vec) {
  # Remove special characters and spaces
  str_vec <- gsub("[^[:alnum:]]", "", str_vec)
  # Collapse into one string and capitalize
  str_vec <- sapply(str_vec, function(x) toupper(paste(x, collapse = "")))
  return(str_vec)
}

#' Match food units to a standard list of units
#'
#' This function matches food units in a data frame to a standard list of units.
#' The function creates a unit key column in the data frame and uses it to match
#' the food units to the standard list of units. The function can use an internal
#' list of units or a user-provided list of units. The function can overwrite the
#' original columns with the matched columns or create new columns for the matched
#' units. The function returns the data frame with the matched units and a column
#' indicating the source of the match.
#'
#' @param data A data frame containing the food units to be matched.
#' @param country A character string indicating the country for which the food units are being matched.
#' @param survey A character string indicating the survey for which the food units are being matched.
#' @param unit_name_col A character string indicating the name of the column containing the food unit names in the data frame.
#' @param unit_code_col A character string indicating the name of the column containing the food unit codes in the data frame.
#' @param matches_csv A character string indicating the path to a CSV file containing the standard list of units. If NULL, the function uses an internal list of units.
#' @param overwrite A logical value indicating whether to overwrite the original columns with the matched columns (TRUE) or create new columns for the matched units (FALSE).
#'
#' @return A data frame with the matched units and a column indicating the source of the match.
#'
#' @examples
#' # Match food units in a data frame to a standard list of units
#' data <- data.frame(food = c("apple", "banana", "orange"), unit = c("kg", "lb", "g"))
#' match_food_units_v2(data, "MWI", "IHS5", "food", "unit")
#'
#' @importFrom dplyr mutate filter select distinct arrange
#' @importFrom readr read_csv
#' @importFrom crayon red
#' @importFrom rlang sym
#' @importFrom utils View
match_food_units_v2 <- function(data, country, survey, unit_name_col, unit_code_col, matches_csv = NULL, overwrite = FALSE){
  # Check if the unit_name_col and unit_code_col are in the data. Throw error and stop processing if not.
  if (!(unit_name_col %in% names(data))) {
    stop("unit_name_col not in data")
  }
  if (!(unit_code_col %in% names(data))) {
    stop("unit_code_col not in data")
  }

  # Check if country and survey are supported by the package. If not suggest that they use their own csv file for the matches.
  if (is.null(matches_csv)) {
    if (!(country %in% hcesNutR::unit_names_n_codes_df$country)) {
      stop("Country not supported by the package. Please use your own csv file for the matches.")
    }
    if (!(survey %in% hcesNutR::unit_names_n_codes_df$survey)) {
      stop("Survey not supported by the package. Please use your own csv file for the matches.")
    }
    # Use internal food list
    unit_list <- hcesNutR::unit_names_n_codes_df |>
      dplyr::filter(country == country, survey == survey) |>
      # Remove any rows with NA in standard_original_food_name
      dplyr::filter(!is.na(unit_code)) |>
      # Create a unit_key column to be used for matching
      dplyr::mutate(unit_key = rm_special_chars_v2(unit_name)) |>
      # Remove duplicate unit keys
      dplyr::distinct(unit_key, .keep_all = TRUE)
  } else {
    # Use user provided food list and check that it has the required columns
    unit_list <- read_csv(matches_csv)
    if (!("unit_name" %in% names(unit_list))) {
      stop("unit_name not in food_list")
    }
    if (!("unit_code" %in% names(unit_list))) {
      stop("unit_code not in food_list")
    }
  }

  # Create unit key column in the data
  data <- dplyr::mutate(data,unit_key = rm_special_chars_v2(!!rlang::sym(unit_name_col)))

  # Assign the unit_key column to a variable
  unit_key <- "unit_key"

  if (overwrite) {
    # Create column to store source
    data[[paste0(unit_code_col, "_source")]] <- "NO-MATCH"

    # Rename the columns to be overwriten
    names(data)[names(data) == unit_name_col] <- paste0("matched_", unit_name_col)
    names(data)[names(data) == unit_code_col] <- paste0("matched_", unit_code_col)

    # Assing the new columns to the original column names for downstream processing
    unit_code_source_col <- paste0(unit_code_col,"_source")
    unit_name_col <- paste0("matched_",unit_name_col)
    unit_code_col <- paste0("matched_",unit_code_col)

    # Perform matches
    for (i in (unique(data$unit_key))) {
      if (i %in% (unique(unit_list$unit_key))) {
        # Make sure that data[unit_code_col] is a character vector
        data[[unit_code_col]] <- as.character(data[[unit_code_col]])
        # Add the matched food item name to data
        data[unit_code_col][data[unit_key] == i] <- unit_list$unit_code[unit_list$unit_key == i]

        # Add source to data
        data[unit_code_source_col][data[unit_key] == i] <- as.character(unit_list$priority[unit_list$unit_key == i])
      }
    }
  } else {
    # Initialise the food_item_code, standard_original_food_name and match_source columns
    unit_code_source_col <- paste0(unit_code_col,"_source")
    unit_name_col_new <- paste0("matched_",unit_name_col)
    unit_code_col_new <- paste0("matched_",unit_code_col)

    data[unit_name_col_new] <- NA_character_
    data[unit_code_col_new] <- NA_character_
    data[unit_code_source_col] <- "NO-MATCH"

    # Cycle through each unique food item in data and find the closest match in the internal food_list generated above.
    for (i in (unique(data$unit_key))) {
      if (i %in% (unique(unit_list$unit_key))) {
        # Add the matched food item name to data
        data[unit_name_col_new][data[unit_key] == i] <- unit_list$unit_name[unit_list$unit_key == i]
        # Add the matched food item code to data
        data[unit_code_col_new][data[unit_key] == i] <- unit_list$unit_code[unit_list$unit_key == i]
        # Add source to data
        data[unit_code_source_col][data[unit_key] == i] <- as.character(unit_list$priority[unit_list$unit_key == i])
      }
    }
  }

  # Print to the console the number of rows with no match found
  cat(crayon::red(paste0("\n There are ",
    sum(data[unit_code_source_col] == "NO-MATCH"), 
    " out of ", nrow(data), 
    " rows with unmatched units, which represents ", 
    round(sum(data[unit_code_source_col] == "NO-MATCH")/nrow(data)*100, 2), 
    "% of the data. The missing values are shown in the pop up view: \n")))

  # Drop unit_key column from the data
  data <- dplyr::select(data, -unit_key)

  # Return the data frame with the matched units and a column indicating the source of the match
  return(data)
}