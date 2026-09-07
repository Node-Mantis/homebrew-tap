class Nodemantis < Formula
  desc "NodeMantis browser-agent CLI"
  homepage "https://github.com/Node-Mantis/CleanSlate"
  # Prerelease versions do not sort reliably from the URL alone: always pin
  # url, version, and sha256 together (scripts/bump.sh does all three).
  url "https://registry.npmjs.org/node-mantis/-/node-mantis-0.1.0-alpha.17.tgz"
  version "0.1.0-alpha.17"
  sha256 "a05bd27509f8714c64122ce8bcef922f7db1e3262c25c313911b71fd446f24b4"
  license :cannot_represent

  depends_on "node"

  def install
    # Homebrew's npm defaults include a release-age gate (--min-release-age)
    # that silently SKIPS optionalDependencies published within the last day —
    # and the per-platform agent runtime is exactly such an optional dep, so a
    # formula bump right after a release would install a runtime-less CLI.
    # This install is first-party and pinned by version + sha256; disable the
    # age gate and then hard-assert the runtime actually landed.
    system "npm", "install", *std_npm_args, "--min-release-age=0"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    runtime = Dir["#{libexec}/lib/node_modules/node-mantis/node_modules/node-mantis-runtime-*"]
    odie "The platform agent runtime package was not installed" if runtime.empty?
  end

  def caveats
    <<~EOS
      Configure credentials and install a browser once:
        nodemantis configure --api-key "sk_live_<copy-from-dashboard>"
        nodemantis install-browser
      Verify with: nodemantis doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nodemantis --version")
    assert_match "retrieve", shell_output("#{bin}/nodemantis --help")
  end
end
