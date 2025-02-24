# %% [Markdown] [markdown]
# # Atlassing Seabirds of New Zealand
#
# This page will load up four different databases that are relevant to mapping seabirds in New Zealand:
#
# - Beach Patrol Surveys
# - eBird
# - iNaturalist
# - Royal Naval Birdwatching Society
# - DOC Surveys
#
# Each of these databases has slightly different scope and protocols.
#
# We're going to start with looking at the Royal Naval Birdwatching Society. Let's see what we have. First, we have to load the packages that we want.

# %%
install.packages(c("readxl", "dplyr", "ggplot2", "ggmap", "maps", "mapdata", "sf", "rnaturalearth", "rnaturalearthdata"))

library(readxl)
library(dplyr)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(lubridate)

green <- "#576B37"

# %% [Markdown] [markdown]
#
# If that works, we can continue.

# %%
# Define the file path. For now, we're using a data folder in this repo.
file_path <- "../data/RNBWS_database.xlsx"

# Read the first and only sheet
sheets <- excel_sheets(file_path)
first_sheet <- sheets[1]
data <- read_excel(file_path, sheet = first_sheet, col_names = TRUE, col_types = c("numeric", "text", "text", "text", "text", "text", "text", "text", "text",  "text", "text", "text", "text", "text", "text", "text", "vesselUnit", "text", "text", "text", "text","numeric","text", "text"))

# %% [Markdown] [markdown]
# There is an issue with reading this database as an Excel file - we have to deal with Excel date formatting. It uses 1899 as the starting point (for Windows systems), so we need to make a workaround to exclude a few dates in this particular database from the 1800s.
#
# Now convert the date column to a Date object.

# %%
data <- data %>%
  mutate(
    # Attempt to convert the date column to numeric; this will yield NA for text values
    date_numeric = suppressWarnings(as.numeric(date)),
    # If numeric conversion yields NA, parse as a text date; otherwise, convert using Excel's origin
    # This needs to happen because there's four dates from 1825 that just throw a spanner in the works.
    date = if_else(
      is.na(date_numeric),
      as.Date(trimws(date), format = "%Y-%m-%d"),
      as.Date(date_numeric, origin = "1899-12-30")
    )
  ) %>%
  select(-date_numeric)

# %% [Markdown] [markdown]
# Now that we've done that, let's take a look at the structure of the data.

# %%
str(data)

# %% [Markdown] [markdown]
# And some stats!

# %%
summary(data)

# %% [Markdown] [markdown]
Let's dive in a bit deeper. We know that none of the IDs are duplicated, which is excellent.

# %%
any(duplicated(data$bird_id))

# %% [Markdown] [markdown]
But some of the other data is pretty dirty. For instance, we have 671 unique species, but the data is dirty.

# %%
length(unique(data$latin_name))
unique(data$latin_name)[startsWith(unique(data$latin_name), "Dapt")]

# %% [Markdown] [markdown]
The data is dirty elsewhere, too. For instance:

# %%
unique(data$wind)

# %% [Markdown] [markdown]
We're not going to clean up everything. We're interested in a few things:  the number of birds seen on a particular date at a location by an observer. Maybe later we can try some things like cleaning up wind and seeing if there is a correlation between wind speed and observation.

For now, let's figure out how to clean the species. One of the easiest ways to do this would be to compare the latin names to a known taxonomy, and then to filter the data for anything that isn't in that taxonomy and use lazy searching to automatically fix them if we can. What taxonomy can we use? eBird. Let's switch to that. 













