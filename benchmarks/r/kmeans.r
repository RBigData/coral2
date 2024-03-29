source("./utils.r")
comm.set.seed(1234, diff=TRUE)
if (storage == "float")
  comm.stop("float not supported for k-means")


centers = c(0, 2, 10)
k.true = length(centers)

generator = function(m, n, centers)
{
  data = matrix(0.0, m, n)
  for (i in 1:m)
    data[i, ] = rnorm(n, mean=sample(centers, size=1))
  
  data
}

generator = compiler::cmpfun(generator)
data = generator(m.local, n, centers)
m = m.local * comm.size()
x = shaq(data, m, n, checks=FALSE)

time = comm.timer(lapply(2:4, function(k) km(x, k=k, seed=1234, maxiter=2)))

comm.print(time)

finalize()
