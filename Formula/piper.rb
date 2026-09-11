class Piper < Formula
  desc "Python 3.14 implementation with a native compiler and terminal-first dialect"
  homepage "https://github.com/Hexadecimall/piper"
  license "MIT"

  bottle do
    root_url "https://github.com/Hexadecimall/homebrew-piper/releases/download/v0.1.3"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "ea61674bbc1a6de9dfbbc04782c49098e08724f96ae151c256e5cfdae8088bd8"
    sha256 cellar: :any, x86_64_linux:  "33897aa5470a646e2dcb29566a75a6f847c9ab6aff53c5c26fb14a2cab16d6e7"
  end

  depends_on "z3"
  depends_on "zstd"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.3/piper-aarch64-macos-static-release"
    sha256 "a0791808439a9ec934ac43221f6b0b52dc3f537c63ca50ce4f78eca83c2104f7"
  else
    depends_on arch: :x86_64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.3/piper-x86_64-linux-static-release"
    sha256 "a2a23582050e7fd687df4fb30f47eaf153f1bd6b23a14a8ce13b5f6ffe788442"
  end

  conflicts_with "piper-dynamic", because: "both install the piper command"

  def install
    asset = Dir["piper-*"]
    odie "Piper release contains no executable" if asset.empty?
    odie "Piper release contains multiple executables" unless asset.one?
    bin.install asset.first => "piper"
  end

  test do
    assert_equal "piper #{version}", shell_output("#{bin}/piper --version").strip
    (testpath/"hello.py").write "print('piper')\n"
    system bin/"piper", "compile", testpath/"hello.py", "-o", testpath/"hello"
    assert_equal "piper", shell_output(testpath/"hello").strip
  end
end
