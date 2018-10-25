nixos-dotfiles
==============

My personal configuration files for my nixos systems. I wouldn't recommend
using this to anyone else.

Installation
------------

First, install nixos using the guide on the wiki. When it comes to the
configuration file, run the following:

```bash
mkdir -p /etc/nixos
curl https://raw.githubusercontent.com/JakobBruenker/nixos-dotfiles/master/configuration.nix > /etc/nixos/configuration.nix
```

Once it's installed and you've booted up nixos, run

```bash
nix-shell -p git
git clone https://github.com/JakobBruenker/nixos-dotfiles.git
nixos-dotfiles/scripts/setup.sh
```

and follow the instructions. Reboot, and your system should be ready to go.
