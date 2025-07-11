class Dist < Formula
  desc "Shippable application packaging for Rust"
  homepage "https://opensource.axo.dev/cargo-dist/"
  version "1.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.8/dist-aarch64-apple-darwin.tar.xz"
      sha256 "d6574279269bec65588bdcc28ef26978621781438c313e9fa570beab32462c4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.8/dist-x86_64-apple-darwin.tar.xz"
      sha256 "1372c4fc22af32de130e2a235407882dca1baf17b31eb1c61af5d2824f2b4188"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.8/dist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5bf955a5f63054a446aa175b5b6c2b045ac065702f88477de796d21147b5abd4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.8/dist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e6adcfc3968a5aab98760518431c8de27651047bdb24722f57347e1a8ef19b0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {
      dist: [
        "cargo-dist",
      ],
    },
    "aarch64-unknown-linux-gnu":          {
      dist: [
        "cargo-dist",
      ],
    },
    "aarch64-unknown-linux-musl-dynamic": {
      dist: [
        "cargo-dist",
      ],
    },
    "aarch64-unknown-linux-musl-static":  {
      dist: [
        "cargo-dist",
      ],
    },
    "x86_64-apple-darwin":                {
      dist: [
        "cargo-dist",
      ],
    },
    "x86_64-pc-windows-gnu":              {
      "dist.exe": [
        "cargo-dist.exe",
      ],
    },
    "x86_64-unknown-linux-gnu":           {
      dist: [
        "cargo-dist",
      ],
    },
    "x86_64-unknown-linux-musl-dynamic":  {
      dist: [
        "cargo-dist",
      ],
    },
    "x86_64-unknown-linux-musl-static":   {
      dist: [
        "cargo-dist",
      ],
    },
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
    bin.install "dist" if OS.mac? && Hardware::CPU.arm?
    bin.install "dist" if OS.mac? && Hardware::CPU.intel?
    bin.install "dist" if OS.linux? && Hardware::CPU.arm?
    bin.install "dist" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
