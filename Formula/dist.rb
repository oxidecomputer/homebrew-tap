class Dist < Formula
  desc "Shippable application packaging for Rust"
  homepage "https://opensource.axo.dev/cargo-dist/"
  version "1.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.7/dist-aarch64-apple-darwin.tar.xz"
      sha256 "5f2c179c12965ead4bc3620218869ffcb4e9186c3958d233eb13dabe5b2c566f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.7/dist-x86_64-apple-darwin.tar.xz"
      sha256 "09a4b51a1d1fe518ec2eec01932824fa6656cda7b8cfdc79733bd90280ac57f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.7/dist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da0dbad5b34cf07c44f64a0e4d91958a3193ec46f69bd9b91a568097538754ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/cargo-dist/releases/download/v1.0.7/dist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2b7460bbb921bc9b5b5d802b339706fedef2cbdc768dce27753fa9f5fbbb348"
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
