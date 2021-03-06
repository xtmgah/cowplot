#' cowplot.
#'
#' @name cowplot
#' @docType package
#' @import ggplot2
NULL



# *************************************************
#                     Setup
# *************************************************

.onAttach <- function(libname, pkgname) {
  # switch the default theme to theme_cowplot
  ggplot2::theme_set(theme_cowplot())
}

.pt <- 1 / 0.352777778 # from ggplot2, file aaa-constants.r

# *************************************************
#                     Themes
# *************************************************

#' Create the default cowplot theme
#'
#' After loading the cowplot package, this theme will be the default
#' for all graphs made with ggplot2.
#'
#' @param font_size Overall font size. Default is 14.
#' @param font_family Default font family.
#' @param line_size Default line size.
#' @return The theme.
#' @examples
#' qplot(1:10, (1:10)^2) + theme_cowplot(font_size = 15)
#' @export
theme_cowplot <- function(font_size = 14, font_family = "", line_size = .5) {
  # Start with default theme_grey and then modify some parts
  theme_grey(base_size = font_size, base_family = font_family) %+replace%
    theme(
      rect              = element_rect(fill = "transparent", colour = NA, color = NA, size = 0, linetype = 0),
      text              = element_text(family = font_family, face = "plain", colour = "black",
                                       size = font_size, hjust = 0.5, vjust = 0.5, angle = 0, lineheight = .9),
      axis.text         = element_text(colour = "black", size = font_size),
      axis.title        = element_text(face = "bold"),
      axis.title.x      = element_text(vjust = 0),
      axis.title.y      = element_text(vjust = 1, angle = 90),
      axis.ticks        = element_line(colour = "black", size = line_size),
      axis.line         = element_line(colour = "black", size = line_size),
      legend.key        = element_blank(),
      legend.margin     = grid::unit(0.1, "cm"),
      legend.key.size   = grid::unit(1, "lines"),
  #    legend.position   = c(-0.03, 1.05),
  #    legend.justification = c("left", "top"),
      panel.background  = element_blank(),
      panel.border      = element_blank(),
      panel.grid.major  = element_blank(),
      panel.grid.minor  = element_blank(),
      plot.background   = element_blank(),
      plot.title        = element_text(face = "bold", size = font_size),
      strip.background  = element_rect(fill = "grey80", colour = "grey50", size = 0)
    )
}


#' Create a completely empty theme
#'
#' The theme created by this function shows nothing but the plot panel. Unfortunately,
#' due to ggplot2 peculiarities, a little bit of padding remains to the left and bottom of
#' the panel. This can be removed by adding \code{labs(x = NULL, y = NULL)} to the plot, see examples.
#' @param base_size Overall font size. Default is 14.
#' @param base_family Base font family.
#' @return The theme.
#' @examples
#' # plot with small amount of remaining padding
#' qplot(1:10, (1:10)^2) + theme_nothing()
#' # remaining padding removed
#' qplot(1:10, (1:10)^2) + theme_nothing() + labs(x = NULL, y = NULL)
#' @export
theme_nothing <- function(base_size = 12, base_family = ""){
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
    theme(
      rect              = element_rect(fill = "transparent", colour = NA, color = NA, size = 0, linetype = 0),
      line              = element_blank(),
      text              = element_blank(),
      title             = element_blank(),
      # to debug, uncomment next line
      #plot.background   = element_rect(colour = "blue", fill = "cyan"),
      panel.background  = element_blank(),
      axis.ticks.margin = grid::unit(0, "lines"),
      axis.ticks.length = grid::unit(0, "lines"),
      legend.position   = "none",
      panel.margin      = grid::unit(c(0, 0, 0, 0), "lines"),
      plot.margin       = grid::unit(c(0, 0, 0, 0), "lines")
    )
}


