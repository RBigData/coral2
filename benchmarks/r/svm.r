source("./utils.r")
comm.set.seed(1234, diff=FALSE)

x = ranshaq(rnorm, m.local, n, local=TRUE)

data.y = matrix(ifelse(Data(x[, 1])>0, 1, -1), ncol=1)
y = shaq(data.y, m.local, checks=FALSE)

time = comm.timer(svm(x, y))
comm.print(time)

finalize()
