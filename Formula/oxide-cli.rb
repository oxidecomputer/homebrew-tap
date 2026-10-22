class OxideCli < Formula
  desc "CLI for the Oxide rack"
  homepage "https://github.com/oxidecomputer/oxide.rs"
  version "0.19.1+2026091500.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.19.1+2026091500.0.0/oxide-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f40b2447f067e8feacabd52c6a41e3a016382a53b4bde05aaccfda3f107ed43b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.19.1+2026091500.0.0/oxide-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a92e0fb21ccd68b10aa8698525dcf4ab9002d95d88fb83e76c876925df8be494"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.19.1+2026091500.0.0/oxide-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "307a3346efee9e3a58a59c941f7164db211a9f94a774bf4c60413e803599aa4e"
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
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
