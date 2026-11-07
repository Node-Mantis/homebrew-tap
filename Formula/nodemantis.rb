class Nodemantis < Formula
  desc "NodeMantis browser-agent CLI"
  homepage "https://github.com/Node-Mantis/CleanSlate"
  # Prerelease versions do not sort reliably from the URL alone: always pin
  # url, version, and sha256 together (scripts/bump.sh does all three).
  url "https://registry.npmjs.org/node-mantis/-/node-mantis-0.1.2.tgz"
  version "0.1.2"
  sha256 "c367072a674b197b21f4d310c8f7d953f44accf664f6ece14ee5367ab2ecf78c"
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
      NodeMantis drives your installed Google Chrome. Configure credentials once:
        nodemantis configure --api-key "sk_live_<copy-from-dashboard>"
      Verify with: nodemantis doctor
      If you also installed NodeMantis with npm or pip, the first nodemantis on
      your PATH runs; nodemantis doctor shows which one that is.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nodemantis --version")
    assert_match "retrieve", shell_output("#{bin}/nodemantis --help")
  end
end
