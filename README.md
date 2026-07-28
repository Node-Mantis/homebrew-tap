# NodeMantis Homebrew Tap

Homebrew distribution channel for the `nodemantis` CLI. The formula wraps the
published npm `node-mantis` tarball (Node is the only dependency); it always
matches the npm release exactly.

```bash
brew install node-mantis/tap/nodemantis
nodemantis configure --api-key "ak_..."
nodemantis install-browser
nodemantis run "find a 2-bed rental in Lisbon under €1500" --url https://...
```

## Releasing

Version bumps arrive as automated PRs from the CleanSlate client-release
workflow (job `update-homebrew-tap`, authenticated via the `HOMEBREW_TAP_TOKEN`
secret). Each PR is gated by this repo's formula CI. To pin manually:

```bash
scripts/bump.sh 0.1.0-alpha.7
```

First-time seeding: run `scripts/bump.sh` against the first npm version that
ships the CLI bin (0.1.0-alpha.7 or later — earlier alphas have no `bin`),
commit, and push. The `REPLACE_VERSION` / `REPLACE_SHA256` placeholders in the
formula are not installable.
