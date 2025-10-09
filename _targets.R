######################
### Initial set-up ###
######################

library(targets)
library(tarchetypes)
options(tidyverse.quiet = TRUE)

# Set options
tar_option_set(
  packages = c("tidyverse"), # add other required packages in here
  format = "qs",
  error = "trim",
  memory = "transient",
  garbage_collection = TRUE,
  workspace_on_error = TRUE
)

# Define analysis configuration parameters etc
source("_config.R")

# Load functions
tar_source()

######################
### Define targets ###
######################

source("_plan.R")

################################
### End with list of targets ###
################################

list(targets)
