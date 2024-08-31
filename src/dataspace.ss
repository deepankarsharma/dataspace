(import (chezscheme))


;; ************** Guardians *******************

(define *guardian* (make-guardian))

(define (register-object obj proc)
  (let [(x (cons obj proc))]
       (*guardian* x)
       x))

(define run-finalizers
  (lambda ()
    (let run ()
      (let ([x (*guardian*)])
        (when x
          (((cdr x) (car x)) 'erased)
          (run))))))







;; ************ Load rust lib *******************
(load-shared-object (string-append (getenv "DATASPACE_HOME") "/libneutrino.so"))



(define scheme-hello
  (lambda ()
    (display "scheme hello\n")))






;; **************************************
;; Example of calling a rust function
(define rust-hello
  (foreign-procedure "hello" () void))

;; (rust-hello)







;; **************************************
;; Example of calling a Rust function that calls back into scheme

;; Make scheme procedure callable from Rust
(define wrap
  (lambda (p)
    (let ([code (foreign-callable __collect_safe p () void)])
      (lock-object code)
      (foreign-callable-entry-point code))))

(define rust-invoke-cb
  (foreign-procedure "invoke" (void*) void))

;; (rust-invoke-cb (wrap scheme-hello))





;; **************************************
;; ***** DATASPACE BEGINS ***************
;; **************************************


;; FFI functions 


;; Corrected macro to generate FFI definitions with proper type handling
(define-syntax define-ffi-procedures
  (lambda (x)
    (define (canonicalize-name name)
      (string->symbol
       (list->string
        (map (lambda (char)
               (if (char=? char #\_) #\- char))
             (string->list (symbol->string name))))))
    (syntax-case x ()
      ((_ (name args return-type) ...)
       #'(begin
           (define name
             (foreign-procedure
              (symbol->string 'name)
              args
              return-type)) ...)))))

(define (canonicalize-name input-string)
  (display input-string)
  (list->string
   (map (lambda (char)
          (if (char=? char #\_)
              #\-
              char))
        (string->list input-string))))

(define-ffi-procedures
  (create_buffer () iptr)
  (destroy_buffer (iptr) void))


(define-syntax t1
  (lambda (x)
    (syntax-case x ()
      [(_ e1 e2) #'(define #,(datum->syntax #'e1 (string->symbol (string-upcase (symbol->string (syntax->datum #'e))))) val)])))

;; Function to perform macroexpansion
(define (expand-macro expr)
  (syntax->datum
   (expand expr (environment '(rnrs)))))

;; Example usage of the macro
(define example-usage
  '(define-ffi-procedures
     (create_buffer () iptr)
     (destroy_buffer (iptr) void)
     (foo_bar (int string) bool)))

;; Expand and display the macro
(display "Expanded macro:\n")
(pretty-print (expand-macro example-usage))


(define-syntax display-compile-timestamp
  (lambda (x)
    (syntax-case x ()
      [(_) #'(begin
               (display "Compile timestamp: ")
               (display #,(current-time))
               (newline))])))

;; Test the generated definitions
(display create-buffer)              ")
(newline)

;;(display "Testing ffi-destroy-buffer: ")
;;(write (procedure? destroy-buffer))
;;(newline)

   
;; (define ffi-create-buffer
;;   (foreign-procedure "create_buffer" () iptr))

;; (define ffi-destroy-buffer
;;   (foreign-procedure "destroy_buffer" (iptr) void))




(define (finalizer x)
  (destroy-buffer x)
  (lambda (x) 1))




(define (create-buffer)
  (let*
      ([%buf (ffi-create-buffer)]
       [%g (register-object %buf finalizer)])
    %buf))




(define (test-buffer-lifetimes)
  (display "test-buffer-lifetimes\n")
  (create-buffer))

(test-buffer-lifetimes)
(collect)
(run-finalizers)

(newline)
(newline)



;; Order
;; 1. find-file

;;(display "exiting")

;; Functions that we will be implementing
;; add-mode-global
;; message
;; log-message
;; log-debug
;; insert-string
;; set-point
;; get-mark
;; get-point
;; get-point-max
;; set-key
;; prompt
;; show-prompt
;; eval-block
;; get-buffer-name
;; get-char
;; get-key
;; get-key-name
;; get-key-funcname
;; goto-line
;; getch
;; get-version-string
;; save-buffer
;; search-forward
;; search-backward
;; insert-file-contents-literally
;; select-buffer
;; rename-buffer
;; kill-buffer
;; erase-buffer
;; find-file
;; update-display
;; prompt-filename
;; clear-message-line
;; refresh
;; beginning-of-buffer
;; end-of-buffer
;; beginning-of-line
;; end-of-line
;; forward-char
;; forward-page
;; forward-word
;; backward-char
;; backward-page
;; backward-word
;; next-line
;; previous-line
;; set-mark
;; set-clipboard
;; system
;; delete
;; copy-region
;; kill-region
;; yank
;; backspace
;; delete-other-windows
;; execute-key
;; list-buffers
;; describe-bindings
;; describe-functions
;; split-window
;; other-window
;; get-clipboard
;; get-buffer-count
;; exit


;; Order of implementation
;; find-file



