match_call <- compiler::cmpfun(function(...)
{
  callexp <- match.call(expand.dots = TRUE)
  eval.parent(callexp$foo)
})

subst_alist <- compiler::cmpfun(function(...)
{
  callexp <- eval(substitute(alist(...)))
  eval.parent(callexp$foo)
})

library(microbenchmark)
microbenchmark(match_call(foo = "bar"), subst_alist(foo = "bar"))

