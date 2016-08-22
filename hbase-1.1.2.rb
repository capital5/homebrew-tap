require 'formula'

class Hbase112 < Formula
  homepage 'http://hbase.apache.org'
  url 'http://s3.amazonaws.com/korrelate-public-repo/hadoop/hbase/hbase-1.1.2.tar.gz'
  sha256 '8ca5bf0203cef86b4a0acbba89afcd5977488ebc73eec097e93c592b16f8bede'

  depends_on 'hadoop-2.5.2'

  def install
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf lib hbase-webapps]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    resource("phoenix_client").stage  { (libexec/"lib").install "phoenix-4.4.0-HBase-1.1-client.jar" }

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

  resource "phoenix_client" do
    url "http://korrelate-public-repo.s3.amazonaws.com/hadoop/phoenix/phoenix-4.4.0-HBase-1.1-client.jar"
    sha256 '30a8bc444542cdbfc5eb7b228e3b23b7a3220991347f31daeb6d628a8e716d42'
  end

end
