{ lib, ... }:
let
  system = builtins.currentSystem or "";
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = lib.hasSuffix "linux" system;
in
{
  imports =
    (lib.optionals isDarwin [ ./darwin.nix ])
    ++ (lib.optionals isLinux [ ./linux.nix ]);
}
