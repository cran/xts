#
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


na.omit.xts <- function(object, ...) {
  xx <- .Call(C_na_omit_xts, object)
  if(length(xx)==0)
    return(structure(xts(,),.Dim=c(0,NCOL(object))))
  naa <- attr(xx,'na.action')
  if(length(naa) == 0)
    return(xx)

  naa.index <- .index(object)[naa]

  ROWNAMES <- attr(object,'.ROWNAMES')
  if(!is.null(ROWNAMES)) {
    naa.rownames <- ROWNAMES[naa]
  } else naa.rownames <- NULL

  attr(xx,'na.action') <- structure(naa,
                                    index=naa.index,
                                    .ROWNAMES=naa.rownames)
  return(xx) 
}

na.exclude.xts <- function(object, ...) {
  xx <- .Call(C_na_omit_xts, object)
  naa <- attr(xx,'na.action')
  if(length(naa) == 0)
    return(xx)

  naa.index <- .index(object)[naa]

  ROWNAMES <- attr(object,'.ROWNAMES')
  if(!is.null(ROWNAMES)) {
    naa.rownames <- ROWNAMES[naa]
  } else naa.rownames <- NULL

  attr(xx,'na.action') <- structure(naa,
                                    class="exclude",
                                    index=naa.index,
                                    .ROWNAMES=naa.rownames)
  return(xx) 
}

na.restore <- function(object, ...) {
  UseMethod("na.restore")
}

na.restore.xts <- function(object, ...) {
  if(is.null(na.action(object))) 
    return(object)
  structure(merge(structure(object,na.action=NULL),
            .xts(,attr(na.action(object),"index"))),
            .Dimnames=list(NULL, colnames(object)))
}

na.replace <- function(x) {
  .Deprecated("na.restore")
  if(is.null(xtsAttributes(x)$na.action))
    return(x)

  # Create 'NA' xts object
  tmp <- xts(matrix(rep(NA,NCOL(x)*NROW(x)), ncol=NCOL(x)),
             attr(xtsAttributes(x)$na.action, 'index'))

  # Ensure xts 'NA' object has *all* the same attributes
  # as the object 'x'; this is necessary for rbind to
  # work correctly
  CLASS(tmp) <- CLASS(x)
  xtsAttributes(tmp) <- xtsAttributes(x)
  attr(x,'na.action') <- attr(tmp,'na.action') <- NULL
  colnames(tmp) <- colnames(x)

  rbind(x,tmp)
}

na.locf.xts <- function(object, na.rm=FALSE, fromLast=FALSE, maxgap=Inf, ...) {
    maxgap <- min(maxgap, NROW(object))
    if(length(object) == 0)
      return(object)
    if(hasArg("x") || hasArg("xout"))
      return(NextMethod(.Generic))
    x <- .Call(C_na_locf, object, fromLast, maxgap, Inf)
    if(na.rm) {
      return(structure(na.omit(x),na.action=NULL))
    } else x
}

na.fill.xts <- function(object, fill, ix, ...) {
  if (length(fill) == 1 && missing(ix)) {
    # na.fill0() may change the storage type of 'object'
    # make sure 'fill' argument is same type as 'object'
    fill. <- fill
    storage.mode(fill.) <- storage.mode(object)

    return(na.fill0(object, fill.))
  } else {
    NextMethod(.Generic)
  }
}
