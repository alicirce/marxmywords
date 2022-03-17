test_that("Capital Vol 1 can be returned as a whole book", {
  book <- capital_vol1_book()
  expect_true(inherits(book, "character"))
  expect_equal(book[1], "Capital by Karl Marx (1867)")
})
