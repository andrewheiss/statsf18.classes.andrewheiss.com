ds_colors <- list(blue = "#6CB9DC",
                  red = "#821F29",
                  orange = "#D46600",
                  yellow = "#F6E03F",
                  green = "#ADBD06",
                  brown = "#7D4A04")


update_geom_defaults("label", list(family = "Oswald Light", face = "plain"))
update_geom_defaults("text", list(family = "Oswald Light", face = "plain"))

theme_ds <- function(base_size = 11, base_family = "Oswald") {
  ret <- theme_bw(base_size, base_family) +
    theme(plot.title = element_text(size = rel(1.4), face = "plain",
                                    family = "Oswald SemiBold"),
          plot.subtitle = element_text(size = rel(1), face = "plain",
                                       family = "Oswald Light"),
          plot.caption = element_text(size = rel(0.8), color = "grey50", face = "plain",
                                      family = "Oswald Light",
                                      margin = margin(t = 10)),
          plot.tag = element_text(size = rel(1), face = "plain", color = "grey50",
                                  family = "Oswald SemiBold"),
          strip.text = element_text(size = rel(0.8), face = "plain",
                                    family = "Oswald Medium"),
          strip.text.x = element_text(margin = margin(t = 1, b = 1)),
          panel.border = element_blank(), 
          strip.background = element_rect(fill = "#ffffff", colour = NA),
          axis.ticks = element_blank(),
          axis.title.x = element_text(margin = margin(t = 10)),
          axis.title.y = element_text(margin = margin(r = 10)),
          legend.margin = margin(t = 0),
          legend.title = element_text(size = rel(0.8)),
          legend.position = "bottom")
  
  ret
}
