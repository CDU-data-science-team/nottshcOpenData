test_that("MySQL connection successful", {

  conn <- suppressMessages(connect_mysql(open_data = TRUE))

  testthat::expect_equal(class(conn) == c("Pool", "R6"), c(TRUE, TRUE))

})

test_that("Data tidying works", {

  open_data <- get_px_exp(from = "2021-01-01",
                          open_data = TRUE)

  expect_gt(nrow(dplyr::collect(open_data)), 0)

  tidy_open_data <- tidy_px_exp(data = open_data) %>%
    dplyr::collect()

  expect_gt(nrow(tidy_open_data), 0)

})
