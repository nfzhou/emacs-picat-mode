(eval-when-compile
  (require 'generic)
  (require 'font-lock)
  (require 'regexp-opt))

(defmacro picat-match-symbol (&rest symbols)
  "Convert a word-list into a font-lock regexp."
  (concat "\\_<" (regexp-opt symbols t) "\\_>"))

(setf picat-keywords '("in" "not" "fail" "pass" "true" "false"))

;;;###autoload
(define-generic-mode picat-mode
  '("%" ("/*" . "*/"))     		   ;comments
  picat-keywords
  `(                                       ;font-lock-list
    ;; block delimiters
    ("[.:]" . font-lock-preprocessor-face)
    ;; arrays, structs
    ("[]{}" . font-lock-warning-face)
    (,(concat
       ;; one-char operators
       "[,()|?=+~*%<>=!&^-]"
       ;; multi-char operators
       "\\|\\("
       "\\+\\+\\|--\\|\\*\\*\\|<<\\|>>\\|<=\\|>=\\|==\\|!=\\|=>\\|<=>\\|&&\\|||"
       "\\)")
     . font-lock-builtin-face)
    ;; slash is magical
    ("\\(/\\) " 1 font-lock-builtin-face)
    ;; numeric constants
    ("\\_<[0-9]+\\(\\.[0-9]*\\)?\\([Ee][+-]?[0-9]+\\)?\\_>" . font-lock-constant-face)
    ("0x[a-fA-F0-9]+" . font-lock-constant-face)
    ;; attributes
    ;("/\\(?:\\sw\\|\\s_\\)+\\_>" . font-lock-variable-name-face)
    ;; control constructs
    ;; core functions (XXX some overlap with operators)
    (,(picat-match-symbol 
       "%" "*" "**" "+" "+" "-" "/" "<<" ">>" "abs" "append" "apply" "arity"
       "attr" "call" "chr" "clone" "close" "code" "compile"
       "eval" "exit" "first" "float" "here" "integer"
       "join" "last" "length" "import" "length" "list" "load"
       "name" "new_struct" "new_array" "new_map"
       "number" "ord" "pop" "print" "println" "push" "put" "rand" "read"
       "remove" "reverse" "self" "send" "slice" "sqrt" "srand" "string"
       "text" "to" "tree" "write" "~") . font-lock-builtin-face)
    )
  '("\\.pi$")                           ;file extension
  "Major mode for editing picat-lang."
)

(electric-indent-mode -1)
(global-set-key (kbd "TAB") 'self-insert-command)
(global-set-key (kbd "RET") 'newline)
(setq-default indent-tabs-mode nil)  ; Use spaces instead of tabs
(setq-default tab-width 4)
(global-set-key (kbd "TAB") (lambda () (interactive) (insert "    ")))

;(setq indent-tabs-mode nil) 
;(setq tab-width 4)
;(setq indent-line-function 'insert-tab)

(provide 'picat-mode)
