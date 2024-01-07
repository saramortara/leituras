# loading packages
library(ggplot2)
library(dplyr)
library(sf)
library(spData)
library(tidyr)

df <- read.csv("data/leituras.csv") %>%
  separate_rows(origin, sep = ";")

# Spatial object
data("world")

yr = 2023
df <- df %>%
  filter(year == yr)


world_df <- world %>% filter(name_long %in% unique(df$origin))

mapa <- ggplot() +
  geom_sf(data = world, fill = "grey", alpha = 0.5, color = "white") +
  geom_sf(data = world_df, fill = "red", alpha = 0.5, color = "white") +
  theme_void() +
  labs(title = paste("Origem de autoras(es) das leituras de", yr)) +
  theme(legend.position = "none")

mapa
ggsave(paste0("figs/mapa_", yr, ".png"))


df %>%
  distinct(author, gender) %>%
  group_by(gender) %>%
  summarize(length(gender))

