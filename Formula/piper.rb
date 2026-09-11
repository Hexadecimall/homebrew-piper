class Piper < Formula
  desc "Python 3.14 implementation with a native compiler and terminal-first dialect"
  homepage "https://github.com/Hexadecimall/piper"
  license "MIT"

  depends_on "z3"
  depends_on "zstd"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.7/piper-aarch64-macos-static-release"
    sha256 "1234b3682651265d96acca2cf0ca5f3c038a0ae5f942fbd38ee97013d33b122b"
  else
    depends_on arch: :x86_64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.7/piper-x86_64-linux-static-release"
    sha256 "570a1bad218d874c6c0035c280c08f40645c94159ef97a6fad714e1fbc9de110"
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
