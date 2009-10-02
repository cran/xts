\name{.parseISO8601}
\alias{ISO8601}
\Rdversion{1.1}
\alias{parseISO8601}
\alias{.parseISO8601}
\title{
Internal ISO 8601:2004(e) Time Parser
}
\description{
This function is used internally in the subsetting
mechanism of xts.  The function is unexported, though
documented for use with xts subsetting.
}
\usage{
.parseISO8601(x, start, end)
}
\arguments{
  \item{x}{
a character string conforming to ISO 8601:2004(e) rules
}
  \item{start}{
lower constraint on range
}
  \item{end}{
upper constraint of range
}
}
\details{
This function replicates most of the ISO 
standard for expressing time and time-based
ranges in a universally accepted way.

The best documentation is now the official
ISO page as well as the Wikipedia entry for
ISO 8601:2004.

The basic idea is to create
the endpoints of a range, given a string
representation. These endpoints are aligned
in POSIXct time to the zero second of the day
at the beginning, and the 59th second of the 59th
minute of the 23rd hour of the final day.
}
\value{
A list of length two, with an entry
named \sQuote{first.time} and one
names \sQuote{last.time}.
}
\references{
\url{http://en.wikipedia.org/wiki/ISO_8601}\cr
\url{http://www.iso.org/iso/support/faqs/faqs_widely_used_standards/widely_used_standards_other/date_and_time_format.htm}
}
\author{
Jeffrey A. Ryan
}
\note{
There is no checking done to test for a properly constructed
ISO format string.  This must be correctly entered by the user, lest
bad things may happen.

When using durations, it is important to note that the
time of the duration specified is not necessarily the
same as the realized periods that may be returned when
applied to an irregular time series.  This is not a bug,
rather it is a standards and implementation gotcha.
}
\examples{
# the start and end of 2000
.parseISO8601('2000')

# the start of 2000 and end of 2001
.parseISO8601('2000/2001')

# May 5, 200 to Dec 31, 2001
.parseISO8601('2000-05/2001')

# May 5, 2000 to end of Feb 2001
.parseISO8601('2000-05/2001-02')

# Jan 1, 2000 to Feb 29, 2000; note the truncated time on the LHS
.parseISO8601('2000-01/02')
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }