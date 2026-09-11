class PiperDynamic < Formula
  desc "Python 3.14 implementation with a native compiler and shared LLVM"
  homepage "https://github.com/Hexadecimall/piper"
  license "MIT"

  depends_on "llvm"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.7/piper-aarch64-macos-dynamic-release"
    sha256 "3f417a32956998954101930ec2144b53070be52958b1e61e3b7c193e0a7a10c9"
  else
    depends_on arch: :x86_64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.7/piper-x86_64-linux-dynamic-release"
    sha256 "0a4878d1edb04093bf3cc5cebb7ecd777f7d309d04c21f368dc17c8529b54598"
  end

  conflicts_with "piper", because: "both install the piper command"

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
