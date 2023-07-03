{ config, ... }:
{
  config.programs.brave = {
    enable = true;
    extensions = [
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
    ];
  };
}
