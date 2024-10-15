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


#include "xts.h"
//
//SEXP xts_new (SEXP _data, SEXP _index, SEXP _tclass, SEXP _tzone, SEXP _tformat)
//{
//    PROTECT(result = allocVector(TYPEOF(x), 0)); p++;
//    PROTECT(index  = allocVector(TYPEOF(xindex), 0)); p++;
//    setAttrib(index, xts_IndexTzoneSymbol, getAttrib(xindex, xts_IndexTzoneSymbol));
//    setAttrib(index, xts_IndexTclassSymbol, getAttrib(xindex, xts_IndexTclassSymbol));
//    setAttrib(index, xts_IndexTformatSymbol, getAttrib(xindex, xts_IndexTformatSymbol));
//    setAttrib(result, xts_IndexSymbol, index);
//
//    if (LOGICAL(retclass)[0]) {
//      setAttrib(result, R_ClassSymbol, getAttrib(x, R_ClassSymbol));
//    }
//    setAttrib(result, xts_ClassSymbol, getAttrib(x, xts_ClassSymbol));
//
//}
//

//SEXP xts_set_typeof(SEXP _x, SEXPTYPE _typeof)
//{
//    SEXP _result = PROTECT(allocVector(_typeof, xlength(_x)));
//    xts_set_index(_result, xts_get_index(_x));
//
//}
