library(tidyverse)
library(magrittr)
library(rversions)
library(lubridate)
library(plotly)

data <-
  r_versions() %>% 
  filter(grepl("\\.0$", version)) %>%
  arrange(date) %>% 
  mutate(
    version = factor(version, levels = rev(unique(version))),
    close_date = lead(date),
    close_date = replace_na(close_date, now())
  ) 

## ggplot
data %>% 
  ggplot() + 
  geom_segment(
    aes(
      x = date, xend = close_date, 
      y = version, yend = version,
      color = version
    ), 
    size = 6) +
  labs(
    title = "Version Lifespan",
    x = "Date",
    y = "Version"
  ) +
  theme_minimal() + 
  theme(legend.position = "none")

## plotly
data %>% 
  plot_ly() %>% 
  add_segments(
    x = ~date, xend = ~close_date, 
    y = ~version, yend = ~version,
    hoverinfo = 'text', text = ~nickname
  ) %>% 
  layout(
    title = "Version Lifespan",
    xaxis = list(title = "Date"),
    yaxis = list(title = "Version")  
  )

