{
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1e1e2e2e";
      text-color = "#cdd6f4";
      border-color = "#35363e";
      progress-color = "over #313244";
      border-radius = 12;
      border-size = 1;
      outer-margin = 12;
      max-icon-size = 48;
      output = "DP-3";
      layer = "overlay";
      default-timeout = "10000";

      "urgency=high" = { border-color = "#fab387"; };
    };
  };
}
