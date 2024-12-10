; extends

((let_declaration
  pattern: (identifier) @variable.name
  value: (raw_string_literal (string_content) @injection.content))
  (#match? @variable.name ".*js.*")
  (#set! injection.language "javascript")
)
