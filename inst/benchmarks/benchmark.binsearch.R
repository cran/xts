stopifnot(require("microbenchmark"))
# Benchmark binary search
N <- 2e7L
n <- 100
set.seed(21)
ivec <- sample(N*5L, N)
ikeys <- sample(N, n)
dvec <- ivec * 1.0
dkeys <- ikeys * 1.0

binsearch <- xts:::binsearch

# warmup, in case there's any JIT
for (i in 1:2) {
  binsearch(ikeys[i], ivec, TRUE)
  binsearch(ikeys[i], ivec, FALSE)
  binsearch(dkeys[i], dvec, TRUE)
  binsearch(dkeys[i], dvec, FALSE)
}

profile <- FALSE
if (profile) {
  # Use loop if profiling, so microbenchmark calls aren't included
  Rprof(line.profiling = TRUE)
  for(i in seq_len(n)) {
    binsearch(ikeys[i], ivec, TRUE)
    binsearch(ikeys[i], ivec, FALSE)
    binsearch(dkeys[i], dvec, TRUE)
    binsearch(dkeys[i], dvec, FALSE)
  }
  Rprof(NULL)
  print(srp <- summaryRprof())
} else {
  mb <- vector("list", n)
  for(i in seq_along(mb)) {
    mb[[i]] <- microbenchmark(times = 10,
      binsearch(ikeys[i], ivec, TRUE),
      binsearch(ikeys[i], ivec, FALSE),
      binsearch(dkeys[i], dvec, TRUE),
      binsearch(dkeys[i], dvec, FALSE))
  }
  print(do.call(rbind, mb))
}
