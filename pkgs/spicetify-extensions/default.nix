{
  lib,
  callPackage,
}: let
  inherit
    (builtins)
    readDir
    mapAttrs
    ;
  inherit
    (lib)
    filterAttrs
    pipe
    ;

  root = ./.;

  mkSpicetifyExtension = args: args;

  call = name: callPackage (root + "/${name}") {inherit mkSpicetifyExtension;};
in
  pipe root [
    readDir
    (filterAttrs (_: type: type == "directory"))
    (mapAttrs (name: _: call name))
  ]
  // {
    inherit mkSpicetifyExtension;
  }
