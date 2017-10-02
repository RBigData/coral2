#define ARMA_DONT_USE_WRAPPER

#include <armadillo>
#include <cstdio>
#include <mpi.h>
#include <string>

#define ALLREDUCE(X) MPI_Allreduce(MPI_IN_PLACE, X.memptr(), X.n_elem, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD)

class Shaq
{
  public:
    Shaq()
    {
      MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    };
    
    void ranshaq(int seed, arma::uword m_local, arma::uword n)
    {
      int size;
      
      MPI_Comm_size(MPI_COMM_WORLD, &size);
      
      Data.resize(m_local, n);
      arma::arma_rng::set_seed(seed + rank);
      Data.randn();
      
      nrows = m_local*size;
      ncols = n;
    };
    
    void center()
    {
      arma::rowvec colmeans = sum(Data, 0);
      ALLREDUCE(colmeans);
      colmeans /= (double) nrows;
      Data.each_row() -= colmeans;
    };
    
    arma::mat Data;
    arma::uword nrows;
    arma::uword ncols;
    int rank;
};

// shows the first and last singular values, computed via covariance matrix
static arma::vec princomp(Shaq &X)
{
  X.center();
  arma::mat Cov = X.Data.t() * X.Data;
  Cov /= X.nrows - 1;
  ALLREDUCE(Cov);
  
  arma::vec d;
  eig_sym(d, Cov); 
  
  return sqrt(d);
}

static void get_dims(int argc, char **argv, arma::uword *m_local, arma::uword *n)
{
  
  if (argc != 3)
  {
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0)
      fprintf(stderr, "ERROR incorrect number of arguments: usage is 'mpirun -np n princomp num_local_rows num_global_cols\n");
    
    exit(-1);
  }
  
  *m_local = (arma::uword) std::stoi(argv[1]);
  *n = (arma::uword) std::stoi(argv[2]);
}



int main(int argc, char **argv)
{
  arma::uword m_local, n;
  MPI_Init(NULL, NULL);
  
  get_dims(argc, argv, &m_local, &n);
  
  Shaq X;
  X.ranshaq(1234, m_local, n);
  
  arma::vec d = princomp(X);
  
  if (X.rank == 0)
    printf("%f %f\n", d[n-1], d[0]);
    
  MPI_Finalize();
  return 0;
}
