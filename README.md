A simple nix derivation generator that extends mkShell to allow
building a persistent shell script with `nix-build`.

## Usage

See `example.nix`.  You can run

```
nix-shell example.nix
```

for a normal mkShell-type shell that is built dynamically by the nix
system. To save this shell in a persistent shell script that can run
without nix evaluations, run

```
nix-build example.nix
```

The `result` script drops you instantly into an environment that is
*almost* exactly the same as the `nix-shell` one.

## Features

To make it almost like the mkShell environment, it:

* uses bashInteractive (for tab completion, etc.),
* sets PS1,
* appends your PATH to the one configured by buildInputs,
* provides all variables passed to mkBuildableShell, and
* provides additional environment variables
  configured by your buildInputs.
