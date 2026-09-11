class PiperDynamic < Formula
  desc "Python 3.14 implementation with a native compiler and shared LLVM"
  homepage "https://github.com/Hexadecimall/piper"
  license "MIT"

  depends_on "llvm"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.3/piper-aarch64-macos-dynamic-release"
    sha256 "b70dc895193276a898aa564d905ff5168a5dc7df113aebac5febda12f233bd6e"
  else
    depends_on arch: :x86_64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.3/piper-x86_64-linux-dynamic-release"
    sha256 "89e2fef742cb10d7c23b3a0513359c421279b2973af2dc62024e1e96dff2133f"
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
