class OxideCliAT018 < Formula
  desc "CLI for the Oxide rack"
  homepage "https://github.com/oxidecomputer/oxide.rs"
  version "0.18.0+2026073100.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.18.0+2026073100.0.0/oxide-cli-aarch64-apple-darwin.tar.xz"
      sha256 "80baf50267e68da2324b2dab17d9961034de47239cbb341ed154627249b176f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.18.0+2026073100.0.0/oxide-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e862814f789ad6c23ea4dc58a0e38cac3872dd4171e85ff5d2a5121465efcf64"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oxidecomputer/oxide.rs/releases/download/v0.18.0+2026073100.0.0/oxide-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2f1fece544792c7f5a30b0479494dc86e7a619bc81274271c3c224dcf37aa477"
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
