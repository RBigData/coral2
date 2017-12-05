suppressMessages(library(kazaam, quietly=TRUE))

source("./utils.r")
iris = read.iris("./iris.csv")$iris

svd = svd(iris)
u = svd$u
d = diag(svd$d)
vt = t(svd$v)

tol = sqrt(.Machine$double.eps)

test.local = isTRUE(all.equal(iris, u %*% d %*% vt, check.attributes=FALSE, tolerance=tol))
test = comm.all(test.local)
comm.print(test)


finalize()
