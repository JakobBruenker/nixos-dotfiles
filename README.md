nixos-dotfiles
==============

My personal configuration files for my nixos systems. I wouldn't recommend
using this to anyone else.

Installation
------------

First, install nixos using the guide on the wiki. The default configuration
should work well enough, as long as it gives you have Internet access during
the next step.

Then, run

```bash
nix-shell -p git
git clone https://github.com/JakobBruenker/nixos-dotfiles.git
nixos-dotfiles/setup.sh
```

and follow the instructions. Reboot, and your system should be ready to go.
