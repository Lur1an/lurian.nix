; extends

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "patch")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "yaml")
    (#offset! @injection.content 0 1 0 0)
  ))

(block_mapping_pair
  key: (flow_node) @_expr
  (#match? @_expr ".*yaml")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "yaml")
    (#offset! @injection.content 0 1 0 0)
  ))

(block_mapping_pair
  key: (flow_node) @_expr
  (#match? @_expr ".*json")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "json")
    (#offset! @injection.content 0 1 0 0)
  ))

