(import (chezscheme))

(load-shared-object (string-append (getenv "DATASPACE_HOME") "/libneutrino.so"))

(define rust-hello
  (foreign-procedure "hello" () void))

(define rust-invoke-cb
  (foreign-procedure "invoke" (void*) void))

(define scheme-hello
  (lambda ()
    (display "scheme hello\n")))

(define wrap 
  (lambda (p)
    (let ([code (foreign-callable __collect_safe p () void)])
      (lock-object code)
      (foreign-callable-entry-point code))))


(rust-hello)
(rust-invoke-cb (wrap scheme-hello))


(define create-buffer
  (foreign-procedure "create_buffer" (unsigned-32) int))

(define destroy-buffer
  (foreign-procedure "destroy_buffer" (int) boolean))

(define buf-id (create-buffer 1024))
(display (string-append "Buffer created with ID: " (number->string buf-id)))
(newline)

(if (destroy-buffer buf-id)
    (display "Buffer destroyed successfully")
    (display "Failed to destroy buffer"))
(newline)

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


(define (find-file path)
  (display "hello"))

    
