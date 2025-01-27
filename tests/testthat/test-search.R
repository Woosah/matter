require(testthat)
require(matter)

context("search")

test_that("relative difference", {

	expect_equal(reldiff(3L, 4L), abs(3 - 4))
	expect_equal(reldiff(3L, 4L, ref="x"), abs(3 - 4) / 3)
	expect_equal(reldiff(3L, 4L, ref="y"), abs(3 - 4) / 4)
	expect_equal(reldiff(3, 3.14), abs(3 - 3.14))
	expect_equal(reldiff(3, 3.14, ref="x"), abs(3 - 3.14) / 3)
	expect_equal(reldiff(3, 3.14, ref="y"), abs(3 - 3.14) / 3.14)
	expect_equal(reldiff("abc", "abc"), 0)
	expect_equal(reldiff("abc", "abcd"), 1)
	expect_equal(reldiff("abc", "abbd"), 2)
	expect_equal(reldiff("abc", "bbbd"), 4)
	expect_equal(reldiff("abc", "bbc"), 3)
	expect_equal(reldiff("abc", "abcd", ref="x"), 1 / 3)
	expect_equal(reldiff("abc", "abcd", ref="y"), 1 / 4)
	expect_equal(reldiff("abc", "abbd", ref="x"), 2 / 3)
	expect_equal(reldiff("abc", "abbd", ref="y"), 2 / 4)

})

test_that("binary search - integers", {

	table <- c(1L, 2L, 3L, 4L, 5L, 8L, 9L, 100L, 101L, 102L)
	x <- c(1L, 4L, 6L, 99L, 102L)
	
	expect_equal(c(1, 4, NA, NA, 10), bsearch(x, table))
	expect_equal(c(1, 4, 5, 8, 10), bsearch(x, table, tol=Inf))
	expect_equal(c(1, 4, 5, 8, 10), bsearch(x, table, nearest=TRUE))

})

test_that("binary search - doubles", {

	table <- c(1.11, 2.22, 3.33, 4.0, 5.0)
	x <- c(1.11, 3.0, 3.33, 5.0, 5.1)
	
	expect_equal(c(1, NA, 3, 5, NA), bsearch(x, table))
	expect_equal(c(1, 3, 3, 5, 5), bsearch(x, table, nearest=TRUE))
	expect_equal(NA_integer_, bsearch(3.0, table, tol=0))
	expect_equal(3, bsearch(3.0, table, tol=0.5))
	expect_equal(3, bsearch(3.0, table, tol=Inf))
	expect_equal(NA_integer_, bsearch(3.0, table, tol=0.1, tol.ref="x"))
	expect_equal(3, bsearch(3.0, table, tol=0.1, tol.ref="x", nearest=TRUE))
	expect_equal(3, bsearch(3.0, table, tol=0.1, tol.ref="y"))

})

test_that("binary search - strings", {

	table <- c("abc", "bc", "bcd", "cde", "def")
	x <- c("abc", "b", "bcde", "cde", "def")
	
	expect_equal(c(1, NA, NA, 4, 5), bsearch(x, table))
	expect_equal(c(1, 2, 3, 4, 5), bsearch(x, table, nearest=TRUE))
	expect_equal(NA_integer_, bsearch("z", table))
	expect_equal(5, bsearch("z", table, nearest=TRUE)) # should this be expected??

})

test_that("approx search (sorted) - integers", {

	keys <- c(1L, 2L, 3L, 4L, 5L, 8L, 9L, 100L, 101L, 102L)
	vals <- keys^1.11
	x <- c(1L, 4L, 6L, 99L, 102L)

	expect_equal(vals[c(1, 4, NA, NA, 10)], asearch(x, keys, vals))
	expect_equal(vals[c(1, 4, 5, 8, 10)], asearch(x, keys, vals, tol=Inf))
	expect_equal(vals[rev(c(1, 4, NA, NA, 10))], asearch(rev(x), keys, vals))
	expect_equal(vals[rev(c(1, 4, 5, 8, 10))], asearch(rev(x), keys, vals, tol=Inf))

})

test_that("approx search (unsorted) - integers", {

	keys <- rev(c(1L, 2L, 3L, 4L, 5L, 8L, 9L, 100L, 101L, 102L))
	vals <- keys^1.11
	x <- c(1L, 4L, 6L, 99L, 102L)

	expect_equal(vals[c(10, 7, NA, NA, 1)], asearch(x, keys, vals))
	expect_equal(vals[c(10, 7, 6, 3, 1)], asearch(x, keys, vals, tol=Inf))
	expect_equal(vals[rev(c(10, 7, NA, NA, 1))], asearch(rev(x), keys, vals))
	expect_equal(vals[rev(c(10, 7, 6, 3, 1))], asearch(rev(x), keys, vals, tol=Inf))

})

