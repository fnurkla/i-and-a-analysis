# Reading data and creating pdf with scatterplot
#
output_path <- "out/result.pdf"
files_path <- "out"

files <- list.files(path=files_path, pattern="*.csv", full.names=TRUE, recursive=FALSE)

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
  }
  data
}

data <- read_all_data()

pdf(output_path)
plot(data) # plot to pdf file
dev.off()
