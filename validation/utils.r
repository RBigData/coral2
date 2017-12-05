read.iris = function(file="iris.csv")
{
  if (comm.rank() == 0)
  {
    iris = read.csv(file=file)
    species = iris$Species
    iris$Species = NULL
    iris = as.matrix(iris)
  }
  else
  {
    iris = NULL
    species = NULL
  }
  
  iris = kazaam::expand(iris)
  species = kazaam::expand(species)
  list(iris=iris, species=species)
}



# reference: https://en.wikipedia.org/wiki/Rand_index
rand_measure = function(l1, l2)
{
  n = length(l1)
  a = b = 0L

  for (i in 1:n)
  {
    for (j in (i+1L):n)
    {
      if (j > n) # R indexing is stupid
        break
      
      same1 = (l1[i] == l1[j])
      same2 = (l2[i] == l2[j])
      
      if (same1 && same2)
        a = a + 1L
      else if (!same1 && !same2)
        b = b + 1L
    }
  }
  
  (a + b) / choose(n, 2)
}

rand_measure = compiler::cmpfun(rand_measure)
