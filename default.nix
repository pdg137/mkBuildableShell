{
  bashInteractive,
  mkShell,
  ...
}:

{
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
      echo "declare -x _NEW_PATH=''${PATH}:\"\$PATH\""
      export # messes up PATH
      echo "declare -x PATH=\"\$_NEW_PATH\""
      echo "declare -x SHELL=$bash"
      echo "declare -x PS1='\n\033[1;32m[nix-shell:\w]\$\033[0m '"
      echo "$shellHook"
      echo "exec \"$bash\" --norc --noprofile \"\$@\""
    } > "$out"
    chmod a+x "$out"
  '';
})
