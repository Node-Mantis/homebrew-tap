class Nodemantis < Formula
  desc "NodeMantis browser-agent CLI"
  homepage "https://github.com/Node-Mantis/CleanSlate"
  # Prerelease versions do not sort reliably from the URL alone: always pin
  # url, version, and sha256 together (scripts/bump.sh does all three).
  url "https://registry.npmjs.org/node-mantis/-/node-mantis-REPLACE_VERSION.tgz"
  version "REPLACE_VERSION"
  sha256 "REPLACE_SHA256"
  license :cannot_represent

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      Configure credentials and install a browser once:
        nodemantis configure --api-key "ak_..."
        nodemantis install-browser
      Verify with: nodemantis doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nodemantis --version")
    assert_match "retrieve", shell_output("#{bin}/nodemantis --help")
  end
end
