/*
#   xts: eXtensible time-series 
#
#   Copyright (C) 2008  Jeffrey A. Ryan jeff.a.ryan @ gmail.com
#
#   Contributions from Joshua M. Ulrich
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include "xts.h"

SEXP diffXts(SEXP x, SEXP lag, SEXP diff, SEXP arith, SEXP nap, SEXP dots)
{
  return R_NilValue;
}


SEXP lagXts(SEXP x, SEXP k, SEXP pad)
{
  SEXP result;
  int nrs, ncs;
  int i, j, ij, iijj, K, NApad;
  int mode;
  int P=0; /*PROTECT counter*/
  int *int_result=NULL, *int_x=NULL;
  int *lgl_result=NULL, *lgl_x=NULL;
  double *real_result=NULL, *real_x=NULL;
  
  int *int_oindex=NULL, *int_nindex=NULL;
  double *real_oindex=NULL, *real_nindex=NULL;
  
  nrs = nrows(x);
  ncs = ncols(x);

  K = INTEGER(k)[ 0 ];
  K = (K > nrs) ? nrs : K;

  mode = TYPEOF(x);

  NApad = INTEGER(pad)[ 0 ];

  if(NApad) {
    PROTECT(result = allocVector(TYPEOF(x), nrs*ncs)); P++;
  } else {
    if(K > 0) {
      PROTECT(result = allocVector(TYPEOF(x), (nrs-K)*ncs)); P++;
    } else {
      PROTECT(result = allocVector(TYPEOF(x), (nrs+K)*ncs)); P++;
    }
  }

  switch( TYPEOF(x) ) {
    case LGLSXP:
        lgl_x = LOGICAL(x);
        lgl_result = LOGICAL(result);
        break;
    case INTSXP:
        int_x = INTEGER(x);
        int_result = INTEGER(result);
        break;
    case REALSXP:
        real_x = REAL(x);
        real_result = REAL(result);
        break;
    case CPLXSXP:
    case STRSXP:
    case VECSXP:
    case RAWSXP:
        break;
    default:
        error("unsupported type");
        break;
  }

  for(i = 0; i < nrs; i++) {
  /*
   need to figue out how many duplicate values we have, in order to know how far to go back.
   probably best accomplished with some sort of look-ahead approach, though this may be messy
   if k is negative...
   
   something like:
     while( i+tmp+K < nrs && xindex[i] == xindex[i+tmp_K] )
       tmp_K++;
  */
  for(j = 0; j < ncs; j++) {
    ij = i + j * nrs;
    if(i < K ||
       (K < 0 && i > (nrs+K-1)) ) { 
    /* Pad NA values at beginning */
      if(NApad) {
      switch ( mode ) {
        case LGLSXP:
             lgl_result[ ij ] = NA_INTEGER;
             break;
        case INTSXP:
             int_result[ ij ] = NA_INTEGER;
             break;
        case REALSXP:
             real_result[ ij ] = NA_REAL;
             break;
        case CPLXSXP:
             COMPLEX(result)[ij].r = NA_REAL;
             COMPLEX(result)[ij].i = NA_REAL;
             break;
        case STRSXP:
             SET_STRING_ELT(result, ij, NA_STRING);
             break;
        case VECSXP:
             SET_VECTOR_ELT(result, ij, R_NilValue);
             break;
        case RAWSXP:
             RAW(result)[ij] = (Rbyte) 0;
             break;
        default:
             error("matrix subscripting not handled for this type");
             break;
      } /* NA insertion */
      } /* NApad */
    } else {
      iijj = i - K + j * nrs; /* move back K positions to get data */
      if(!NApad && K > 0) ij = i - K + j * (nrs - K);   /* if not padding, start at the correct spot */
      if(!NApad && K < 0) ij = i + j * (nrs + K);   /* if not padding, start at the correct spot */
      switch ( mode ) {
        case LGLSXP:
             lgl_result[ ij ] = lgl_x[ iijj ];
             break;
        case INTSXP:
             int_result[ ij ] = int_x[ iijj ];
             break;
        case REALSXP:
             real_result[ ij ] = real_x[ iijj ];
             break;
        case CPLXSXP:
             COMPLEX(result)[ij] = COMPLEX(x)[iijj];
             break;
        case STRSXP:
             SET_STRING_ELT(result, ij, STRING_ELT(x, iijj));
             break;
        case VECSXP:
             SET_VECTOR_ELT(result, ij, VECTOR_ELT(x, iijj));
             break;
        case RAWSXP:
             RAW(result)[ij] = RAW(x)[iijj];
             break;
        default:
             error("matrix subscripting not handled for this type");
             break;
      }
    }
  } /* j-loop */
  } /* i-loop */

  setAttrib(result, R_ClassSymbol, getAttrib(x, R_ClassSymbol));
  if(!NApad) { /* No NA padding */
    SEXP oindex, nindex, dims;
    int nRows = (K > 0) ? nrs-K : nrs+K;
    int incr  = (K > 0) ? K : 0;
    PROTECT(oindex = getAttrib(x, xts_IndexSymbol));
    PROTECT(nindex = allocVector(TYPEOF(oindex), nRows));
    switch(TYPEOF(oindex)) {
      case REALSXP:
        real_oindex = REAL(oindex);
        real_oindex = real_oindex + incr;
        real_nindex = REAL(nindex); 
        for( i = 0; i < nRows; real_nindex++, real_oindex++, i++)
          *real_nindex = *real_oindex;
        break;
      case INTSXP:
        int_oindex = INTEGER(oindex);
        int_oindex = int_oindex + incr;
        int_nindex = INTEGER(nindex);
        for( i = 0; i < nRows; int_nindex++, int_oindex++, i++)
          *int_nindex = *int_oindex;
        break;
      default:
        break;
    }
    setAttrib(result, xts_IndexSymbol, nindex);
    PROTECT(dims = allocVector(INTSXP, 2));
    INTEGER(dims)[0] = nRows;
    INTEGER(dims)[1] = ncs;
    setAttrib(result, R_DimSymbol, dims);
    setAttrib(result, R_DimNamesSymbol, getAttrib(x, R_DimNamesSymbol));
    UNPROTECT(3);
  } else {
    /* NA pad */
    setAttrib(result, xts_IndexSymbol, getAttrib(x, xts_IndexSymbol));
    setAttrib(result, R_DimSymbol, getAttrib(x, R_DimSymbol));
    setAttrib(result, R_DimNamesSymbol, getAttrib(x, R_DimNamesSymbol));
  }
  setAttrib(result, xts_ClassSymbol, getAttrib(x, xts_ClassSymbol));

  UNPROTECT(P);
  return result;
}

SEXP lag_xts (SEXP x, SEXP _k, SEXP _pad) {
  /* this will eventually revert to NOT changing R default behaviors 
     for now it uses the 'standard' convention adopted by xts        */

  int k = asInteger(_k);
  /* ensure args are correct types; error if conversion fails */
  if(k == NA_INTEGER)
    error("'k' must be integer");
  if(asLogical(_pad) == NA_LOGICAL)
    error("'na.pad' must be logical");

  k = k * -1; /* change zoo default negative handling */
  return zoo_lag (x, ScalarInteger(k), _pad);
}

SEXP lagts_xts (SEXP x, SEXP _k, SEXP _pad) {
  /* this will use positive values of lag for carrying forward observations
 
     i.e. y = lagts(x, 1) is y(t) = x(t-1)
  */

  int k = asInteger(_k)*-1; /* change zoo default negative handling */
  /* ensure args are correct types; error if conversion fails */
  if(k == NA_INTEGER)
    error("'k' must be integer");
  if(asLogical(_pad) == NA_LOGICAL)
    error("'na.pad' must be logical");

  return zoo_lag (x, ScalarInteger(k), _pad);
}
