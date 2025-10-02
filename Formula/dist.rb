class Dist < Formula
  desc "Shippable application packaging for Rust"
  homepage "https://opensource.axo.dev/cargo-dist/"
  version "1.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.9/dist-aarch64-apple-darwin.tar.xz"
      sha256 "c5284d13baa7248511295e1b0576f5e36f4e9abe31b6c9315b895d979ba81680"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.9/dist-x86_64-apple-darwin.tar.xz"
      sha256 "bc502378be9f28f18398d10092bae8d436fb8a64f8ea6c66df54b778069ddbd4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.9/dist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f94e43408a765c4cdfb08d602da44111c7a7777674dd533d66cc7b8a7827f201"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.9/dist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a43672eade42d0a31def1c6c010b46e7afaa84a3d3881b4130347ee77f7532b2"
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
