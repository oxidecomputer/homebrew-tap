# homebrew-tap
[Homebrew](https://brew.sh) tap for installing Oxide projects on macOS.

## Usage

Add the tap:

```sh
brew tap oxidecomputer/tap
```

List the available formulas

```sh
brew tap-info oxidecomputer/tap --json | jq -r '.[].formula_names[]'
```

Install/upgrade a formula:

```sh
brew install oxidecomputer/tap/oxide-cli
brew upgrade oxidecomputer/tap/oxide-cli
```

Uninstall / Remove the tap

```sh
brew list --formula --full-name | grep '^oxidecomputer/tap/' | xargs brew uninstall
brew untap oxidecomputer/tap
```