#' Add/modify/remove the background grid in a ggplot2 plot
#'
#' This function provides a simple way to modify the background grid in ggplot2. It
#' doesn't do anything that can't be done just the same with \code{theme()}. However, it simplifies
#' creation of the most commonly needed variations.
#' @param major Specifies along which axes you would like to plot major grid lines. Options are "xy", "x",
#'  "y", "only_minor" (disables major grid lines but allows you to switch on minor grid lines), "none".
#' @param minor Specifies along which axes you would like to plot minor grid lines. Options are "xy", "x",
#'  "y", "none".
#' @param size.major Size of the major grid lines.
#' @param size.minor Size of the minor grid lines.
#' @param colour.major Color of the major grid lines.
#' @param colour.minor Color of the minor grid lines.
#' @export
background_grid <- function(major = c("xy", "x", "y", "only_minor", "none"),
                            minor = c("xy", "x", "y", "none"),
                            size.major = 0.2, size.minor = 0.5,
                            colour.major = "grey90", colour.minor = "grey98"){

  if (major[1] == "none") return(theme(panel.grid = element_blank()))

  t <- switch( major[1],
               x = theme(panel.grid.major   = element_line(colour = colour.major,
                                                           size = size.major),
                         panel.grid.major.y = element_blank()),
               y = theme(panel.grid.major   = element_line(colour = colour.major,
                                                           size = size.major),
                         panel.grid.major.x = element_blank()),
               xy = theme(panel.grid.major = element_line(colour = colour.major,
                                                          size = size.major)),
               yx = theme(panel.grid.major = element_line(colour = colour.major,
                                                          size = size.major)),
               theme(panel.grid.major = element_blank()))

  t + switch( minor[1],
              x = theme(panel.grid.minor   = element_line(colour = colour.minor,
                                                          size = size.minor),
                        panel.grid.minor.y = element_blank()),
              y = theme(panel.grid.minor   = element_line(colour = colour.minor,
                                                          size = size.minor),
                        panel.grid.minor.x = element_blank()),
              xy = theme(panel.grid.minor = element_line(colour = colour.minor,
                                                         size = size.minor)),
              yx = theme(panel.grid.minor = element_line(colour = colour.minor,
                                                         size = size.minor)),
              theme(panel.grid.minor = element_blank()))
}


#' Add/remove the panel border in a ggplot2 plot
#'
#' This function provides a simple way to modify the panel border in ggplot2. It
#' doesn't do anything that can't be done just the same with \code{theme()}. However, it
#' saves some typing.
#' @param colour The color of the border.
#' @param size Size.
#' @param linetype Line type.
#' @param remove If \code{TRUE}, removes the current panel border.
#' @export
panel_border <- function(colour = 'gray80', size = 0.5, linetype = 1, remove = FALSE){
  if (remove){
    return(theme(panel.border = element_blank()))
  }
  theme(panel.border = element_rect(colour = colour, fill=NA, linetype = 1, size = 0.5))
}


# *************************************************
#                     Output
# *************************************************

