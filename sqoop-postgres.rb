require 'formula'

class SqoopPostgres < Formula
  homepage 'http://sqoop.apache.org/'
  url 'http://korrelate-public-repo.s3.amazonaws.com/hadoop/sqoop/sqoop-1.4.4.bin__hadoop-2.0.4-alpha.tar.gz'
  version '1.4.4'

  depends_on 'hadoop-2.7.1'
  depends_on 'hbase-1.1.2'

  resource "postgresql_jar" do
    url "http://jdbc.postgresql.org/download/postgresql-9.2-1003.jdbc4.jar"
  end

  def spoop_envs
    <<-EOS.undent
      export HADOOP_HOME="#{HOMEBREW_PREFIX}"
      export HBASE_HOME="#{HOMEBREW_PREFIX}"
      export HIVE_HOME="#{HOMEBREW_PREFIX}"
      export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def install
    libexec.install %w[bin conf lib]
    libexec.install Dir['*.jar']
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    # Install a sqoop-env.sh file
    envs = libexec/'conf/sqoop-env.sh'
    envs.write(spoop_envs) unless envs.exist?

    resource("postgresql_jar").stage { libexec.install 'postgresql-9.2-1003.jdbc4.jar' }
  end

  def caveats; <<-EOS.undent
    Hadoop, Hive, HBase and ZooKeeper must be installed and configured
    for Sqoop to work.
    EOS
  end
end
