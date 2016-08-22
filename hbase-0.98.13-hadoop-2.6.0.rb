require 'formula'

class Hbase09813Hadoop260 < Formula
  homepage 'http://hbase.apache.org'
  url 'http://s3.amazonaws.com/korrelate-public-repo/hadoop/hbase/hbase-0.98.13-hadoop-2.6.0-SNAPSHOT-bin.tar.gz'
  sha256 '8907f2b0ef5153f9fb29ee257102dc3c91f1eafaefeeee0384b484516b7358b2'

  depends_on 'hadoop-2.5.2'

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
