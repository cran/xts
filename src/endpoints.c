#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>

SEXP endpoints (SEXP _x, SEXP _on, SEXP _k, SEXP _addlast /* TRUE */)
{
  /*
      efficient implementation of:

        c(0,which(diff(_x%/%on%/%k+1) != 0),NROW(_x))
  */
  int *int_index = NULL;
  double *real_index = NULL;
  int i=1,j=1, nr, P=0;
  int int_tmp[2];
  double real_tmp[2];

  /* shouldn't force to INTSXP, as this now excludes
     microsecond and millisecond calculations  FIXME */
  int on = INTEGER(coerceVector(_on,INTSXP))[0];
  int k  = INTEGER(coerceVector(_k,INTSXP))[0];
  nr = nrows(_x);

  /* ensure k > 0 (bug #4920) */
  if(k <= 0) error("'k' must be > 0");

  /* endpoints objects. max nr+2 ( c(0,ep,nr) ) */
  SEXP _ep = PROTECT(allocVector(INTSXP,nr+2)); P++;
  int *ep = INTEGER(_ep);

  
  /*switch(TYPEOF(getAttrib(_x, install("index")))) {*/
  switch(TYPEOF(_x)) {
    case INTSXP:
      /* start i at second elem */
      /*int_index = INTEGER(getAttrib(_x, install("index")));*/
      int_index = INTEGER(_x);
      ep[0] = 0;
      /* special handling if index values < 1970-01-01 00:00:00 UTC */
      if(int_index[0] < 0) {
          for(i=1,j=1; i<nr; i++) {
            int idx_i0 = int_index[i];
            int idx_i1 = int_index[i-1];

            // if index equals epoch
            int epoch_adj = (idx_i0 == 0);
            // cast truncates toward zero
            // (i.e. *forward* in time if index < 0)
            if(idx_i0 < 0) idx_i0++;
            if(idx_i1 < 0) idx_i1++;

            int_tmp[0] = idx_i0 / on / k + epoch_adj;
            int_tmp[1] = idx_i1 / on / k;
            if( (int_tmp[0] - int_tmp[1]) != 0 ) {
              ep[j] = i;
              j++;
            }
          }
      } else {
          for(i=1,j=1; i<nr; i++) {
            int_tmp[0] = int_index[i] / on / k +1;
            int_tmp[1] = int_index[i-1] / on / k +1;
            if( (int_tmp[0] - int_tmp[1]) != 0 ) {
              ep[j] = i;
              j++;
            }
          }
      }
      break;
    case REALSXP:
      /*real_index = REAL(getAttrib(_x, install("index")));*/
      real_index = REAL(_x);
      ep[0] = 0;
      /* special handling if index values < 1970-01-01 00:00:00 UTC */
      if(real_index[0] < 0) {
          for(i=1,j=1; i<nr; i++) {
            double idx_i0 = real_index[i];
            double idx_i1 = real_index[i-1];

            // if index equals epoch
            int epoch_adj = (idx_i0 == 0);
            // cast truncates toward zero
            // (i.e. *forward* in time if index < 0)
            if(idx_i0 < 0) idx_i0 += 1.0;
            if(idx_i1 < 0) idx_i1 += 1.0;

            real_tmp[0] = (long)(idx_i0 / on / k + epoch_adj);
            real_tmp[1] = (long)(idx_i1 / on / k);
            if( (real_tmp[0] - real_tmp[1]) != 0) {
              ep[j] = i;
              j++;
            }
          }
      } else {
          for(i=1,j=1; i<nr; i++) {
            real_tmp[0] = (long)real_index[i] / on / k +1;
            real_tmp[1] = (long)real_index[i-1] / on / k +1;
            if( (real_tmp[0] - real_tmp[1]) != 0 ) {
              ep[j] = i;
              j++;
            }
          }
      }
      break;
    default:
      error("unsupported 'x' type");
      break;
  }
  if(ep[j-1] != nr && asLogical(_addlast)) { /* protect against endpoint at NR */
/* Rprintf("ep[%i-1] != %i\n", j, nr);  */
    ep[j] = nr;
    j++;
  }
  PROTECT(_ep = lengthgets(_ep, j)); P++;
  UNPROTECT(P);
  return(_ep);
}
