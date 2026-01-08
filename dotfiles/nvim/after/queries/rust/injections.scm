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

; sqlx::query_scalar! raw string
((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (raw_string_literal (string_content) @injection.content))
 (#eq? @_name "query_scalar")
 (#eq? @_path "sqlx"))
 (#set! injection.language "sql"))

; sqlx::query_scalar! normal string
((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (string_literal (string_content) @injection.content))
 (#eq? @_name "query_scalar")
 (#eq? @_path "sqlx"))
 (#set! injection.language "sql"))

; Statement::from_sql_and_values with raw string (second argument after Postgres/etc)
((call_expression
  function: (scoped_identifier
    path: (identifier) @_struct
    name: (identifier) @_method)
  arguments: (arguments
    (_)
    (raw_string_literal (string_content) @injection.content))
  (#eq? @_struct "Statement")
  (#eq? @_method "from_sql_and_values"))
  (#set! injection.language "sql"))

; Statement::from_sql_and_values with normal string
((call_expression
  function: (scoped_identifier
    path: (identifier) @_struct
    name: (identifier) @_method)
  arguments: (arguments
    (_)
    (string_literal (string_content) @injection.content))
  (#eq? @_struct "Statement")
  (#eq? @_method "from_sql_and_values"))
  (#set! injection.language "sql"))

; Statement::from_string with raw string
((call_expression
  function: (scoped_identifier
    path: (identifier) @_struct
    name: (identifier) @_method)
  arguments: (arguments
    (raw_string_literal (string_content) @injection.content))
  (#eq? @_struct "Statement")
  (#eq? @_method "from_string"))
  (#set! injection.language "sql"))

; Statement::from_string with normal string
((call_expression
  function: (scoped_identifier
    path: (identifier) @_struct
    name: (identifier) @_method)
  arguments: (arguments
    (string_literal (string_content) @injection.content))
  (#eq? @_struct "Statement")
  (#eq? @_method "from_string"))
  (#set! injection.language "sql"))

; insta::assert_yaml_snapshot! with inline raw string snapshot
; Note: This injection is limited by YAML's whitespace sensitivity
; Heavily indented YAML content may only partially highlight due to parser errors
((macro_invocation
  macro: (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    (raw_string_literal
      (string_content) @injection.content)))
  (#eq? @_path "insta")
  (#eq? @_name "assert_yaml_snapshot")
  (#set! injection.language "yaml"))