#' Cowplot reimplementation of ggsave.
#'
#' This function should behave just like \code{ggsave()} from ggplot2,
#' with the main difference being that by default it doesn't use the Dingbats
#' font for pdf output. If you ever have trouble with this function, you can
#' try using \code{ggplot2::ggsave()} instead.
#' @param filename Filename of plot
#' @param plot Plot to save, defaults to last plot displayed.
#' @param device Device to use, automatically extract from file name extension.
#' @param path Path to save plot to (if you just want to set path and not
#'    filename).
#' @param scale Scaling factor.
#' @param width Width (defaults to the width of current plotting window).
#' @param height Height (defaults to the height of current plotting window).
#' @param units Units for width and height when either one is explicitly specified (in, cm, or mm).
#' @param dpi DPI to use for raster graphics.
#' @param limitsize When \code{TRUE} (the default), \code{ggsave} will not
#'   save images larger than 50x50 inches, to prevent the common error of
#'   specifying dimensions in pixels.
#' @param ... Other arguments to be handed to the plot device.
#' @export
ggsave <- function(filename = NULL, plot = ggplot2::last_plot(),
                   device = default_device(filename), path = NULL, scale = 1,
                   width = par("din")[1], height = par("din")[2], units = c("in", "cm", "mm"),
                   dpi = 300, limitsize = TRUE, ...) {
  # this code is copied directly from ggplot2. ugly, but
  # the only way to implement this properly.

  if (is.null(filename)) stop("filename is required")
  if (!inherits(plot, "ggplot")) stop("plot should be a ggplot2 plot")

  eps <- ps <- function(..., width, height)
    grDevices::postscript(..., width=width, height=height, onefile=FALSE,
                          horizontal = FALSE, paper = "special")
  tex <- function(..., width, height)
    grDevices::pictex(..., width=width, height=height)
  pdf <- function(..., version="1.4"){
    if ("useDingbats" %in% names(list(...)))
      grDevices::pdf(..., version=version)
    else
      grDevices::pdf(..., useDingbats = FALSE, version=version)
  }
  svg <- function(...)
    grDevices::svg(...)
  wmf <- function(..., width, height)
    grDevices::win.metafile(..., width=width, height=height)
  emf <- function(..., width, height)
    grDevices::win.metafile(..., width=width, height=height)

  png <- function(..., width, height)
    grDevices::png(...,  width=width, height=height, res = dpi, units = "in")
  jpg <- jpeg <- function(..., width, height)
    grDevices::jpeg(..., width=width, height=height, res = dpi, units = "in")
  bmp <- function(..., width, height)
    grDevices::bmp(...,  width=width, height=height, res = dpi, units = "in")
  tiff <- function(..., width, height)
    grDevices::tiff(..., width=width, height=height, res = dpi, units = "in")

  default_device <- function(filename) {
    pieces <- strsplit(filename, "\\.")[[1]]
    ext <- tolower(pieces[length(pieces)])
    match.fun(ext)
  }

  units <- match.arg(units)
  convert_to_inches <- function(x, units) {
    x <- switch(units,
                `in` = x,
                cm = x / 2.54,
                mm = x / 2.54 /10
    )
  }

  convert_from_inches <- function(x, units) {
    x <- switch(units,
                `in` = x,
                cm = x * 2.54,
                mm = x * 2.54 * 10
    )
  }

  # dimensions need to be in inches for all graphic devices
  # convert width and height into inches when they are specified
  if (!missing(width)) {
    width <- convert_to_inches(width, units)
  }
  if (!missing(height)) {
    height <- convert_to_inches(height, units)
  }
  # if either width or height is not specified, display an information message
  # units are those specified by the user
  if (missing(width) || missing(height)) {
    message("Saving ", prettyNum(convert_from_inches(width * scale, units), digits=3), " x ", prettyNum(convert_from_inches(height * scale, units), digits=3), " ", units, " image")
  }

  width <- width * scale
  height <- height * scale

  if (limitsize && (width >= 50 || height >= 50)) {
    stop("Dimensions exceed 50 inches (height and width are specified in inches/cm/mm, not pixels).",
         " If you are sure you want these dimensions, use 'limitsize=FALSE'.")
  }

  if (!is.null(path)) {
    filename <- file.path(path, filename)
  }
  device(file=filename, width=width, height=height, ...)
  on.exit(capture.output(dev.off()))
  print(plot)

  invisible()
}

#' Alternative to ggsave, with better support for multi-figure plots.
#'
#' This function replaces the standard \code{ggsave()} function for saving a plot into a file. It
#' has several advantages over \code{ggsave()}. First, it uses default sizes that work well with
#' the cowplot theme, so that frequently a plot size does not have to be explicitly specified. Second, it
#' acknowledges that one often first develops individual plots and then combines them into
#' multi-plot figures, and it makes it easy---in combination with \code{plot_grid()}---to carry out
#' this workflow. Finally, it makes it easy to adjust the aspect ratio of the figure, which is
#' frequently necessary to accommodate the figure legend.
#'
#' The key idea for this function is that plots are often grids, with sup-plots at the individual
#' grid locations. Therefore, for this function we specify a base width and aspect ratio that apply
#' to one sup-plot, and we then specify how many rows and columns of subplots we have. This means that
#' if we have code that can save a single figure, it is trivial to adapt this code to save a combination
#' of multiple comparable figures. See examples for details.
#' @param filename Name of the plot file to generate.
#' @param plot Plot to save.
#' @param nrow Number of subplot rows.
#' @param ncol Number of subplot columns.
#' @param base_height The height (in inches) of the plot or of one sub-plot if \code{nrow}
#' or \code{ncol} > 1. Default is 4.
#' @param base_width The width (in inches) of the plot or of one sub-plot if \code{nrow}
#' or \code{ncol} > 1. Default is \code{NULL}, which means that the width is calculated from
#' \code{height} and \code{base_aspect_ratio}.
#' @param base_aspect_ratio The aspect ratio of the plot or of one sub-plot if \code{nrow}
#' or \code{ncol} > 1. This argument is only used if \code{base_width = NULL}. The default is 1.1,
#' which works well for figures without a legend.
#' @param rows Deprecated. Like \code{nrow}.
#' @param cols Deprecated. Like \code{ncol}.
#' @param ... Other arguments to be handed to \code{ggsave()}.
#' @examples
#' # save a single plot without legend
#' x <- (1:100)/10
#' p1 <- qplot(x, 2*x+5, geom='line')
#' save_plot("p1.pdf", p1)
#' # now combine with a second plot and save
#' p2B <- qplot(x, -x^2+10*x-3, geom='line')
#' p2 <- plot_grid(p1, p2B, labels=c("A", "B"))
#' save_plot("p2.pdf", p2, ncol = 2)
#' # save a single plot with legend, changing the aspect ratio to make room for the legend
#' p3 <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + geom_point(size=2.5)
#' save_plot("p3.png", p3, base_aspect_ratio = 1.3)
#' @export
save_plot <- function(filename, plot, ncol = 1, nrow = 1,
                      base_height = 4, base_aspect_ratio = 1.1, base_width = NULL, ...,
                      cols = NULL, rows = NULL ){

  if (!is.null(cols)){
    warning("Argument 'cols' is deprecated. Use 'ncol' instead.")
  }

  if (!is.null(rows)){
    warning("Argument 'rows' is deprecated. Use 'nrow' instead.")
  }

  # internally, this function operates with variables cols and rows instead of ncol and nrow
  if (!is.null(ncol)){
    cols <- ncol
  }
  if (!is.null(nrow)){
    rows <- nrow
  }

  if (is.null(base_width)){
    base_width <- base_height * base_aspect_ratio
  }

  ggsave(filename = filename, plot = plot, width = base_width*cols, height = base_height*rows, ...)
}



