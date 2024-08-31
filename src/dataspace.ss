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


;; # Minimal Emacs Implementation - Function Documentation

;; ## Buffer and File Operations

;; ### `select-buffer`
;; Switches to the specified buffer.

;; ### `rename-buffer`
;; Renames the current buffer.

;; ### `kill-buffer`
;; Closes the current buffer.

;; ### `erase-buffer`
;; Clears all content from the current buffer.

;; ### `find-file`
;; Opens a file in a new buffer.

;; ### `save-buffer`
;; Saves the current buffer to its associated file.

;; ### `insert-file-contents-literally`
;; Inserts the contents of a file into the current buffer without any conversion.

;; ### `get-buffer-name`
;; Returns the name of the current buffer.

;; ### `get-buffer-count`
;; Returns the number of open buffers.

;; ### `list-buffers`
;; Displays a list of all open buffers.

;; ## Cursor and Point Operations

;; ### `set-point`
;; Moves the cursor to a specified position in the buffer.

;; ### `get-point`
;; Returns the current cursor position.

;; ### `get-point-max`
;; Returns the maximum position in the current buffer.

;; ### `get-mark`
;; Returns the current mark position.

;; ### `set-mark`
;; Sets the mark at the current cursor position.

;; ### `goto-line`
;; Moves the cursor to the specified line number.

;; ## Text Insertion and Deletion

;; ### `insert-string`
;; Inserts a string at the current cursor position.

;; ### `delete`
;; Deletes the character at the cursor position.

;; ### `backspace`
;; Deletes the character before the cursor position.

;; ### `copy-region`
;; Copies the text between the mark and the point to the clipboard.

;; ### `kill-region`
;; Cuts the text between the mark and the point to the clipboard.

;; ### `yank`
;; Inserts the text from the clipboard at the cursor position.

;; ## Navigation

;; ### `beginning-of-buffer`
;; Moves the cursor to the beginning of the buffer.

;; ### `end-of-buffer`
;; Moves the cursor to the end of the buffer.

;; ### `beginning-of-line`
;; Moves the cursor to the beginning of the current line.

;; ### `end-of-line`
;; Moves the cursor to the end of the current line.

;; ### `forward-char`
;; Moves the cursor forward by one character.

;; ### `backward-char`
;; Moves the cursor backward by one character.

;; ### `forward-word`
;; Moves the cursor forward by one word.

;; ### `backward-word`
;; Moves the cursor backward by one word.

;; ### `forward-page`
;; Moves the cursor forward by one page.

;; ### `backward-page`
;; Moves the cursor backward by one page.

;; ### `next-line`
;; Moves the cursor to the next line.

;; ### `previous-line`
;; Moves the cursor to the previous line.

;; ## Search

;; ### `search-forward`
;; Searches forward from the cursor position for a specified string.

;; ### `search-backward`
;; Searches backward from the cursor position for a specified string.

;; ## Window Management

;; ### `delete-other-windows`
;; Closes all windows except the current one.

;; ### `split-window`
;; Splits the current window into two.

;; ### `other-window`
;; Switches focus to the next window.

;; ## Mode and Key Binding

;; ### `add-mode-global`
;; Adds a global mode to the editor.

;; ### `set-key`
;; Binds a function to a key combination.

;; ### `execute-key`
;; Executes the function bound to a key combination.

;; ### `get-key`
;; Waits for and returns the next key press.

;; ### `get-key-name`
;; Returns the name of a key.

;; ### `get-key-funcname`
;; Returns the name of the function bound to a key.

;; ## User Interface

;; ### `message`
;; Displays a message in the echo area.

;; ### `log-message`
;; Logs a message for debugging purposes.

;; ### `log-debug`
;; Logs a debug message.

;; ### `prompt`
;; Prompts the user for input.

;; ### `show-prompt`
;; Displays a prompt in the echo area.

;; ### `prompt-filename`
;; Prompts the user for a filename.

;; ### `clear-message-line`
;; Clears the message line in the echo area.

;; ### `update-display`
;; Updates the display

(define (find-file path)
  (display "hello"))


