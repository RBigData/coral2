source("./utils.r")
comm.set.seed(1234, diff=FALSE)
if (storage == "float")
  comm.stop("float not supported for svm")


generator = function(m, n, means=c(0, 2))
{
  response = c(-1L, 1L)
  
  x = matrix(0.0, m, n+1)
  y = integer(m)
  
  for (i in 1:m)
  {
    group = sample(2, size=1)
    x[i, ] = c(1, rnorm(n, mean=means[group]))
    y[i] = response[group]
  }
  
  list(x=x, y=y)
}


data = generator(m.local, n)
m = allreduce(m.local)
x = shaq(data$x, nrows=m, ncols=n+1)
y = shaq(data$y, nrows=m, ncols=1)

time = comm.timer(svm(x, y, maxiter=500))
comm.print(time)

finalize()
