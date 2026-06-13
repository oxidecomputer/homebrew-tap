class OxideCli < Formula
  desc "CLI for the Oxide rack"
  homepage "https://github.com/oxidecomputer/oxide.rs"
  version "0.17.0+2026060800.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.17.0+2026060800.0.0/oxide-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a3e1b5c09169dcee818bcd273ad279f150d083c9734f6a9bdf2e1e836302d5e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.17.0+2026060800.0.0/oxide-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2d9e19cb2c1db88c64586b59828141ffd3792feb7c63f43524fbc008a3cb58b7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.17.0+2026060800.0.0/oxide-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "223dc32d9b2e985e725c3c345457eec732f31b63cdfbaafc476204ffc9ad4f80"
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "oxide" if OS.mac? && Hardware::CPU.arm?
    bin.install "oxide" if OS.mac? && Hardware::CPU.intel?
    bin.install "oxide" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!
    generate_completions_from_executable(
      bin/"oxide",
      "completion",
      shell_parameter_format: :arg,
      shells:                 [:bash, :fish, :zsh],
    )

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
