class Xeora < Formula
  desc "Web Development Framework"
  homepage "https://xeora.org"
  url "https://github.com/xeora/v7-framework/archive/v7.4.8441.tar.gz"
  sha256 "6111c1d4c2e70aee8c870a5b0dc3657694ba77de740fdb4cda363f6563522136"
  license "MIT"
  head "https://github.com/xeora/v7-framework.git"

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "/p:AssemblyVersion=7.4.8441",
           "src/Xeora.CLI/Xeora.CLI.csproj"

    libexec.install Dir["out/*"]

    (bin/"xeora").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/xeora.dll" "$@"
    EOS
  end

  test do
    system "xeora", "create", "-x", testpath
    system "xeora", "compile", "-y", "-d", "Main", testpath
    assert_match("e7fb8a97a6f8e81a24ca9f6d832d4c22",
      shell_output("/sbin/md5 -q #{testpath}/Domains/Main/Content.xeora"))
  end
end
