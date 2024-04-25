# Reading data and creating pdf with scatterplot
#
library(tools)

files_path <- "out"

files <- list.files(path = files_path, pattern = "*.csv", full.names = TRUE, recursive = FALSE)

read_data <- function(file) {
  data <- read.csv(file)
  class_count <- data[, 2]
  data <- data[class_count > 0, ] # ignore misleading data w/ CC = 0
  data <- data[, 6:8] # takes the columns for A, I and D
  data
}

read_all_data <- function() {
  data <- list()
  for (file in files) {
    df <- read_data(file)
    data <- rbind(data, df)
    make_scatter_plot(file, df)
  }
  data
}

# makes a scatter plot for the current project in the for loop
# and adds a pdf to the plots folder
make_scatter_plot <- function(file, df) {
  if (nrow(df) > 1) {
    df_A_I <- df[, 1:2]
    name <- file_path_sans_ext(basename(file)) # removes "out/" and ".csv" from the filename
    name <- paste(name, "scatter_plot", sep = "_")
    output_path <- paste("plots/", name, ".pdf", sep = "")
    pdf(output_path)
    plot(df_A_I, xlim = c(0.0, 1.0), ylim = c(0.0, 1.0)) # plot to pdf file
    title(main = name)
    dev.off()
  }
}

data <- read_all_data()

# makes a scatter plot with packages from all projects
df_A_I <- data[, 1:2] # data frame for Abstractness and Instability
name <- "ALL_TOGETHER_scatter_plot"
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
plot(df_A_I, xlim = c(0.0, 1.0), ylim = c(0.0, 1.0)) # plot to pdf file
title(main = name)
dev.off()

# makes a histogram showing every packages distance from the main sequence
df_D <- data[, 3] # data frame for Distance from the Main Sequence
name <- "ALL_TOGETHER_distance_histogram"
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
# plot(df_A_I, xlim = c(0.0, 1.0), ylim = c(0.0, 1.0)) # plot to pdf file
hist(df_D,
  xlab = "Distance from the Main Sequence",
  ylab = "Number of Packages",
  breaks = 100
)
dev.off()
