require "formula"

class Hadoop271 < Formula
  homepage "http://hadoop.apache.org/"
  url 'http://s3.amazonaws.com/korrelate-public-repo/hadoop/hadoop/hadoop-2.7.1.tar.gz'
  sha1 'bb0f3781a90e279f8d1963674e7a26a84b9bd8a3'

  # this patch is needed for hadoop 2.6.0 and following to work with s3 URLs. It adds
  # the tools directory to the classpath which used to be a part of the classpath by default.
  patch :DATA

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
    # But don't make rcc visible, it conflicts with Qt
    (bin/"rcc").unlink

    inreplace "#{libexec}/etc/hadoop/hadoop-env.sh",
      "export JAVA_HOME=${JAVA_HOME}",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    inreplace "#{libexec}/etc/hadoop/yarn-env.sh",
      "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    inreplace "#{libexec}/etc/hadoop/mapred-env.sh",
      "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/etc/hadoop/hadoop-env.sh,
      #{libexec}/etc/hadoop/mapred-env.sh and
      #{libexec}/etc/hadoop/yarn-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    You must set $HADOOP_HOME in your bash profile for this shiz to work 
    EOS
  end
end

# diff created by using the instructions here:
# https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md#creating-the-diff
__END__
diff --git a/etc/hadoop/hadoop-env.sh b/etc/hadoop/hadoop-env.sh
index f60b65a..0c3395a 100644
--- a/etc/hadoop/hadoop-env.sh
+++ b/etc/hadoop/hadoop-env.sh
@@ -96,3 +96,4 @@ export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}
 
 # A string representing this instance of hadoop. $USER by default.
 export HADOOP_IDENT_STRING=$USER
+export HADOOP_CLASSPATH="$HADOOP_HOME/libexec/share/hadoop/tools/lib/*:$HADOOP_CLASSPATH"