test_that("approx search (sorted) - doubles", {

	keys <- c(1.11, 2.22, 3.33, 4.0, 5.0)
	vals <- keys^1.11
	x <- c(1.11, 3.0, 3.33, 5.0, 5.1)

	expect_equal(vals[c(1, NA, 3, 5, NA)], asearch(x, keys, vals))
	expect_equal(vals[c(1, 3, 3, 5, 5)], asearch(x, keys, vals, tol=Inf))
	expect_equal(NA_real_, asearch(3.0, keys, vals, tol=0))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=0.5))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=Inf))
	expect_equal(NA_real_, asearch(3.0, keys, vals, tol=0.1, tol.ref="x"))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=0.2, tol.ref="x"))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=0.1, tol.ref="y"))

})

test_that("approx search (unsorted) - doubles", {

	keys <- rev(c(1.11, 2.22, 3.33, 4.0, 5.0))
	vals <- keys^1.11
	x <- c(1.11, 3.0, 3.33, 5.0, 5.1)

	expect_equal(vals[c(5, NA, 3, 1, NA)], asearch(x, keys, vals))
	expect_equal(vals[c(5, 3, 3, 1, 1)], asearch(x, keys, vals, tol=Inf))
	expect_equal(NA_real_, asearch(3.0, keys, vals, tol=0))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=0.5))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=Inf))
	expect_equal(NA_real_, asearch(3.0, keys, vals, tol=0.1, tol.ref="x"))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=0.2, tol.ref="x"))
	expect_equal(vals[3], asearch(3.0, keys, vals, tol=0.1, tol.ref="y"))

})

test_that("approx search (sorted) - strings", {

	keys <- c("a", "b", "c", "d", "e")
	vals <- c(1.11, 2.22, 3.33, 4.0, 5.0)
	x <- c("a", "c", "ee")

	expect_equal(vals[c(1, 3, NA)], asearch(x, keys, vals))
	expect_equal(vals[c(1, 3, 5)], asearch(x, keys, vals, tol=Inf))

})

test_that("approx search (unsorted) - strings", {

	keys <- rev(c("a", "b", "c", "d", "e"))
	vals <- rev(c(1.11, 2.22, 3.33, 4.0, 5.0))
	x <- c("a", "c", "ee")

	expect_equal(vals[c(5, 3, NA)], asearch(x, keys, vals))
	expect_equal(vals[c(5, 3, 1)], asearch(x, keys, vals, tol=Inf))

})

test_that("approx search (sorted) - interpolation", {

	keys <- c(1.0, 1.01, 1.11, 2.0, 2.22, 3.0, 3.33, 3.333, 4.0)
	vals <- keys
	x <- c(1.0, 2.0, 3.33, 5.0)

	expect_equal(c(1.0, 2.0, 3.33, NA), asearch(x, keys, vals))
	expect_equal(c(1.0, 2.0, 3.33, NA), asearch(x, keys, vals, tol=0.5))

	test1 <- c(1.0+1.01+1.11, 2.0+2.22, 3.0+3.33+3.333, NA)
	expect_equal(test1, asearch(x, keys, vals, tol=0.5, interp="sum"))

	test2 <- c((1.0+1.01+1.11)/3, (2.0+2.22)/2, (3.0+3.33+3.333)/3, NA)
	expect_equal(test2, asearch(x, keys, vals, tol=0.5, interp="mean"))

	test3 <- c(1.11, 2.22, 3.333, NA)
	expect_equal(test3, asearch(x, keys, vals, tol=0.5, interp="max"))

	x2 <- seq(from=1, to=3, by=0.2)
	expect_equal(x2, asearch(x2, keys, vals, tol=1, interp="linear"))
	expect_equal(x2, asearch(x2, keys, vals, tol=2, interp="cubic"))

	x3 <- seq(from=1, to=3, by=0.05)
	expect_equal(x3, asearch(x3, keys, vals, tol=1, interp="linear"))

})

test_that("approx search (unsorted) - interpolation", {

	keys <- rev(c(1.0, 1.01, 1.11, 2.0, 2.22, 3.0, 3.33, 3.333, 4.0))
	vals <- keys
	x <- c(1.0, 2.0, 3.33, 5.0)

	expect_equal(c(1.0, 2.0, 3.33, NA), asearch(x, keys, vals))
	expect_equal(c(1.0, 2.0, 3.33, NA), asearch(x, keys, vals, tol=0.5))

	test1 <- c(1.0+1.01+1.11, 2.0+2.22, 3.0+3.33+3.333, NA)
	expect_equal(test1, asearch(x, keys, vals, tol=0.5, interp="sum"))

	test2 <- c((1.0+1.01+1.11)/3, (2.0+2.22)/2, (3.0+3.33+3.333)/3, NA)
	expect_equal(test2, asearch(x, keys, vals, tol=0.5, interp="mean"))

	test3 <- c(1.11, 2.22, 3.333, NA)
	expect_equal(test3, asearch(x, keys, vals, tol=0.5, interp="max"))

	x2 <- seq(from=1, to=3, by=0.2)
	expect_equal(x2, asearch(x2, keys, vals, tol=1, interp="linear"))
	expect_equal(x2, asearch(x2, keys, vals, tol=2, interp="cubic"))

	x3 <- seq(from=1, to=3, by=0.05)
	expect_equal(x3, asearch(x3, keys, vals, tol=1, interp="linear"))

})

