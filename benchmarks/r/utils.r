args = commandArgs(trailingOnly = TRUE)

suppressMessages(library(stats, quietly=TRUE))
suppressMessages(library(kazaam, quietly=TRUE))

get_dims = function(args)
{
  if (interactive())
    comm.stop("the test must be run in batch")
  
  if (length(args) != 2)
    comm.stop(" incorrect number of arguments: usage is 'mpirun -np n Rscript princomp.r num_local_rows num_global_cols")
  
  m.local = as.double(args[1])
  n = as.double(args[2])
  
  list(m.local=m.local, n=n)
}

dims = get_dims(args)
m.local = dims$m.local
n = dims$n
