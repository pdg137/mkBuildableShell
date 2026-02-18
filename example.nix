# Simple demo to show how to use mkBuildableShell.  You can run
# `nix-build example.nix` to generate a persistent shell script that
# works almost identically to `nix-shell example.nix`.

let
  # Pin nixos-25.11 from 2026-01-08
  nixpkgs-version = "d351d065";
  nixpkgs = fetchTarball {
    name = "nixpkgs-${nixpkgs-version}";
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgs-version}.tar.gz";
    sha256 = "049hhh8vny7nyd26dfv7i962jpg18xb5bg6cv126b8akw5grb0dg";
  };
  pkgs = import nixpkgs {};

  # Load the package (you might want to replace this with a pin)
  mkBuildableShell = import ./. pkgs;

in

mkBuildableShell {
  # Define a few variables
  name = "example-shell";
  someAttr = "test";

  # Set up some inputs
  buildInputs = [ pkgs.hello pkgs.nodejs pkgs.ruby ];

  # Some code to run when entering the shell. If you don't want to
  # leave the prompt open afterward, add `exit` at the end.
  shellHook = ''
    echo "name: $name"
    echo "someAttr: $someAttr"
    ${pkgs.hello}/bin/hello
    echo "Node is installed at $NODE_PATH"
    echo "Rubygems are at $GEM_PATH"
  '';
}
