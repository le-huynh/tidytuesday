#---
# eg_chart.R
#
# This Rscript: an example for function `chart()`
# * create example dataframes
# * plots
# * save the plots
#
# Dependencies...
# code_function/func_chart.R
#
# Produces...
# plots/chart.png
#---
library(patchwork)

source(here::here("random_viz/code_function/func_chart.R"))

# data
data <- data.frame(Month = c("Jan", "Feb", "Mar", "Apr",
		         "May", "Jun", "Jul", "Aug",
		         "Sep", "Oct", "Nov", "Dec"),
	         avg = c(76.8, 78.6, 82.5, 85.8,
		       84.6, 82.2, 81.0, 81.0,
		       80.7, 80.7, 80.7, 77.4),
		max = c(101.4, 104.1, 108.0, 109.8,
		        110.1, 106.5, 104.1, 103.5,
		        105.6, 104.7, 103.2, 102.9),
		min = c(53.1, 55.2, 53.1, 65.4,
		        65.7, 64.8, 64.2, 63.3,
		        66.6, 63.6, 57.9, 51.0))

# plot
p1 <- chart(data)

p2 <- chart(data,
      point_size = 2,
      line_size = 0.5,
      title = "An awesome title",
      xtitle = "\nMonth",
      ytitle = "A cool x-axis title\n",
      ymin = 45, ymax = 115, yby = 10,
      color_manual = c("red", "blue", "orange"),
      legend_label = c("Average", "Max", "Min"),
      legend_position = "top",
      legend_direction = "horizontal")

plot <- p1 / p2
# save
ggsave("random_viz/plots/chart.png",
       plot = plot,
       units = "mm",
       height = 160,
       width = 120)

