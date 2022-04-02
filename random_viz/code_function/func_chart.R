#---
# chart_func.R
#
# This Rscript: create a function named `chart` to:
# * clean the data input
# * plot multiple (smoothed) lines
#---
library(tidyverse)

chart <- function(data,
	        point_size = 2,
	        line_size = 1,
	        title = "title here",
	        xtitle = "x-axis title",
	        ytitle = "y-axis title",
	        resolution_spl = 100,
	        ymin = NULL,
	        ymax = NULL,
	        yby  = NULL,
	        color_palette = NULL,
	        color_manual = NULL,
	        legend_label = NULL,
	        legend_position = "right",
	        legend_direction = "vertical",
	        ...){
	
	# transform original data
	newdata <- data %>%
		pivot_longer(cols = !Month,
			   names_to = "variable",
			   values_to = "value") %>%
		mutate(Month = factor(Month, levels = month.abb))
	
	# data for spline curves
	data_spl <- data %>% 
		select(!Month) %>%
		map(function(var) spline(x = factor(data$Month,
					      levels = month.abb),
				     y = var,
				     n = resolution_spl)) %>%
		as.data.frame() %>%
		pivot_longer(cols = everything(),
			   names_to = c("variable", ".value"),
			   names_pattern = "(.*).(.)")
	
	# other info
	if (is.null(c(ymin, ymax, yby))) {
		ymin = min(newdata$value) - 5
		ymax = max(newdata$value) + 5
		yby = 5
		yvalue = seq(from = ymin, to = ymax, by = yby)
	} else yvalue = seq(from = ymin, to = ymax, by = yby)
	
	legend_breaks <- newdata %>% distinct(variable) %>% deframe()
	
	legend_label <- if (is.null(legend_label)) legend_breaks 
	else legend_label

	color_line_point <- if (!is.null(color_palette)) {
	scale_color_brewer(palette = color_palette,
		         breaks = legend_breaks,
		         labels = legend_label)
	} else if (!is.null(color_manual)) {
	scale_color_manual(values = color_manual,
		         breaks = legend_breaks,
		         labels = legend_label)
		}
	
	# plot
	plot <- ggplot(data = newdata,
		     aes(x = Month,
		         y = value,
		         group = variable)) +
		geom_point(aes(color = variable), size = point_size) +
		# add spline curves
		geom_line(data = data_spl,
			aes(x = x,
			    y = y,
			    group = variable,
			    color = variable),
			size = line_size) +
		scale_y_continuous(breaks = yvalue,
			         limits = c(ymin, ymax),
			         expand = c(0, 0)) +
		color_line_point +
		labs(title = title,
		     x = xtitle,
		     y = ytitle) +
		theme_light() +
		theme(legend.title = element_blank(),
		      legend.position = legend_position,
		      legend.direction = legend_direction,
		      legend.background = element_blank(),
		      ...)
	
	plot
}
