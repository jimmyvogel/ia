#include <mpi.h>
#include <stdio.h>
int main ( int argc , char **argv )
{
  int pid, nprocs;  
  MPI_Init (&argc , &argv) ;
  MPI_Comm_rank(MPI_COMM_WORLD, &pid ) ;
  MPI_Comm_size (MPI_COMM_WORLD, &nprocs ) ;
  printf( " I am %d of %d\n" , pid , nprocs) ;
  MPI_Finalize( ) ;
  return 0 ;
}
