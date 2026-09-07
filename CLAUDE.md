# nixos-config

Flake-based NixOS + home-manager config for three machines. Everything about this
system — packages, services, dotfiles, keybinds — is declared here; nothing is
installed imperatively.

## Layout

| Path | Scope | What lives here |
| --- | --- | --- |
| `flake.nix` | — | Inputs (nixpkgs unstable + home-manager, nothing else) and the `mkHost` helper that builds one `nixosConfigurations.<host>` per machine. Also the global `pkgs` (unfree allowed, insecure-package allowlist). |
| `flake.lock` | — | Pinned input revisions. Only `just update` / `just update-input` touch it. |
| `configuration.nix` | **system** | Shared by all three hosts: system packages, bootloader, networking, locale, users, fonts, docker, fish, portals. |
| `home.nix` | **home** | Shared home-manager config for user `mclrc`: user packages, git/gh/ssh/fish/zoxide/atuin, gtk theme, dunst, mime defaults. |
| `hardware/{thinkpad,desktop,usb}.nix` | **system** | Per-machine only: disk UUIDs, LUKS devices, CPU/KVM and other kernel modules, graphics, audio. Mostly generated — do not hand-edit unless hardware actually changed. |
| `modules/*.nix` | mixed | Feature modules. See below — some are system, some are home. |
| `modules/<x>/<x>-{config,rules}/` | — | Verbatim config trees — `waybar/waybar-config/`, `neovim/neovim-config/`, `udev/udev-rules/` — copied into place by the sibling `.nix`. Edit these as normal config files, not as Nix. |
| `modules/rofi/theme.rasi` | — | The rofi theme, referenced as `theme = ./theme.rasi;`. Same deal: edit it as rasi, not as Nix. |
| `modules/hyprland/hyprland.lua` | **home** | The whole Hyprland config, in Hyprland's Lua config format. Same deal: edit it as Lua, not as Nix. `hyprland.nix` only installs it. |

**System modules** (imported by `configuration.nix`): `keyd.nix`, `udev/udev.nix`,
`virtualisation.nix`, `bsprak.nix`.

**Home modules** (imported by `home.nix`): `hyprland/hyprland.nix`, `alacritty.nix`,
`waybar/waybar.nix`, `neovim/neovim.nix`, `yacoub.nix`, `rofi/rofi.nix`.

## Where does a change go?

- **A CLI tool or GUI app for the user** → `home.packages` in `home.nix`.
- **Something needed at boot, by root, or by a system service** → `environment.systemPackages` in `configuration.nix`.
- **Work-specific / embedded toolchain** → `modules/yacoub.nix`.
- **A shell alias or fish function** → `programs.fish` in `home.nix`.
- **Desktop/WM behaviour, keybinds, autostart** → `modules/hyprland/hyprland.lua`
  (real Lua, not Nix — see below).
- **A new feature area** → new file in `modules/`, then add it to the `imports`
  list of `configuration.nix` (system) or `home.nix` (home). Remember `git add`.
- **Anything under `hardware/`** → almost never. Ask first.

Nothing above `hardware/` may assume the machines share hardware. CPU/KVM
modules, graphics and audio are declared per-host inside `hardware/*.nix`, and
the repetition between those three files is deliberate — do not "deduplicate" it
into `configuration.nix`. (`modules/virtualisation.nix` used to hardcode
`kvm-intel` for every host, which was wrong for the AMD desktop.)

System-level options (`services.*`, `environment.*`, `boot.*`, `users.*`) only
work in `configuration.nix` / system modules. Home-manager options
(`programs.*`, `home.*`, `gtk.*`, `xdg.*`) only work in `home.nix` / home
modules. Putting one in the other is the most common error here and shows up as
"option does not exist" at eval time.

## Rebuilding

Run everything through `just` (`just --list` for the full set).

```
just check       # SAFE: evaluate + report what would be built. No sudo. Run after every edit.
just check-all   # SAFE: same for all three hosts. Use after editing shared files.
just diff        # SAFE: build the closure and list every package add/remove/version bump.
just switch      # NEEDS SUDO — activates. The human runs this, not an agent.
```

