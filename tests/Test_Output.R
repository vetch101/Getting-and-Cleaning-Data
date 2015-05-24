test.table <- function() {
  
  testTable <- read.table(file.path("tests", "test_tidydata.txt"))
  
  newTable <- read.table(file.path("tidydata.txt"))  
  
  checkIdentical(testTable, newTable)
  
}