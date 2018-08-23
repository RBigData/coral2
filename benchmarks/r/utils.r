args = commandArgs(trailingOnly=TRUE)

suppressMessages(library(stats, quietly=TRUE))
suppressMessages(library(kazaam, quietly=TRUE))

get_dims = function(args)
{
  if (interactive())
    comm.stop("the test must be run in batch")
  
  if (length(args) != 3)
    comm.stop(" incorrect number of arguments: usage is 'mpirun -np n Rscript $BENCHMARK.r storage num_local_rows num_global_cols")
  
  m.local = as.double(args[2])
  n = as.double(args[3])
  
  list(m.local=m.local, n=n)
}

dims = get_dims(args)
m.local = dims$m.local
n = dims$n

storage = args[1]
if (storage != "float" && storage != "double")
  comm.stop("storage must be 'float' or 'double'")
