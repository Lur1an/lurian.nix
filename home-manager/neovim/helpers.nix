let
  luaExpr = {
    module,
    function,
    namespace ? "nixvim",
    call ? false,
  }: let
    moduleName =
      if namespace == null
      then module
      else "${namespace}.${module}";
  in ''require("${moduleName}").${function}${
      if call
      then "()"
      else ""
    }'';
in {
  inherit luaExpr;

  luaFn = args: {
    __raw = luaExpr args;
  };
}
