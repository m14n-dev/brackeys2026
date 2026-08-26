{
  pkgs,
  lib,
  ...
}:
{
  packages = [
    pkgs.git
    pkgs.jujutsu
    pkgs.nixfmt
    pkgs.nixfmt-tree
    pkgs.treefmt
    pkgs.godot
    pkgs.inkscape
  ];

  env = {
    GODOT4_BIN = lib.getExe pkgs.godot;
  };

  languages.nix = {
    enable = true;
    lsp.enable = true;
  };

  tasks = {
  };

  processes = {
  };
}
