################ aRtsy

library(aRtsy)
library(ggplot2)
library(wesanderson)

install.packages("wesanderson")

set.seed(0)
artwork = canvas_collatz(colors = wes_palette("IsleofDogs2"), n = 400, side = TRUE)
saveCanvas(artwork, filename = "preview.png", width = 6.1, height = 3.8, dpi = 600)

################ generativeart

library(generativeart)

IMG_DIR <- "img/"
IMG_SUBDIR <- "sub/"
IMG_SUBDIR2 <- "sub2/"
IMG_PATH <- paste0(IMG_DIR, IMG_SUBDIR)

LOGFILE_DIR <- "log/"
LOGFILE <- "logfile.csv"
LOGFILE_PATH <- paste0(LOGFILE_DIR, LOGFILE)

setup_directories(IMG_DIR, IMG_SUBDIR, IMG_SUBDIR2, LOGFILE_DIR)

my_formula <- list(
  x = quote(runif(1, -1, 1) * x_i^2 - cos(y_i^2)),
  y = quote(runif(1, -1, 1) * y_i^3 - cos(x_i^2))
)

generate_img(formula = my_formula, nr_of_img = 5, polar = FALSE, filetype = "png", color = "#ffffff", background_color = "#8E2B4D")
