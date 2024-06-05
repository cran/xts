% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tformat.R
\name{tformat}
\alias{tformat}
\alias{tformat<-}
\alias{indexFormat}
\alias{indexFormat<-}
\title{Get or Replace the Format of an xts Object's Index}
\usage{
tformat(x, ...)

tformat(x) <- value

indexFormat(x)

indexFormat(x) <- value
}
\arguments{
\item{x}{An xts object.}

\item{\dots}{Arguments passed to other methods.}

\item{value}{New index format string (see \code{\link[=strptime]{strptime()}} details for valid
values).}
}
\value{
A vector containing the format for the object's index.
}
\description{
Generic functions to get or replace the format that determines how an xts
object's index is printed.
}
\details{
Valid values for the \code{value} argument are the same as specified in the
\emph{Details} section of \code{\link[=strptime]{strptime()}}.

An xts object's \code{tformat} is \code{NULL} by default, so the index will be
be formatted according to its \code{\link[=tclass]{tclass()}} (e.g. Date, POSIXct, timeDate,
yearmon, etc.).

The \code{tformat} only changes how the index is \emph{printed} and how the row names
are formatted when xts objects are converted to other classes (e.g. matrix
or data.frame). It does not affect the internal index in any way.
}
\note{
Both \code{indexFormat()} and \verb{indexFormat<-} are deprecated in
favor of \code{tformat()} and \verb{tformat<-}, respectively.
}
\examples{

x <- timeBasedSeq('2010-01-01/2010-01-02 12:00')
x <- xts(seq_along(x), x)

# set a custom index format
head(x)
tformat(x) <- "\%Y-\%b-\%d \%H:\%M:\%OS3"
head(x)

}
\seealso{
\code{\link[=index]{index()}} has more information on the xts index, \code{\link[=tclass]{tclass()}}
details how \pkg{xts} handles the class of the index, \code{\link[=tzone]{tzone()}} has more
information about the index timezone settings.
}
\author{
Jeffrey A. Ryan
}
\keyword{ts}
\keyword{utilities}