`just` auto-detects which host profile this machine is: it uses `$hostname`
when that names a real config, else it matches the root filesystem UUID against
each host's evaluated `fileSystems."/"` device. `just which` shows the result,
`just hosts` lists them all. Override with `PROFILE=desktop just check`.

### Rules for agents

1. **Never run `just switch`, `just try`, `just boot`, `just rollback`, `just gc`,
   or any `sudo nixos-rebuild`.** Those are the human's. Stop after `just check`
   (or `just diff`) and report the result so they can review and switch.
2. **Always `just check` after editing any `.nix` file.** A config that does not
   evaluate is worse than no change.
3. **`git add` every new file before running `just check`.** Nix builds this
   flake from the *git tree*: uncommitted edits to tracked files are picked up,
   but **untracked files are silently ignored**, so a new module will appear not
   to exist. `just check` warns when untracked files are present.
4. **Verify package names before adding them**: `just has <attr>` checks the
   pinned nixpkgs, `just search <terms>` does a fuzzy lookup. Don't guess.
5. **After editing `modules/hyprland/hyprland.lua`, verify it.** `just check`
   only evaluates Nix, so a Lua error sails straight past it and lands you in
   Hyprland's emergency mode — no binds except `SUPER + Q`. Hyprland ships a
   checker that actually executes the config and catches unknown config keys,
   bad dispatcher arguments and unknown keysyms, not just syntax:

   ```
   just check   # first, so the file is in the store
   Hyprland --verify-config -c "$(nix eval --raw \
     '.#nixosConfigurations.thinkpad.config.home-manager.users.mclrc.xdg.configFile."hypr/hyprland.lua".source')"
   ```

   It prints `config ok`, or the offending line. The `hl` API is documented by
   the stubs at `$(nix eval --raw ...pkgs.hyprland)/share/hypr/stubs/hl.meta.lua`
   and the annotated example at `share/hypr/hyprland.lua` — read those rather
   than guessing at dispatcher signatures.
6. **Never edit the agent instructions yourself** — this file,
   `.claude/skills/**`, and `.claude/settings.json`. If something here is
   outdated, contradicts the code, or a new rule genuinely needs adding, say so
   and ask whether to change it. Only edit them when the user says to.
7. `warning: Git tree is dirty` is expected and harmless.

## Notes

- Hosts are built by `mkHost { name, hardware ? name }` in `flake.nix`, so
  adding one is a single line there. `name` is both the `nixosConfigurations`
  attribute and `networking.hostName` — never set the hostname in the shared
  `configuration.nix`, and keep the two matching, because `just` relies on it to
  detect the profile. `hardware` names the file in `hardware/` and defaults to
  `name`; they differ for exactly one host, `nixusb`, which uses
  `hardware/usb.nix`.
- `configuration.nix` and `home.nix` are shared by all three hosts — a change
  there affects every machine. Use `just check-all` for those.
- Don't change `system.stateVersion` / `home.stateVersion`.
- **Eval is warning-free on all three hosts.** Keep it that way: if `just check`
  prints an `evaluation warning`, your change introduced it — fix it rather than
  ignoring it. `warning: Git tree is dirty` is the one expected exception.
- `home.stateVersion` is `25.05`, so options whose defaults changed in `26.05`
  are set explicitly instead of being left on the legacy default
  (`gtk.gtk4.theme = null`, `neovim.withRuby = false`). Prefer the new value —
  but a default that changes a config's *format or API*, or needs a manual
  migration, is a rewrite to agree with the user first, not a flip.
- `hyprland.configType` is `"lua"`. Hyprland 0.56 warns that the old `.conf`
  (hyprlang) format goes away in 0.57, so the config was migrated to Lua. It is
  **not** written through `wayland.windowManager.hyprland.settings`: that option
  renders each attribute as an `hl.<name>(...)` call, which would mean escaped
  Lua inside Nix strings for every keybind. Instead `settings` is empty and
  `modules/hyprland/hyprland.lua` is appended verbatim via `extraConfig`.
- Firefox is installed as a plain package in `home.packages`; there is
  deliberately no declarative `programs.firefox` module. It is made the default
  browser by `xdg.mimeApps` in `home.nix`, which owns `~/.config/mimeapps.list` —
  add handlers there rather than editing that file by hand.
