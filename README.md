# Big Data Benchmarks

This is a set of three "big data" benchmarks. The benchmarks utilize three very common statistics/machine learning techniques, namely principal components analysis (PCA), k-means clustering, and support vector machine (SVM). This gives one dimension reduction technique, one unsupervised technique, and one supervised technique.

For each benchmark, the data must be distributed across ranks by row, and is assumed to be taller than it is wide. Each uses MPI for communication.

Of the three benchmarks, all are available as parallel R codes, and one (PCA) is additionally available as a standalone C++ code. For each of the R benchmarks, you will need to install install the kazaam package and all of its dependencies which are available in the `source/` tree. To install the C++ code (for the PCA benchmark), it should be enough to just run `make`. See `source/README` for details.



## Running the Bencharks

Each of the benchmarks (R and C++ alike) accepts a number of *local* rows and *global* columns. The total number of rows grows proportionally to the number of MPI ranks. Thus, each benchmark measures scaling in the weak sense.

Run the C++ code from the project root via:
```
mpirun -np num_ranks ./source/cxx/build/princomp num_local_rows num_global_cols
```
Run the R code via:
```
mpirun -np num_ranks Rscript princomp.r num_local_rows num_global_cols
```
For example, to run the MPI code with 16 ranks, 50 total columns, and a total of 16,000 rows (local number of rows 1000), you would run:
```
mpirun -np 16 princomp 1000 50
```

For example, to generate 1 GB local sizes with 100 columns, you would need to specify 1250000 local rows. For a 1 GiB local size with 100 columns, you would need 1342177 local rows.



## Benchmark Details

Below we describe the benchmarks in detail.

### PCA

The benchmark is defined as computing the first and last of the "standard deviations" from a PCA on a distributed matrix by way of taking the square roots of the eigenvalues of the covariance matrix. The "first and last" requirement is to avoid approximate methods. Using the covariance matrix is mathematically equivalent to computing the SVD of the mean-centered input matrix, although it is computationally easier. The data should be random normal.

Unlike the other benchmarks, the PCA benchmark is available in both R and C++. Our implementation of the R benchmark can be found at `benchmarks/r/kmeans.r`. The C++ benchmark is self-contained; simply run the executable generated from running `make` in `source/cxx/`.

### k-means

The benchmark is defined by computing the observation labels (class assignments) and centroids for k=2, 3, and 4. The data should consist of rows sampled from one of 3 random normal distributions: one with mean 0, one with mean 2, and one with mean 10. Each should have variance 1. The rows should be drawn at random from these distributions.

Our implementation of the benchmark can be found at `benchmarks/r/kmeans.r`.

### SVM

The benchmark consists of a linear 2-class SVM fit, calculating the feature weights. The data matrix of predictors should be random normal. The response should be taken to be 1 if the first predictor is greater than 0, and -1 otherwise.

Our implementation of the benchmark can be found at `benchmarks/r/svm.r`.
