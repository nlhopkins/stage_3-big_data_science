mytheme <-
    function(base_size = 11,
              base_family = "",
              base_line_size = base_size / 22,
              base_rect_size = base_size / 22)
    {
        theme_bw(
            base_size = base_size,
            base_family = base_family,
            base_line_size = base_line_size,
            base_rect_size = base_rect_size
        ) %+replace%
            theme(
                panel.border = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                axis.line = element_line(colour = "#5a5a5a",
                                         size = rel(1)),
                legend.key = element_blank(),
                strip.background = element_rect(
                    fill = "white",
                    colour = "#5a5a5a",
                    size = rel(2)
                ),
                complete = TRUE
            )
    } +
    theme(plot.title = element_text(
        family = "Montserrat",
        color = "#5a5a5a",
        face = "bold",
        size = 16,
        hjust = 0.5
    )) +
    theme(axis.title.y = element_text(
        family = "Montserrat",
        color = "#5a5a5a",
        face = "bold",
        size = 12,
        vjust = 2
    )) +
    theme(axis.title.x = element_text(
        family = "Montserrat",
        color = "#5a5a5a",
        face = "bold",
        size = 12,
        vjust = -2
    ))
