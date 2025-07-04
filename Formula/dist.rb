class Dist < Formula
  desc "Shippable application packaging for Rust"
  homepage "https://opensource.axo.dev/cargo-dist/"
  version "1.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.6/dist-aarch64-apple-darwin.tar.xz"
      sha256 "fb3b5b740a3cc4697f2eaea363addec3e57b5750764596ea9cbb238397643b40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.6/dist-x86_64-apple-darwin.tar.xz"
      sha256 "028d648cbde8f4f48a9fe9aa745f871fcdaf309070224956659fb2eae0f8c80c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.6/dist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e182783697620b32e400968a0533a1aa92b00bc8f992ac742fd4dfd2f341c96a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.6/dist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee63210c4e90a75d00b393d606a13fbca8b5fdc7071aaf68ee739e180f6a0488"
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
