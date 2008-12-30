#
#   xts: eXtensible time-series 
#
#   Copyright (C) 2008  Jeffrey A. Ryan jeff.a.ryan @ gmail.com
#
#   Contributions from Joshua M. Ulrich
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


as.numeric.xts <- function(x, drop=TRUE, ...)
{
  if(drop)
    return(as.numeric(unclass(x)))
  .xts(matrix(as.numeric(unclass(x)),nc=NCOL(x)), .index(x))
}

as.integer.xts <- function(x, drop=TRUE, ...)
{
  if(drop)
    return(as.integer(unclass(x)))
  .xts(matrix(as.integer(unclass(x)),nc=NCOL(x)), .index(x))
}

as.double.xts <- function(x, drop=TRUE, ...)
{
  if(drop)
    return(as.double(unclass(x)))
  .xts(matrix(as.double(unclass(x)),nc=NCOL(x)), .index(x))
}

as.complex.xts <- function(x, drop=TRUE, ...)
{
  if(drop)
    return(as.complex(unclass(x)))
  .xts(matrix(as.complex(unclass(x)),nc=NCOL(x)), .index(x))
}

as.logical.xts <- function(x, drop=TRUE, ...)
{
  if(drop)
    return(as.logical(unclass(x)))
  .xts(matrix(as.logical(unclass(x)),nc=NCOL(x)), .index(x))
}