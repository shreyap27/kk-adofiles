*! ETcalconvert.ado
*! Keith Kranker

* function to convert ethiopian calendar month/year to gregorian calendar month/year
* shift date by 7 years, 8 months.
* This is only an approximation of a more complicated conversion process

program define ETcalconvert
  syntax varlist(min=2 max=2 numeric)                      ///  input:  year_var month_var in ethiopian calendar
      [if] [in] [, Replace GENerate(namelist min=2 max=2)] //  output: replace or provide new variable names
  gettoken year month : varlist
  marksample touse 
  
  if missing("`replace'") + missing("`generate'") != 1 {
    di as error "Specify one of these options: replace or generate(new_year_varname new_month_varname) "
    error 198
  }
  
  tempvar ym
  gen `ym' = ym( `year', `month' ) + 7 * 12 + 8  if `touse'

  if !missing("`replace'") {
    if !missing("`if'`in'") {
		di as txt "(Data has `c(N)' observations. " _
		qui count if `touse'
		di as txt r(N) " observations [if] [in].)"
	}
    replace `year'  = yofd(dofm( `ym' )) if `touse'
    replace `month' = month(dofm( `ym' )) if `touse'
  }
  else {
    gettoken greg_year greg_month : generate
    gen `greg_year'  = yofd(dofm( `ym' )) if `touse'
    gen `greg_month' = month(dofm( `ym' )) if `touse'
  }
end 