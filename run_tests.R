library(RUnit)
source("run_analysis.R")

test.suite <- defineTestSuite("Data Table Output",
                              dirs = file.path("tests"),
                              testFileRegexp = 'Test_Output.R')

test.result <- runTestSuite(test.suite)

printTextProtocol(test.result)