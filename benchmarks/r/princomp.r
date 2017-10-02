source("./utils.r")
comm.set.seed(1234, diff=TRUE)

x = ranshaq(rnorm, m.local, n, local=TRUE)

princomp = function(x)
{
  d = eigen(cov(x), only.values=TRUE)$values
  comm.print(c(d[1], d[length(d)]))
}

time = comm.timer(princomp(x))
comm.print(time)

finalize()
