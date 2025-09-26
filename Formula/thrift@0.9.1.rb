class ThriftAT091 < Formula
    desc "Framework for scalable cross-language services development"
    homepage "https://thrift.apache.org"
    url "https://github.com/apache/thrift/archive/refs/tags/0.9.1.tar.gz"
    sha256 "f9c04bf08e09de9f79dc8b0960817588ae2c08007b1980029ef1a1d8294e835f"
    license "Apache-2.0"
  
    bottle do
        rebuild 1
    end
  
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
    depends_on "openssl@3" => :build # for `openssl/err.h`
    depends_on "pkg-config" => :build
    #depends_on "boost"
  
    uses_from_macos "flex" => :build
  
    # Fix clang compile error
    patch do
      url "https://github.com/apache/thrift/commit/111e62d2a6ead1e325b7ecdb696f1bdea90c4aab.patch?full_index=1"
      sha256 "e9c6680b17d9da5611282f8729ea02d4c27a994cefcca8eaf0b5a461e215de3d"
    end
  
    def install
      args = %w[
        --without-boost
        --without-erlang
        --without-haskell
        --without-java
        --without-perl
        --without-php
        --without-php_extension
        --without-python
        --without-ruby
        --disable-tests
        --disable-tutorial
      ]
  
      ENV.cxx11 if ENV.compiler == :clang
  
      # Don't install extensions to /usr
      ENV["JAVA_PREFIX"] = pkgshare/"java"
  
      # We need to regenerate the configure script since it doesn't have all the changes.
      system "./bootstrap.sh"
  
      system "./configure", *std_configure_args, *args
      ENV.deparallelize
      system "make", "install"
    end
  
    test do
      assert_match "Thrift", shell_output("#{bin}/thrift --version")
    end
  end
