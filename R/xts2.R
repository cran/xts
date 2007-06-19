`xts2` <-
function(x=NULL,order.by=index(x),frequency=NULL,...) {
  if(!timeBased(order.by))
    stop("order.by requires an appropriate time-based object")

  orderBy <- class(order.by)

  z <- structure(zoo(x=coredata(x),
                   order.by=as.POSIXct(order.by),
                   frequency=frequency),
                   class=c('xts','zoo'),...)

  xtsAttributes(z) <- list(.indexClass=orderBy)

  if(!is.null(dim(x))) {
    attr(z,'.ROWNAMES') <- dimnames(z)[[1]]
    rownames(z) <- as.character(index(z))
  }

  return(z)
}
