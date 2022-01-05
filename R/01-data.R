# ---------------------------
#       LOAD PACKAGES
# ---------------------------


# Load the PCR data
pcr <- read.csv("data/data-raw/pcr.csv", header = TRUE) %>%
  janitor::clean_names()

# Load the PCR calibration data for the gDNA library
gdna_calibration <-
  read.csv("data/data-raw/pcr_gdna_calibration.csv", header = TRUE) %>%
  janitor::clean_names()

# Load the PCR calibration data for the cDNA library
cdna_calibration <-
  read.csv("data/data-raw/pcr_cdna_calibration.csv", header = TRUE) %>%
  janitor::clean_names()

# Load the EMSA data
emsa <- read.csv("data/data-raw/emsa.csv", header = TRUE) %>%
  janitor::clean_names()

# Load the EMSA calibration data
emsa_calibration <-
  read.csv("data/data-raw/emsa_calibration.csv", header = TRUE) %>%
  janitor::clean_names()

# Load the SEC standards data
standards <-
  read.csv("data/data-raw/sec_std.csv", header = TRUE) %>%
  janitor::clean_names() %>%
  pivot_longer(cols = starts_with("curve"),
               names_to = "protein",
               values_to = "time")

# Load the SEC data
sec <-
  read.csv("data/data-raw/sec_im9higam.csv", header = TRUE) %>%
  janitor::clean_names() %>%
  pivot_longer(cols = starts_with("a"),
               names_to = "protein",
               values_to = "time")
