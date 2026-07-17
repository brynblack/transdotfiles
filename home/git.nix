{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Brynley Llewellyn-Roux";
        email = "git.escalator677@passmail.com";
        signingKey = "30500C5C14FBCEF6F369594303A659346E0D9031";
      };
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
  };
}
