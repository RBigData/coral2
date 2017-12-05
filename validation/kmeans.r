suppressMessages(library(kazaam, quietly=TRUE))

source("./utils.r")
data = read.iris("./iris.csv")
iris = data$iris
species = data$species

# best of 100 starts
rand = numeric(100)
for (i in 1:100){
  labels = km(iris, k=3, seed=i)$labels
  l1 = collapse(labels)
  l2 = collapse(species)
  if (comm.rank() == 0)
    rand[i] = rand_measure(l1, l2)
}

comm.print(max(rand))


finalize()
