class OxideCli < Formula
  desc "CLI for the Oxide rack"
  homepage "https://github.com/oxidecomputer/oxide.rs"
  version "0.13.0+20250730.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.13.0+20250730.0.0/oxide-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4f84e404ff0d077dc796c92e0252ca98371ab0daed506b1c5831e933b155f118"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.13.0+20250730.0.0/oxide-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1ac3cb010c3cbe664d123c9ff4ff9ffb3b6da0789779e2bcda34143f490367b0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.13.0+20250730.0.0/oxide-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e128cb1b8956e17e1173a13c57e5da93151be1392ee14096f10ab4238e42c4e6"
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
