require 'formula'

class PigKorrelate152 < Formula
  homepage 'https://github.com/korrelate/pig'
  head 'https://github.com/korrelate/pig.git', :using => :git, :branch => "branch-0.15.2-korrelate"

  patch :DATA

  def install
    # the command we use to install this beast
    system "ant clean jar -Dhadoopversion=23 -Dhbaseversion=95"
    bin.install 'bin/pig'
    lib.install Dir["lib/*"]
    resource("zebra").stage { lib.install "zebra-0.8.0.jar" }
    # if updating this and in doubt of where to look for this thing,
    # go to /Library/Caches/Homebrew/pig-korrelate15--git and run the system command
    # (ant clean...) listed above in that directory. Once complete, you can see
    # the name of the JAR and you will put the name of that JAR here:
    prefix.install ["pig-0.15.2-KORRELATE-core-h2.jar"]
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
