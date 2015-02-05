require 'formula'

class PigKorrelate14 < Formula
  homepage 'https://github.com/korrelate/pig'
  head 'https://github.com/korrelate/pig.git', :using => :git, :branch => "branch-0.14.2"

  patch :DATA

  def install
    system "ant clean jar -Dhadoopversion=23 -Dhbaseversion=95"
    bin.install 'bin/pig'
    lib.install Dir["lib/*"]
    resource("zebra").stage { lib.install "zebra-0.8.0.jar" }
    prefix.install ["pig-0.14.0-SNAPSHOT-core-h2.jar"]
  end

  def caveats; <<-EOS.undent
    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  resource "zebra" do
    url "http://korrelate.s3.amazonaws.com/hadoop/lib/zebra-0.8.0.jar"
  end

end

# There's something weird with Pig's launch script, it doesn't find the correct
# path. This patch finds PIG_HOME from the pig binary path's symlink.
__END__
diff -u a/bin/pig b/bin/pig
--- a/bin/pig 2011-09-30 08:55:58.000000000 +1000
+++ b/bin/pig 2011-11-28 11:18:36.000000000 +1100
@@ -55,11 +55,8 @@

 # resolve links - $0 may be a softlink
 this="${BASH_SOURCE-$0}"
-
-# convert relative path to absolute path
-bin=$(cd -P -- "$(dirname -- "$this")">/dev/null && pwd -P)
-script="$(basename -- "$this")"
-this="$bin/$script"
+here=$(dirname $this)
+this="$here"/$(readlink $this)

 # the root of the Pig installation
 export PIG_HOME=`dirname "$this"`/..
