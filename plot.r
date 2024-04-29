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
# adding lines at some fractions along x-axis
abline(h = 0, col = "red")
abline(h = 1, col = "red")
abline(h = 1 / 2, col = "red")
abline(h = 1 / 3, col = "red")
abline(h = 2 / 3, col = "red")
abline(h = 1 / 4, col = "red")
abline(h = 3 / 4, col = "red")
# adding lines at some fractions along y-axis
abline(v = 0, col = "red")
abline(v = 1, col = "red")
abline(v = 1 / 2, col = "red")
abline(v = 1 / 3, col = "red")
abline(v = 2 / 3, col = "red")
abline(v = 1 / 4, col = "red")
abline(v = 3 / 4, col = "red")

title(main = name)
dev.off()

# makes a histogram showing every packages distance from the main sequence
df_D <- data[, 3] # data frame for Distance from the Main Sequence
name <- "ALL_TOGETHER_distance_histogram"
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
hist(df_D,
  xlab = "Distance from the Main Sequence",
  ylab = "Number of Packages",
  breaks = 100
)
dev.off()


# install.packages("plot3D")
library(plot3D)

z <- table(df_A_I) # Creates a table with the number of packages at different decimal coordinates (A, I)

name <- "ALL_TOGETHER_I_A_heatmap"
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
image2D(z = z, border = "black") ##  Plot as a 2D heatmap:
dev.off()

name <- "ALL_TOGETHER_I_A_heatmap_without_edges" # without x = 0, x = 1, y = 0, y = 1
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
image2D(z = z[2:87, 2:91], border = "black") ##  Plot as a 2D heatmap:
dev.off()

name <- "ALL_TOGETHER_3D_I_A_histogram"
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
hist3D(z = z, border = "black") ##  Plot as a 3D histogram:
dev.off()

name <- "ALL_TOGETHER_3D_I_A_histogram_without_edges" # without x = 0, x = 1, y = 0, y = 1
output_path <- paste("plots/", name, ".pdf", sep = "")
pdf(output_path)
hist3D(z = z[2:87, 2:91], border = "black") ##  Plot as a 3D histogram:
dev.off()


# Calculates the (A, I) pairs with the most packages

max_indices <- which(z > 5, arr.ind = TRUE) # Finds the indices of the (A, I) pairs with more than 5 packages
packages <- z[max_indices] # Extracts the x and y coordinates
result <- cbind(max_indices, packages) # Combines coordinates and values (number of packages)
sorted_result <- result[order(result[, "packages"], decreasing = TRUE), ] # Sorts the result by number of packages
sorted_frame <- data.frame(sorted_result) # Converts table to frame

sorted_frame$A <- rownames(z)[sorted_frame$A] # Changes indices to actual values of A
sorted_frame$I <- colnames(z)[sorted_frame$I] # Changes indices to actual values of I
sorted_frame$percent <- sorted_frame$packages / sum(z) * 100 # Creates a column for percent of total number of packages

# Sets row names of the frame to 1, 2, 3 ...
row_names <- seq_len(nrow(sorted_frame))
row.names(sorted_frame) <- row_names

# Prints a table with the pairs (A, I) where the most packages are
cat("\n")
print(sorted_frame)
cat("\n")
print(paste(sum(sorted_frame$percent), "% of packages have the A and I pairs listed above."))
