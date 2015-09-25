require 'formula'

class Hbase112 < Formula
  homepage 'http://hbase.apache.org'
  url 'http://s3.amazonaws.com/korrelate-public-repo/hadoop/hbase/hbase-1.1.2.tar.gz'
  sha1 'dc62a7bb102cb5c7096e74fe882699a2dddea8a4'

  depends_on 'hadoop-2.7.1'

  def install
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf lib hbase-webapps]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    inreplace "#{libexec}/conf/hbase-env.sh",
      "# export JAVA_HOME=/usr/java/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    Requires Java 1.6.0 or greater.

    You must also edit the configs in:
      #{libexec}/conf
    to reflect your environment.

    For more details:
      http://wiki.apache.org/hadoop/Hbase
    EOS
  end
end
