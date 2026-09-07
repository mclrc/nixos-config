---
name: nixos-change
description: Procedures for changing this NixOS/home-manager flake — adding packages, services, dotfiles, fish aliases, new modules or new hosts, plus how to verify a change and read Nix eval errors. Use whenever a request means editing a .nix file in this repo or asks to install/remove/configure something on this machine.
---

# Changing this NixOS config

Read `CLAUDE.md` first for the repo layout and the hard rules. This skill is the
step-by-step detail.

This file and `CLAUDE.md` are the user's instructions to you, not scratch space:
never edit them on your own initiative. If something in them is out of date or a
new rule clearly needs adding, raise it with the user and let them decide.

## The loop

1. Work out whether the change is **system** (`configuration.nix`, system
   modules) or **home** (`home.nix`, home modules). Getting this wrong is the
   usual cause of "option does not exist".
2. Verify names before you write them (`just has`, `just search`, `just opt`).
3. Edit.
4. `git add` any new file.
5. `just check` — or `just check-all` if you touched `configuration.nix`,
   `home.nix`, or anything under `modules/` that all hosts import.
6. `just diff` to show the user what the switch would actually change. If the
   edit alters a *generated config file* rather than just a package list, also
   read the generated file — see "Checking what a change actually generates".
7. **Stop.** Report what you changed and what `check`/`diff` said. The user runs
   `just switch` themselves.

## Adding a package

Confirm the attribute exists in the *pinned* nixpkgs — search.nixos.org can be
ahead of or behind `flake.lock`:

```
just has ripgrep-all        # exact attribute -> prints "ripgrep-all-0.10.10"
just search pdf viewer      # fuzzy, by name/description/binary
```

Then append it to the right list, keeping the file's existing grouping:

- user-facing CLI/GUI → `home.packages` in `home.nix`
- needed by root, a service, or at boot → `environment.systemPackages` in `configuration.nix`
- embedded/work toolchain → `modules/yacoub.nix`

Attribute paths with a dot (`nerd-fonts.hack`, `fishPlugins.done`) go in as-is
inside the `with pkgs;` block. Unfree packages already work — `allowUnfree` is
set in `flake.nix`. An *insecure* package additionally needs its name added to
`config.permittedInsecurePackages` in `flake.nix`.

## Enabling a service or program

Prefer the dedicated module over a raw package — `programs.foo.enable = true`
usually wires up config, PATH and systemd units.

To find the right option name and its current value:

```
just opt services.blueman.enable
just opt programs.fish.shellAliases
```

An option that doesn't exist errors immediately, which is itself the answer.
System options (`services.*`, `boot.*`, `users.*`, `environment.*`,
`virtualisation.*`, `hardware.*`, `fonts.*`, `security.*`) belong in
`configuration.nix`. Home-manager options (`programs.*`, `home.*`, `gtk.*`,
`xdg.*`, `services.*` for *user* units like dunst/ssh-agent) belong in
`home.nix`. Note `services.*` exists in both namespaces with different options.

## Shell aliases and functions

`programs.fish.shellAliases` and `programs.fish.functions` in `home.nix`. Function
bodies are fish, written inside a Nix `''…''` string — so `${` must be escaped as
`''${`, and `''` as `'''`. Existing functions there (`ide`, `nixai`) are the
pattern to copy.

## Dotfile-style config

`modules/waybar/waybar-config/`, `modules/rofi/theme.rasi`,
`modules/neovim/neovim-config/`, `modules/udev/udev-rules/` are plain config
files copied into place by their sibling `.nix`. Edit them directly as CSS /
JSONC / Lua / rules files — no Nix syntax involved. A new file in one of these
trees still needs `git add` to be visible to the build.

## Adding a module

1. Create `modules/<name>.nix` as `{ config, pkgs, ... }: { … }`.
2. Add `./modules/<name>.nix` to the `imports` list in `configuration.nix` (system)
   or `home.nix` (home).
3. `git add modules/<name>.nix` — **required**, or Nix will report the import as
   a missing file.
4. `just check-all`.

## Adding a host

