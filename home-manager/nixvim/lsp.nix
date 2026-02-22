{
  lsp = {
    servers = {
      bashls.enable = true;
      cssls.enable = true;
      lua_ls.enable = true;
      nil_ls.enable = true;
      qmlls.enable = true;
      rust_analyzer.enable = true;
    };
    inlayHints.enable = true;
  };
  diagnostic.settings = {
    virtual_lines.current_line = true;
    virtual_text = false;
  };
}