# *************************************************
#                     Drawing code
# *************************************************


#' Draw a line.
#'
#' This is a convenience function. It's just a thin wrapper around \code{geom_line()}.
#'
#' @param x Vector of x coordinates.
#' @param y Vector of y coordinates.
#' @param ... Style parameters, such as \code{colour}, \code{alpha}, \code{size}, etc.
#' @export
draw_line <- function(x, y, ...){
  geom_path(data = data.frame(x, y),
            aes(x = x, y = y),
            ...)
}

#' Draw text.
#'
#' This is a convenience function. It's just a thin wrapper around \code{geom_text()}. It can take either an
#' individual piece of text to be drawn or a vector of separate text labels, with associated coordinates.
#'
#' Note that font sizes get scaled by a factor of 2.85, so sizes given here agree with font sizes used in
#' the theme. This is different from geom_text in ggplot2.
#'
#' By default, the x and y coordinates specify the center of the text box. Set \code{hjust = 0, vjust = 0} to specify
#' the lower left corner, and other values of \code{hjust} and \code{vjust} for any other relative location you want to
#' specify.
#' @param text Character or expression vector specifying the text to be written.
#' @param x Vector of x coordinates.
#' @param y Vector of y coordinates.
#' @param size Font size of the text to be drawn.
#' @param ... Style parameters, such as \code{colour}, \code{alpha}, \code{angle}, \code{size}, etc.
#' @export
draw_text <- function(text, x = 0.5, y = 0.5, size = 14, ...){
  geom_text(data = data.frame(text, x, y),
            aes(label = text, x = x, y = y),
            size = size / .pt, # scale font size to match size in theme definition
            ...)
}

#' Draw plot label
#'
#' This function adds a plot label to the upper left corner of a graph. It takes all the same parameters
#' as \code{draw_text()}, but has defaults that make it convenient to label graphs.
#' @param label String to be drawn as the label.
#' @param x The x position of the label.
#' @param y The y position of the label.
#' @param hjust Horizontal adjustment.
#' @param vjust Vertical adjustment.
#' @param size Font size of the label to be drawn.
#' @param fontface Font face of the label to be drawn.
#' @param ... Other arguments to be handed to \code{draw_text()}.
#' @export
draw_plot_label <- function(label, x=0, y=1, hjust = -0.5, vjust = 1.5, size = 16, fontface = 'bold', ...){
  draw_text(text = label, x = x, y = y, hjust = hjust, vjust = vjust, size = size, fontface = fontface, ...)
}


#' Draw a (sub)plot.
#'
#' Places a plot somewhere onto the drawing canvas. By default, coordinates run from
#' 0 to 1, and the point (0, 0) is in the lower left corner of the canvas.
#' @param plot The plot to place.
#' @param x The x location of the lower left corner of the plot.
#' @param y The y location of the lower left corner of the plot.
#' @param width Width of the plot.
#' @param height Height of the plot.
#' @export
draw_plot <- function(plot, x = 0, y = 0, width = 1, height = 1){
  plot.grob <- grid::grobTree(ggplot2::ggplotGrob(plot))
  annotation_custom(plot.grob, xmin = x, xmax = x+width, ymin = y, ymax = y+height)
}

