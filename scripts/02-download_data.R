#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
# List of necessary packages
packages <- c("opendatatoronto", "dplyr", "stringr")
# Install missing packages
missing_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
install.packages(missing_packages)
# Load packages
lapply(packages, library, character.only = TRUE)

#### Download data ####
resources_url <- "https://open.toronto.ca/dataset/bike-share-toronto-ridership-data/"

data_2017 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2017") %>%
  get_resource() 
data_2018 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2018") %>%
  get_resource()
data_2019 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2019") %>%
  get_resource()
data_2020 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2020") %>%
  get_resource()
data_2021 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2021") %>%
  get_resource()
data_2022 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2022") %>%
  get_resource()
data_2023 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2023") %>%
  get_resource()
data_2024 <- list_package_resources(resources_url) %>%
  filter(name == "bikeshare-ridership-2024") %>%
  get_resource()

# Delete all non-data-frame format files
data_2022 <- data_2022[!names(data_2022) %in% c("Bike share ridership 2022-11.zip")]
data_2017 <- data_2017[-1]
data_2018 <- data_2018[-1]

#### Save data ####
# Handling irregular file formats
download.file("https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7e876c24-177c-4605-9cef-e50dd74c617f/resource/db10a7b1-2702-481c-b7f0-0c67070104bb/download/bikeshare-ridership-2022.zip", 
              "data/01-raw_data/zip_2022.zip")
unzip("data/01-raw_data/zip_2022.zip", exdir = "data/01-raw_data/")
unzip("data/01-raw_data/bikeshare-ridership-2022/Bike share ridership 2022-11.zip", exdir = "data/01-raw_data/")
file.remove("data/01-raw_data/zip_2022.zip")
unlink("data/01-raw_data/bikeshare-ridership-2022", recursive = TRUE)

# Save files in a right format
for (i in seq_along(data_2017)) {
  filename <- names(data_2017)[i]
  write.csv(data_2017[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}
for (i in seq_along(data_2018)) {
  filename <- names(data_2018)[i]
  write.csv(data_2018[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}
for (i in seq_along(data_2019)) {
  filename <- names(data_2019)[i]
  write.csv(data_2019[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}
for (i in seq_along(data_2020)) {
  filename <- names(data_2020)[i]
  write.csv(data_2020[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}
for (i in seq_along(data_2021)) {
  filename <- names(data_2021)[i]
  write.csv(data_2021[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}
for (i in seq_along(data_2022)) {
  filename <- names(data_2022)[i]
  write.csv(data_2022[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}
for (i in seq_along(data_2023)) {
  filename <- names(data_2023)[i]
  write.csv(data_2023[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}
for (i in seq_along(data_2024)) {
  filename <- names(data_2024)[i]
  write.csv(data_2024[[i]], file = paste0("data/01-raw_data/", filename), row.names = FALSE)
}

#### Rename files ####
# Set the folder path
folder_path <- "data/01-raw_data"

# General name cleaning
file_names <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)
# Define the patterns to be removed from file names
patterns_to_remove <- c("Bike", "Share", "Ridership", "Toronto", "bike", "share", "ridership", "toronto", " ", "\\(", "\\)")
# Iterate through all files and modify the file names
for (file in file_names) {
  old_name <- basename(file)
  new_name <- old_name
  for (pattern in patterns_to_remove) {
    new_name <- str_remove_all(new_name, pattern)
  }
  new_file_path <- file.path(folder_path, new_name)
  file.rename(file, new_file_path)
}

# Rename the 2017 data files
files_2017 <- list.files(path = folder_path, pattern = "2017", full.names = TRUE)

# Loop through each file and rename it
for (file in files_2017) {
  file_name <- basename(file)  
  new_name <- gsub("2017Q(\\d+)", "2017-Q\\1", file_name)  # Change '2017Qx' to '2017-Qx' format
  new_path <- file.path(folder_path, new_name)  # Generate the new file path
  if (file != new_path) {  # Ensure the new and old paths are different
    file.rename(file, new_path)  # Rename the file
  }
}

# Rename the 2018 data files
files_2018 <- list.files(path = folder_path, pattern = "2018", full.names = TRUE)

# Loop through each file and rename it
for (file in files_2018) {
  file_name <- basename(file)  
  new_name <- gsub("_Q(\\d+)2018", "2018-Q\\1", file_name)  # Change '_Qx2018' to '2018-Qx' format
  new_path <- file.path(folder_path, new_name)  # Generate the new file path
  if (file != new_path) {  # Ensure the new and old paths are different
    file.rename(file, new_path)  # Rename the file
  }
}