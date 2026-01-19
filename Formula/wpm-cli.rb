class WpmCli < Formula
  desc "A terminal-based typing speed test"
  homepage "https://github.com/truls27a/wpm"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/truls27a/wpm/releases/download/v0.1.2/wpm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e567ad6bf811624e2953562306cc895d36c32ca2b183a5d9e2de121cf00ace62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/truls27a/wpm/releases/download/v0.1.2/wpm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "018facb4809009bee87ba1650a286a9fdc11a8f75b194a6d3b70742398b93781"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/truls27a/wpm/releases/download/v0.1.2/wpm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0712e7e1c852b0906377b2a205dbfcd17cdbb7b2ce7270d326cddf8548c3fba2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/truls27a/wpm/releases/download/v0.1.2/wpm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56543083c70efef343948cee6e69ffbd383cd2c33834fc83ae753d91112b2e4d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "wpm" if OS.mac? && Hardware::CPU.arm?
    bin.install "wpm" if OS.mac? && Hardware::CPU.intel?
    bin.install "wpm" if OS.linux? && Hardware::CPU.arm?
    bin.install "wpm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
