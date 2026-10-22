class OxideCliAT018 < Formula
  desc "CLI for the Oxide rack"
  homepage "https://github.com/oxidecomputer/oxide.rs"
  version "0.18.1+2026073100.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.18.1+2026073100.0.0/oxide-cli-aarch64-apple-darwin.tar.xz"
      sha256 "98839c99baca1189a7f123b0b127080e3a48063da0870ee578dc12ad580f95ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.18.1+2026073100.0.0/oxide-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4af8e51e486a37611063574c02569f5c30da74a98905b2724d9d050a940d0d2d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.18.1+2026073100.0.0/oxide-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1c3d5f7e7552fb7a473f0ae61264d14755609edf9ff9b11bbd2c2f57b732e61f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "oxide"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "oxide"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "oxide"
    end

    install_binary_aliases!
    generate_completions_from_executable(
      bin/"oxide",
      "completion",
      shell_parameter_format: :arg,
    )

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
