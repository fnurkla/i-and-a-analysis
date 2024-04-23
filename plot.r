# Reading data and creating pdf with scatterplot
#
library(tools)

files_path <- "out"

files <- list.files(path = files_path, pattern = "*.csv", full.names = TRUE, recursive = FALSE)

read_data <- function(file) {
  data <- read.csv(file)
  class_count <- data[, 2]
  data <- data[class_count > 0, ] # ignore misleading data w/ CC = 0
  data <- data[, 6:7]
  data
}

read_all_data <- function() {
  data <- list()
  for (file in files) {
    df <- read_data(file)
    data <- rbind(data, df)
    make_a_plot(file, df)
  }
  data
}

# makes a plot for the current project in the for loop
# and adds a pdf to the plots folder
make_a_plot <- function(file, df) {
  if (nrow(df) > 1) {
    name <- file_path_sans_ext(basename(file))
    output_path <- paste("plots/", name, ".pdf", sep = "")
    pdf(output_path)
    plot(df, xlim = c(0.0, 1.0), ylim = c(0.0, 1.0)) # plot to pdf file
    title(main = name)
    dev.off()
  }
}

data <- read_all_data()

# Makes one plot with packages from all projects
name <- "ALL_TOGETHER"
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
plot(data, xlim = c(0.0, 1.0), ylim = c(0.0, 1.0)) # plot to pdf file
title(main = name)
dev.off()