1. Put the `nixos-generate-config` hardware output at `hardware/<name>.nix`.
   Anything genuinely per-machine — CPU/KVM module, graphics, audio — belongs
   in that file, even where it repeats the other hosts.
2. Add one line to `nixosConfigurations` in `flake.nix`:
   `<name> = mkHost { name = "<name>"; };`. `mkHost` picks up
   `hardware/<name>.nix` and sets `networking.hostName` for you. Pass
   `hardware = "<file>"` only if the hardware file is named differently, as
   `nixusb` does.
3. `git add`, then `PROFILE=<name> just check`.

Profile auto-detection uses `$hostname` when it names a real config, and
otherwise matches the root filesystem UUID against each host's evaluated
`fileSystems."/"` device — so a new host works both before and after its first
switch.

## Updating inputs

`just update` bumps everything; `just update-input nixpkgs` bumps one. Both
rewrite `flake.lock`. Always follow with `just check-all` and then `just diff` —
an unstable bump can pull in a lot, and the user wants to see it before switching.

## Checking what a change actually generates

`just check` only proves the config *evaluates*. It says nothing about whether
the files that come out are correct, so it cannot catch a change that produces
valid Nix and a broken config file. Never call a change done on a clean eval
alone when it alters generated output.

Build the generation and read the files directly:

```
nix build --no-link --print-out-paths \
  .#nixosConfigurations.$(just which).config.home-manager.users.mclrc.home.activationPackage
```

The result holds the whole managed home under `home-files/` — `.ssh/config`,
`.config/hypr/hyprland.conf`, `.config/gtk-*/settings.ini` and so on. Build it
once before your edit and once after, then `diff -r` the two `home-files`
directories: that shows exactly what the change adds, removes and rewrites, and
an identical store path proves a refactor was purely cosmetic.

Where the target program ships a config checker, run it against the generated
file before handing the change back — for example `Hyprland --verify-config`,
which prints the config path it actually loaded and any parse errors.

## Reading eval errors and warnings

Eval is currently warning-free on all three hosts, so any `evaluation warning:`
line is something your change introduced — treat it as a defect, not noise. The
two usual kinds:

- `The option 'a.b' has been renamed to 'c.d'` — just use the new name.
- `The default value of 'x' has changed … because home.stateVersion is less
  than "N"` — set `x` explicitly rather than leaving it on the legacy default.
  Prefer the new value, with two exceptions that are the user's call:

  1. adopting it needs a **manual migration** (moving a state directory, say);
  2. it changes the **format or API** of a config this repo generates.

  The second is the trap, because eval stays clean either way. Flipping
  `wayland.windowManager.hyprland.configType` to `"lua"` looks like a one-line
  modernisation, but home-manager translates the hyprlang-shaped `settings`
  attrset naively: `exec-once` becomes `hl.exec-once(...)`, which is not valid
  Lua, so Hyprland rejects the file and silently boots an autogenerated stub —
  a broken desktop that `just check` cannot see. Hyprland's lua API also wants
  `hl.bind("SUPER + Q", hl.dsp.exec_cmd("alacritty"))`, not a hyprlang bind
  string, so every bind would need rewriting too.

  A default change of this kind is a scoped migration to propose, not a flip.

`warning: Git tree is dirty` is expected and harmless.

Errors are at the very end of the output. Common shapes:

- `error: The option 'X' does not exist` — wrong namespace (system vs home), or a
  renamed option. `just opt <parent>` to see what does exist there.
- `error: getting status of '/nix/store/…-source/modules/foo.nix': No such file` —
  the file is untracked. `git add` it.
- `error: undefined variable 'foo'` — a package name outside a `with pkgs;` block,
  or a typo. Check with `just has foo`.
- `error: attribute 'foo' missing` — package doesn't exist under that path in the
  pinned nixpkgs.

Add `--show-trace` by running the underlying command directly if the location is
unclear: `nixos-rebuild dry-build --flake .#$(just which) --show-trace`.

## If a switch goes wrong

The user can recover with `just rollback`, or by picking the previous generation
in the systemd-boot menu. For a change you think is risky, suggest `just try`
(activates without making it the boot default, so a reboot undoes it) instead of
`just switch`.
