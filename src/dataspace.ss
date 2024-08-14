(import (chezscheme))

(load-shared-object (string-append (getenv "DATASPACE_HOME") "/libneutrino.so"))

(define show-main
  (foreign-procedure "show_main" () void))

(show-main)
