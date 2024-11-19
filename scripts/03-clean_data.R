#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
# List of necessary packages
packages <- c("dplyr", "arrow")
# Install missing packages
missing_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
install.packages(missing_packages)
# Load packages
lapply(packages, library, character.only = TRUE)

#### Clean data ####
# Set the folder path
folder_path <- "data/01-raw_data"

# Get the list of all CSV files in the folder
csv_path <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
csv_list <- lapply(csv_path, read.csv)

# Rename columns
csv_list <- lapply(csv_list, function(file) {
  if ("ï..Trip.Id" %in% colnames(file)) {
    colnames(file)[colnames(file) == "ï..Trip.Id"] <- "trip_id"
  }
  if ("Trip..Duration" %in% colnames(file)) {
    colnames(file)[colnames(file) == "Trip..Duration"] <- "trip_duration_seconds"
  }
  if ("Start.Station.Id" %in% colnames(file)) {
    colnames(file)[colnames(file) == "Start.Station.Id"] <- "from_station_id"
  }
  if ("Start.Time" %in% colnames(file)) {
    colnames(file)[colnames(file) == "Start.Time"] <- "trip_start_time"
  }
  if ("Start.Station.Name" %in% colnames(file)) {
    colnames(file)[colnames(file) == "Start.Station.Name"] <- "from_station_name"
  }
  if ("End.Station.Id" %in% colnames(file)) {
    colnames(file)[colnames(file) == "End.Station.Id"] <- "to_station_id"
  }
  if ("End.Time" %in% colnames(file)) {
    colnames(file)[colnames(file) == "End.Time"] <- "trip_stop_time"
  }
  if ("End.Station.Name" %in% colnames(file)) {
    colnames(file)[colnames(file) == "End.Station.Name"] <- "to_station_name"
  }
  if ("Bike.Id" %in% colnames(file)) {
    colnames(file)[colnames(file) == "Bike.Id"] <- "bike_id"
  }
  if ("User.Type" %in% colnames(file)) {
    colnames(file)[colnames(file) == "User.Type"] <- "user_type"
  }
  if ("Trip.Id" %in% colnames(file)) {
    colnames(file)[colnames(file) == "Trip.Id"] <- "trip_id"
  }
  if ("Model" %in% colnames(file)) {
    colnames(file)[colnames(file) == "Model"] <- "model"
  }
  
  # Ensure all required columns exist, if not create them with NA values
  required_columns <- c("trip_id", "trip_start_time", "trip_stop_time", "trip_duration_seconds", 
                        "from_station_id", "from_station_name", "to_station_id", "to_station_name", 
                        "bike_id", "user_type", "model")
  # Ensure all required columns exist, if not create them with NA values
  missing_columns <- setdiff(required_columns, colnames(file))
  if (length(missing_columns) > 0) {
    for (col in missing_columns) {
      file[[col]] <- NA
    }
  }
  return(file)
})

# Create a new dataframe that combines all files
df_combined <- do.call(rbind, csv_list)

# 






































#### Save data ####
write_parquet(df_combined, "data/02-analysis_data/00-raw_data_combined.parquet")
