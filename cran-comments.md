## Test environments
* ubuntu 14.04, R 3.2.2
* Windows 10
* win-builder (devel and release)

## R CMD check results

1 NOTE: 

installed size is 11.0Mb
sub-directories of 1Mb or more:
  data  10.9Mb
  
* The package is a pure data package, and the data has been maximally compressed.

## Changes in version 0.2 following comments from Profs Hornik and Ripley

* Wrapped example that was running slowly on CRAN in \dontrun{} 
(the package includes a comprehensive vignette explaining usage)

* Expanded description of what the package does

* Removed LazyData = TRUE

* Tested using both 32- and 64-bit R