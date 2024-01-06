# loading packages
library(ggplot2)
library(dplyr)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(tidyr)

yr <- 2021
df <- read.csv("data/leituras.csv") %>%
  filter(year == yr) %>%
  separate_rows(origin, sep = ";")

# Spatial object
world <- ne_countries(scale = "medium", returnclass = "sf")

world_df <- world %>% filter(admin %in% unique(df$origin))

world_points <- cbind(world_df, st_coordinates(st_centroid(world_df$geometry)))

head(world_df)

mapa <- ggplot() +
  geom_sf(data = world, fill = "grey", alpha = 0.5, color = "white") +
  geom_sf(data = world_df, fill = "red", alpha = 0.5, color = "white") +
  #geom_text(data = world_points, aes(x = X, y = Y, label = name),
   #         color = "darkblue", fontface = "bold", check_overlap = FALSE) +
  #geom_sf(data = df_cen, color = 'red') +
  theme_void() +
  labs(title = paste("Origem de autoras(es) das leituras de", yr)) +
  theme(legend.position = "none")

mapa
ggsave(paste0("figs/mapa_", yr, ".png"))

table(df$gender)
