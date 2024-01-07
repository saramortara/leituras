# loading packages
library(tmap)
library(dplyr)
library(sf)
library(spData)
library(tidyr)

df <- read.csv("data/leituras.csv") %>%
  separate_rows(origin, sep = ";")

# Mapa -------------------------------------------------------------------------
data("world")

tmap_mode("plot")

df_summary <- df %>%
  distinct(origin, year)

world_book <- world %>%
  right_join(df_summary, by = c("name_long" = "origin"))

my_bb <- bb(c(-180, -90, 180, 90))

base_world <- get_tiles(x = my_bb, zoom = 2,
                        provider = "CartoDB.VoyagerNoLabels")

base_map <- tm_shape(base_world) +
  tm_rgb() +
  tm_layout(frame = FALSE)

book_animation <- base_map +
  tm_shape(world_book, bbox = my_bb) +
  tm_polygons(col = "book", palette = c(NA, "#440154FF"), alpha = .7, border.col = NA) +
  tm_legend(show = FALSE) +
  tm_facets(along = "year", free.coords = FALSE)

tmap_animation(
  book_animation, filename = "figs/book.gif", dpi = 300,
  delay = 50, width = 2400, height = 1200
)

# "Esri.WorldTerrain"
# "Esri.WorldTopoMap"
# "Esri.OceanBasemap"
## country division
# "CartoDB.VoyagerNoLabels"
# "OpenStreetMap"
# "Esri.WorldGrayCanvas"

# Graficos ---------------------------------------------------------------------
df %>%
  distinct(author, gender) %>%
  group_by(gender) %>%
  summarize(length(gender))

df_summary <- df %>%
  group_by(year, gender) %>%
  summarise(book = length(book))

ggplot(df_summary, aes(x = year, y = book, fill = gender)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_viridis_d(alpha = .7) +
  geom_text(aes(label = book), hjust = 1.5, color = "grey10",
            position = position_dodge(0.9), size = 3.5) +
  theme_minimal() +
  coord_flip() +
  labs(y = "", x = "", fill = "Gender")

ggsave("figs/gender_year.png")

