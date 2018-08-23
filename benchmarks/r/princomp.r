source("./utils.r")
comm.set.seed(1234, diff=TRUE)

x = ranshaq(rnorm, m.local, n, local=TRUE)

if (storage == "float")
{
  suppressMessages(library(float, quietly=TRUE))
  x = shaq(fl(DATA(x)))
}

princomp = function(x)
{
  d = eigen(cov(x), only.values=TRUE)$values
  comm.print(c(d[1], d[length(d)]))
}

time = comm.timer(princomp(x))
comm.print(time)

finalize()
