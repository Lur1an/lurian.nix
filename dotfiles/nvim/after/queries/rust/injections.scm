; extends

((let_declaration
  pattern: (identifier) @variable.name
  value: (raw_string_literal (string_content) @injection.content))
  (#match? @variable.name ".*js.*")
  (#set! injection.language "javascript")
)

; sqlx::query! raw string
((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (raw_string_literal (string_content) @injection.content))
 (#eq? @_name "query")
 (#eq? @_path "sqlx"))
 (#set! injection.language "sql"))

; sqlx::query! normal string
((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (string_literal (string_content) @injection.content))
 (#eq? @_name "query")
 (#eq? @_path "sqlx"))
 (#set! injection.language "sql"))

; sqlx::query_as! raw string
((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (identifier) (string_literal (string_content) @injection.content))
 (#eq? @_name "query_as")
 (#eq? @_path "sqlx"))
 (#set! injection.language "sql"))

; sqlx::query_as! normal string
((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (identifier) (raw_string_literal (string_content) @injection.content))
 (#eq? @_name "query_as")
 (#eq? @_path "sqlx"))
 (#set! injection.language "sql"))
