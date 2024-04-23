# Reading data and creating pdf with scatterplot
#
file_name <- "junit-jupiter-api-5.10.2.jar"
file_name_csv <- paste("out/", file_name, ".csv", sep = "")
file_name_pdf <- paste("plot/", file_name, ".pdf", sep = "")

read_data <- function(file) {
  data <- read.csv(file)
  class_count <- data[, 2]
  data <- data[class_count > 0, ] # ignore misleading data w/ CC = 0
  data <- data[, 6:7]
  data
}

frame <- read_data(file_name_csv)

pdf(file_name_pdf)
plot(frame) # plot to pdf file
dev.off()
