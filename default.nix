# This runs with nix-shell just like mkShell, but can also be built to
# create a persistent shell script. To make it almost like the mkShell
# environment, it uses bashInteractive, sets PS1, keeps your PATH, and
# preserves specified environment variables (should be all important
# vars configured by your buildInputs, shellHook, etc.)
#
# See example.nix for usage.

{
  bashInteractive,
  mkShell,
  ...
}:

{
  preservedEnvVars ? [ ],
  ...
}@attrs:
let
  basicShell = mkShell attrs;
in
basicShell.overrideAttrs (originalAttrs: {
  bash = "${bashInteractive}/bin/bash";

  buildPhase = ''
    source $stdenv/setup
    {
      echo "#!$bash"
      declare -p bash ${builtins.concatStringsSep " " (preservedEnvVars ++ (builtins.attrNames originalAttrs))}
      echo "declare -x PATH=''${PATH}:\"\$PATH\""
      echo "declare -x SHELL=$bash"
      echo "declare -x PS1='\n\033[1;32m[nix-shell:\w]\$\033[0m '"
      echo "$shellHook"
      echo "exec \"$bash\" --norc --noprofile \"\$@\""
    } > "$out"
    chmod a+x "$out"
  '';
})
