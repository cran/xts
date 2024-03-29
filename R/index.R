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


index.xts <- time.xts <-
function(x, ...) {
  value <- tclass(x)
  if(is.null(value) || !nzchar(value[1L])) {
    warning("index does not have a ", sQuote("tclass"), " attribute\n",
            "    returning c(\"POSIXct\", \"POSIXt\")")
    ix <- .index(x)
    attr(ix, "tclass") <- attr(ix, "class") <- c("POSIXct", "POSIXt")
    return(ix)
  }
  #  if tclass is Date, POSIXct time is set to 00:00:00 GMT. Convert here
  #  to avoid ugly and hard to debug TZ conversion.  What will this break? 
  if(value[[1]] == "Date")
    #return( as.Date(.index(x)/86400) )
    return( structure(.index(x) %/% 86400, class="Date")) 
    

  #x.index  <- structure(.index(x), class=c("POSIXct","POSIXt"))
  x.index  <- .POSIXct(.index(x), tz=attr(.index(x), "tzone"))

  if(!is.list(value)) 
    value <- as.list(value)

  switch(value[[1]],
    multitime = as.Date(as.character(x.index)),
    POSIXt = {
      # get specific ct/lt value
      do.call(paste('as',value[[2]],sep='.'),list(x.index))
    },
    POSIXct = as.POSIXct(x.index),
    POSIXlt = as.POSIXlt(x.index),
    timeDate = {
      if(!requireNamespace("timeDate", quietly=TRUE))
          stop("package:",dQuote("timeDate"),"cannot be loaded.")
      timeDate::as.timeDate(x.index)
    },
    chron = ,
    dates = {
      if(!requireNamespace("chron", quietly=TRUE))
        stop("package:",dQuote("chron"),"cannot be loaded.")
      chron::as.chron(format(x.index))
    },
    #Date = as.Date(as.character(x.index)),  # handled above
    yearmon = as.yearmon(x.index),
    yearqtr = as.yearqtr(x.index),
    stop(paste('unsupported',sQuote('tclass'),'indexing type:',value[[1]]))
  )
}

`time<-.xts` <- `index<-.xts` <- function(x, value) {
  if(length(index(x)) != length(value)) stop('length of index vectors does not match')

  if( !timeBased(value) ) 
    stop(paste('unsupported',sQuote('index'),
               'index type of class',sQuote(class(value))))

  # copy original index attributes
  ixattr <- attributes(attr(x, 'index'))

  # set index to the numeric value of the desired index class
  if(inherits(value,"Date"))
    attr(x, 'index') <- structure(unclass(value)*86400, tclass="Date", tzone="UTC")
  else attr(x, 'index') <- as.numeric(as.POSIXct(value))

  # ensure new index is sorted
  if(!isOrdered(.index(x), strictly=FALSE))
    stop("new index needs to be sorted")

  # set tclass attribute to the end-user specified class
  attr(attr(x, 'index'), 'tclass') <- class(value)

  # set tzone attribute
  if(isClassWithoutTZ(object = value)) {
    attr(attr(x, 'index'), 'tzone') <- 'UTC'
  } else {
    if (is.null(attr(value, 'tzone'))) {
      # ensure index has tzone attribute if value does not
      attr(attr(x, 'index'), 'tzone') <- ixattr[["tzone"]]
    } else {
      attr(attr(x, 'index'), 'tzone') <- attr(value, 'tzone')
    }
  }
  return(x)
}

`.index` <- function(x, ...) {
  if(is.list(attr(x, "index"))) {
    attr(x, 'index')[[1]]
  } else attr(x, "index")
}

`.index<-` <- function(x, value) {
  if(timeBased(value)) {
    if(inherits(value, 'Date')) {
      attr(x, 'index') <- as.numeric(value)
    } else {
      attr(x, 'index') <- as.numeric(as.POSIXct(value))
    }
  } else 
  if(is.numeric(value)) {
    attr(value, 'tclass') <- tclass(x)
    attr(value, 'tzone') <- tzone(x)
    attr(x, 'index') <- value
  } else stop(".index is used for low level operations - data must be numeric or timeBased")
  return(x)
}

`.indexsec` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$sec
}
`.indexmin` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$min
}
`.indexhour` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$hour
}
`.indexmday` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$mday
}
`.indexmon` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$mon
}
`.indexyear` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$year
}
`.indexwday` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$wday
}
`.indexbday` <- function(x) {
  # is business day T/F
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$wday %% 6 > 0
}
`.indexyday` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$yday
}
`.indexisdst` <- function(x) {
  as.POSIXlt(.POSIXct(.index(x), tz=tzone(x)))$isdst }
`.indexDate` <- `.indexday` <- function(x) {
  .index(x) %/% 86400L
}
`.indexweek` <- function(x) {
  (.index(x) + (3 * 86400)) %/% 86400 %/% 7
}
`.indexyweek` <- function(x) {
  ((.index(x) + (3 * 86400)) %/% 86400 %/% 7) -
    ((startOfYear() * 86400 + (3 * 86400)) %/% 86400 %/% 7)[.indexyear(x) + 1]
}

.update_index_attributes <- function(x) {
  suppressWarnings({
    tclass(x) <- tclass(x)
    tzone(x) <- tzone(x)
  })
  return(x)
}
