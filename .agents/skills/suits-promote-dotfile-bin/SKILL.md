---
name: suits-promote-dotfile-bin
description: Use when the user says "Promote dotfiles/bin/<script>" or asks to move/promote a script from dotfiles/bin into a first-class Nix package in the suits repo. Creates packages/<script>/package.nix, wires it into packages/my-nix/package.nix, removes the old dotfiles/bin script, and build-checks the package.
---

# Promote Dotfiles Bin Script

Convert a `dotfiles/bin/<script>` file into a first-class package under `packages/<script>/package.nix` in the suits repo.

## Workflow

1. Inspect the source script and references:

   ```sh
   sed -n '1,200p' dotfiles/bin/<script>
   rg "\\b<script>\\b|dotfiles/bin/<script>" -n .
   ```

2. Create `packages/<script>/package.nix`.

3. Use idiomatic `callPackage`-style inputs:

   ```nix
   {
     writeShellApplication,
     dependency,
   }:

   writeShellApplication {
     name = "<script>";

     runtimeInputs = [
       dependency
     ];

     text = ''
       ...
     '';
   }
   ```

4. Use repo-local packages through `self'.packages.*`:

   ```nix
   {
     self',
     writeShellApplication,
   }:

   writeShellApplication {
     name = "<script>";

     runtimeInputs = [
       self'.packages.neovim
     ];

     text = ''
       ...
     '';
   }
   ```

5. Add the new package to the `with self'.packages; [...]` group in `packages/my-nix/package.nix`.

6. Delete the old `dotfiles/bin/<script>` file.

7. Build-check:

   ```sh
   nix build .#<script> .#my-nix
   ```

   If the new package is untracked and normal flake evaluation cannot see it, ask the user to stage it or use a `path:` flake reference only for validation.

## Repo Conventions

- Prefer explicit package inputs over `{ pkgs }` and `with pkgs`.
- Keep local repo dependencies as `self'.packages.<name>`.
- Preserve script behavior exactly unless the user asks for cleanup.
- Keep `packages/my-nix/package.nix` grouped: nixpkgs packages, `self'.packages`, then local overrides/special bindings.
