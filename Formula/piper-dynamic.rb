class PiperDynamic < Formula
  desc "Python 3.14 implementation with a native compiler and shared LLVM"
  homepage "https://github.com/Hexadecimall/piper"
  license "MIT"

  depends_on "llvm"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.4/piper-aarch64-macos-dynamic-release"
    sha256 "96671688e64d7fbca72e75c1ea24bc6adbdb8a2f8a919966d8302b6c79b4a1bb"
  else
    depends_on arch: :x86_64
    url "https://github.com/Hexadecimall/piper/releases/download/v0.1.4/piper-x86_64-linux-dynamic-release"
    sha256 "8d706ee231bd356be8f4d35a8efeeda4cb9e7501f0bbea0ed3abb7e1a0241bdd"
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
