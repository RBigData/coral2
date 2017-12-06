suppressMessages(library(kazaam, quietly=TRUE))

source("./utils.r")
data = read.iris("./iris.csv")
iris = data$iris
iris = cbind(shaq(1, nrow=nrow(iris), ncol=1), iris) # add intercept
is.setosa = (data$species == 1)*2 - 1 # code to +/- 1

mdl = svm(iris, is.setosa)
w = mdl$par

pred = sign(DATA(iris) %*% w)
acc.local = sum(pred == DATA(is.setosa))
acc = allreduce(acc.local) / nrow(iris) * 100

comm.print(acc)


finalize()