#' Set up a drawing layer on top of a ggplot
#' @param plot The ggplot2 plot object to use as a starting point.
#' @export
ggdraw <- function(plot = NULL){
  d <- data.frame(x=0:1, y=0:1) # dummy data
  p <- ggplot(d, aes_string(x="x", y="y")) + # empty plot
    scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
    scale_y_continuous(limits = c(0, 1), expand = c(0, 0)) +
    theme_nothing() + # with empty theme
    labs(x=NULL, y=NULL) # and absolutely no axes

  if (!is.null(plot)){
    plot.grob <- grid::grobTree(ggplot2::ggplotGrob(plot))
    p <- p + annotation_custom(plot.grob)
  }
  p # return ggplot drawing layer
}


#' Arrange multiple plots into a grid
#'
#' Arrange multiple plots into a grid.
#' @param ... List of plots to be arranged into the grid.
#' @param plotlist (optional) List of plots to display. Alternatively, the plots can be provided
#' individually as the first n arguments of the function plot_grid (see examples).
#' @param nrow (optional) Number of rows in the plot grid.
#' @param ncol (optional) Number of columns in the plot grid.
#' @param scale (optional) Allows to set an overall scaling of each sub-plot. Can be set separately for
#'              each subplot, by giving a vector of scale values, or at once for all subplots,
#'              by giving a single value.
#' @param labels (optional) List of labels to be added to the plots.
#' @param label_size (optional) Numerical value indicating the label size. Default is 14.
#' #' @param rows Deprecated. Like \code{nrow}.
#' @param cols Deprecated. Like \code{ncol}.
#' @examples
#' p1 <- qplot(1:10, 1:10)
#' p2 <- qplot(1:10, (1:10)^2)
#' p3 <- qplot(1:10, (1:10)^3)
#' p4 <- qplot(1:10, (1:10)^4)
#' plot_grid(p1, p2, p3, p4)
#' plot_grid(p1, p2, p3, p4, labels=c('A', 'B', 'C', 'D'))
#' plot_grid(p1, p2, p3, nrow=3, labels=c('A', 'B', 'C', 'D'), label_size=12)
#' plot_grid(p1, NULL, NULL, p2, p3, NULL, ncol=2,
#'  labels=c('A', 'B', 'C', 'D', 'E', 'F'), label_size=12)
#' @export
plot_grid <- function(..., plotlist = NULL, nrow = NULL, ncol = NULL, scale = 1, labels = NULL,
                      label_size = 14, cols = NULL, rows = NULL ) {

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  num_plots <- length(plots)

  if (!is.null(cols)){
    warning("Argument 'cols' is deprecated. Use 'ncol' instead.")
  }

  if (!is.null(rows)){
    warning("Argument 'rows' is deprecated. Use 'nrow' instead.")
  }

  # internally, this function operates with variables cols and rows instead of ncol and nrow
  if (!is.null(ncol)){
    cols <- ncol
  }
  if (!is.null(nrow)){
    rows <- nrow
  }

  # calculate grid dimensions
  if (is.null(cols) && is.null(rows)){
    # if neither rows nor cols are given, we make a square grid
    cols <- ceiling(sqrt(num_plots))
    rows <- ceiling(num_plots/cols)
  }
  # alternatively, we know at least how many rows or how many columns we need
  if (is.null(cols)) cols <- ceiling(num_plots/rows)
  if (is.null(rows)) rows <- ceiling(num_plots/cols)

  # in general, we allow for separate scale values for each graph
  if (length(scale)==1)
    scale <- rep(scale, num_plots)

  # now place all the plots
  p <- ggdraw() # start with nothing
  col_count <- 0
  row_count <- 1
  x_delta <- 1/cols
  y_delta <- 1/rows
  for (i in 1:(rows*cols)){
    if (i > num_plots) break

    # calculate width, offset, etc
    width <- x_delta * scale[i]
    height <- y_delta * scale[i]
    x_off <- (x_delta - width)/2
    y_off <- (y_delta - height)/2
    x <- col_count * x_delta + x_off
    y <- (rows - row_count) * y_delta + y_off

    # place the plot
    p_next <- plots[[i]]
    if (!is.null(p_next)){
      p <- p + draw_plot(p_next, x, y, width, height)
    }
    # place a label if we have one
    if (i <= length(labels)){
      p <- p + draw_plot_label(labels[i], x, y + height, size=label_size)
    }
    # move on to next grid position
    col_count <- col_count + 1
    if (col_count >= cols){
       col_count <- 0
       row_count <- row_count + 1
    }
  }
  p
}

