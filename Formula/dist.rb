class Dist < Formula
  desc "Shippable application packaging for Rust"
  homepage "https://opensource.axo.dev/cargo-dist/"
  version "1.0.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.18/dist-aarch64-apple-darwin.tar.xz"
      sha256 "140da9aaf35cf760204ca41f06d8dac78c34febaa2d54ceba3fa0b73e81a9ccc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.18/dist-x86_64-apple-darwin.tar.xz"
      sha256 "bb767f83dbad135708d91240a70159fc33b483bd0a4eba7ea90cf0ee3829f4a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.18/dist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ed451a053d43a3d6739746aa06a0cd62fb52ee27f1c8b4b4c1169b80a39f1b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.18/dist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0b487d374397b2f2736ec6d4b40a59a280c4747511ee0aeaea3c418e5d9cf84e"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dist"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dist"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dist"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dist"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
