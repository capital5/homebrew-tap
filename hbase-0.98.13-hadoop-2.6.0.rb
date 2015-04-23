require 'formula'

class Hbase09813Hadoop260 < Formula
  homepage 'http://hbase.apache.org'
  url 'http://s3.amazonaws.com/korrelate-public-repo/hadoop/hbase/hbase-0.98.13-hadoop-2.6.0-SNAPSHOT-bin.tar.gz'
  sha1 'a0139f9d4026fd20171d7baba5ab03d023eb8338'

  depends_on 'hadoop-2.6.0'

  def install
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf docs lib hbase-webapps]
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
