class Piper < Formula
  desc "Python 3.14 implementation with a native compiler and terminal-first dialect"
  homepage "https://github.com/Hexadecimall/piper"
  license "MIT"

  depends_on "z3"
  depends_on "zstd"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.4/piper-aarch64-macos-static-release"
    sha256 "b2f492a6307e95ecb6ad4855aa5d3dd46ee2fc351c38db82afcbe2dfc7eedfa5"
  else
    depends_on arch: :x86_64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.4/piper-x86_64-linux-static-release"
    sha256 "ff4cf03bc923a0e48b18341c018a3ab9fd45feb8d4d9dbd1c4515bbc22c93640"
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
