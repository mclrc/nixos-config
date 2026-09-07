set positional-arguments

# Which nixosConfigurations.<name> this machine runs. Each host's hostname is
# set to its config name, so $hostname is used when it names a real config.
# Otherwise (a host not yet switched since the rename) it falls back to matching
# the root filesystem UUID against each host's own fileSystems."/" device.
# Override with: PROFILE=desktop just check
profile := env("PROFILE", ```
    hosts="$(nix eval --json '.#nixosConfigurations' --apply builtins.attrNames 2>/dev/null \
      | tr -d '[]"' | tr ',' '\n')"
    h="$(hostname)"
    if echo "$hosts" | grep -qx "$h"; then
      echo "$h"
    else
      uuid="$(findmnt -no UUID /)"
      for c in $hosts; do
        dev="$(nix eval --raw ".#nixosConfigurations.$c.config.fileSystems.\"/\".device" 2>/dev/null)"
        if [ "$dev" = "/dev/disk/by-uuid/$uuid" ]; then echo "$c"; break; fi
      done
    fi
```)

[private]
default:
    @just --list --unsorted

# Fail early if profile auto-detection came up empty.
[private]
_guard:
    #!/usr/bin/env bash
    if [ -z "{{profile}}" ]; then
      echo "could not detect this machine's profile from the root fs UUID." >&2
      echo "available: $(just hosts | tr '\n' ' ')" >&2
      echo "re-run as: PROFILE=<name> just <recipe>" >&2
      exit 1
    fi

# Warn about untracked files: the flake build cannot see them.
[private]
_untracked:
    #!/usr/bin/env bash
    untracked="$(git ls-files --others --exclude-standard)"
    if [ -n "$untracked" ]; then
      echo "WARNING: these files are untracked and therefore INVISIBLE to the flake build."
      echo "         'git add' them or nix will build as if they did not exist:"
      echo "$untracked" | sed 's/^/           /'
      echo
    fi

# Print the profile detected for this machine.
which:
    @echo "{{profile}}"

# List every host defined in flake.nix.
hosts:
    @nix eval --json .#nixosConfigurations --apply builtins.attrNames 2>/dev/null | tr -d '[]"' | tr ',' '\n'

# SAFE, no sudo: evaluate this machine's config + report what a switch would build.
check: _untracked _guard
    nixos-rebuild dry-build --flake .#{{profile}}

# SAFE, no sudo: `check` for every host - use after editing shared files.
check-all: _untracked
    #!/usr/bin/env bash
    set -uo pipefail
    fail=0
    for h in $(just hosts); do
      echo "=== $h ==="
      nixos-rebuild dry-build --flake ".#$h" || fail=1
    done
    exit $fail

# SAFE, no sudo: fully build the new system closure into ./result (no activation).
build: _untracked _guard
    nixos-rebuild build --flake .#{{profile}}

# SAFE, no sudo: build, then list every package the switch would add/remove/bump.
diff: build
    #!/usr/bin/env bash
    out="$(nix store diff-closures /run/current-system ./result)"
    if [ -z "$out" ]; then
      echo "no closure differences - the running system already matches this config."
    else
      echo "$out"
    fi

# NEEDS SUDO - the human runs this, never an agent. Activates the new config.
switch: _guard
    sudo nixos-rebuild switch --flake .#{{profile}}

# NEEDS SUDO - activate now but do NOT make it the boot default (reboot = undo).
try: _guard
    sudo nixos-rebuild test --flake .#{{profile}}

# NEEDS SUDO - stage for next boot without touching the running system.
boot: _guard
    sudo nixos-rebuild boot --flake .#{{profile}}

# NEEDS SUDO - roll back to the previous generation.
rollback: _guard
    sudo nixos-rebuild switch --rollback --flake .#{{profile}}

# Update all flake inputs (nixpkgs, home-manager). Rewrites flake.lock.
update:
    nix flake update

# Update a single flake input, e.g. `just update-input nixpkgs`.
update-input input:
    nix flake update {{input}}

# SAFE: check an attribute exists in the pinned nixpkgs before adding it to a list.
has pkg:
    @nix eval --raw .#nixosConfigurations.{{profile}}.pkgs.{{pkg}}.name 2>/dev/null && echo || (echo "no such package: {{pkg}}" >&2; exit 1)

# SAFE: fuzzy-search nixpkgs by name/description (queries search.nixos.org).
search +terms:
    @nix-search "$@"

# SAFE: evaluate one option, e.g. `just opt networking.hostName`.
opt path:
    @nix eval .#nixosConfigurations.{{profile}}.config.{{path}} 2>&1 | tail -20

# Remove the ./result symlink left behind by `build`/`diff`.
clean:
    rm -f result

# NEEDS SUDO - delete generations older than 30 days and collect garbage.
gc:
    sudo nix-collect-garbage --delete-older-than 30d
