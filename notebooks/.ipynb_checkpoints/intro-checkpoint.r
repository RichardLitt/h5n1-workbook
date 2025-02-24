# %% [Markdown] [markdown]
# # Atlassing Seabirds of New Zealand
#
# This page will load up four different databases that are relevant to mapping seabirds in New Zealand:
#
# - eBird
# - iNaturalist
# - Royal Naval Birdwatching Society
# - Beach Patrol Surveys
# - DOC Surveys
#
# Each of these databases has slightly different scope and protocols.
#
# First, lets set up the packages needed for this work.

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

green <- "#576B37"

# %% [Markdown] [markdown]
#
# If that works, we can continue.
