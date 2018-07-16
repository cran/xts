/*
 * Helper function to move index attributes from the xts object to the
 * index attached to it.
 */
#include "xts.h"

// Attribute names
SEXP _str_ixClass = NULL;
SEXP _str_ixFormat = NULL;
SEXP _str_ixZone = NULL;
SEXP _str_tclass = NULL;
SEXP _str_tformat = NULL;
SEXP _str_tzone = NULL;

void make_names() {
  _str_ixClass = mkString(".indexCLASS");
  _str_ixFormat = mkString(".indexFORMAT");
  _str_ixZone = mkString(".indexTZ");
  _str_tclass = mkString("tclass");
  _str_tformat = mkString("tformat");
  _str_tzone = mkString("tzone");
}

SEXP xts_remove_index_attrib(SEXP _x)
{
  make_names();
  // Remove potential index attributes on xts object
  setAttrib(_x, _str_ixClass, R_NilValue);
  setAttrib(_x, _str_ixFormat, R_NilValue);
  setAttrib(_x, _str_ixZone, R_NilValue);
  setAttrib(_x, _str_tclass, R_NilValue);
  setAttrib(_x, _str_tformat, R_NilValue);
  setAttrib(_x, _str_tzone, R_NilValue);
  // 'x' has been modified in-place, but we can't call from R if
  // we return void, so return NULL instead.
  return R_NilValue;
}

SEXP xts_migrate_index_attrib(SEXP _x)
{
  if (!isXts(_x)) {
    error("not an xts object");
  }
  make_names();
  // Attribute values
  SEXP _index = getAttrib(_x, mkString("index"));
  SEXP _tclass = getAttrib(_index, _str_tclass);
  SEXP _tformat = getAttrib(_index, _str_tformat);
  SEXP _tzone = getAttrib(_index, _str_tzone);
  // Ensure index has attributes set
  if (R_NilValue == _tclass) {
    SEXP xiclass = getAttrib(_x, _str_ixClass);
    setAttrib(_index, _str_tclass, xiclass);
  }
  if (R_NilValue == _tformat) {
    SEXP xiformat = getAttrib(_x, _str_ixFormat);
    setAttrib(_index, _str_tformat, xiformat);
  }
  if (R_NilValue == _tzone) {
    SEXP xizone = getAttrib(_x, _str_ixZone);
    setAttrib(_index, _str_tzone, xizone);
  }
  // Remove attributes on xts object
  xts_remove_index_attrib(_x);
  // 'x' has been modified in-place, but we can't call from R if
  // we return void, so return NULL instead.
  return R_NilValue;
}
