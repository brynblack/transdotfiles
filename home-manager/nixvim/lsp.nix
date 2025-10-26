{
  lsp = {
    servers = {
      qmlls.enable = true;
      nil_ls.enable = true;
      cssls.enable = true;
      bashls.enable = true;
    };
    inlayHints.enable = true;
  };
  diagnostic.settings = {
    virtual_lines.current_line = true;
    virtual_text = false;
  };
}
