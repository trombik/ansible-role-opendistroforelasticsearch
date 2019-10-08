require "spec_helper"
require "serverspec"

default_user    = "root"
default_group   = "root"
es_package_name = "opendistroforelasticsearch"
es_service_name = "elasticsearch"
es_config_path  = "/etc/elasticsearch"
es_user_name    = "elasticsearch"
es_user_group   = "elasticsearch"
java_home       = ""
plugins = [
  "opendistro_security"
]
extra_files = %w[
  opendistro_security/securityconfig/roles.yml
  opendistro_security/securityconfig/roles_mapping.yml
  opendistro_security/securityconfig/internal_users.yml
  opendistro_security/securityconfig/config.yml
]

es_plugin_command = "/usr/share/elasticsearch/bin/plugin"
es_plugins_directory = "/usr/share/elasticsearch/plugins"
es_data_directory = "/var/lib/elasticsearch"
es_log_directory  = "/var/log/elasticsearch"

case os[:family]
when "freebsd"
  default_group = "wheel"
  es_package_name = "opendistroforelasticsearch"
  es_config_path = "/usr/local/etc/elasticsearch"
  es_plugin_command = "/usr/local/lib/elasticsearch/bin/elasticsearch-plugin"
  es_plugins_directory = "/usr/local/lib/elasticsearch/plugins"
  es_data_directory = "/var/db/elasticsearch"
  java_home = "/usr/local"
when "openbsd"
  default_group = "wheel"
  es_user_name = "_elasticsearch"
  es_user_group = "_elasticsearch"
  es_plugin_command = "/usr/local/elasticsearch/bin/plugin"
  es_plugins_directory = "/usr/local/elasticsearch/plugins"
  es_data_directory = "/var/elasticsearch"
end

describe file(es_data_directory) do
  it { should be_directory }
  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  it { should be_mode 750 }
end

describe file(es_log_directory) do
  it { should be_directory }
  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  it { should be_mode 755 }
end

describe service(es_service_name) do
  it { should be_running }
end

describe package(es_package_name) do
  it { should be_installed }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d") do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
  end

  describe file("/etc/rc.conf.d/opendistroforelasticsearch") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/^elasticsearch_java_home=/) }
  end

  describe file("/usr/local/etc/elasticsearch/jvm.options") do
    its(:content) { should match Regexp.escape("-XX:+UseCompressedOops") }
  end

  #  XXX `process` does not support FreeBSD's `ps(1)`
  #
  #  describe process("/usr/local/openjdk8/bin/java") do
  #    it { should be_running }
  #    its(:args) { should match(Regexp.escape("-XX:+UseCompressedOops")) }
  #  end
  describe command("ps axww") do
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/openjdk8/bin/java") }\s+.*#{ Regexp.escape("-XX:+UseCompressedOops") }/) }
  end
when "ubuntu"
  describe file("/etc/default/elasticsearch") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/^ES_JAVA_OPTS=\"#{ Regexp.escape("-XX:+UseCompressedOops") }\"$/) }
  end

  describe process("java") do
    it { should be_running }
    its(:args) { should match(Regexp.escape("-XX:+UseCompressedOops")) }
  end
when "redhat"
  describe file("/etc/sysconfig/elasticsearch") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/^ES_JAVA_OPTS=\"#{ Regexp.escape("-XX:+UseCompressedOops") }\"$/) }
  end

  describe process("java") do
    it { should be_running }
    its(:args) { should match(Regexp.escape("-XX:+UseCompressedOops")) }
  end
when "openbsd"
  describe file("/etc/elasticsearch/jvm.in") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/JAVA_OPTS=\"#{ Regexp.escape("-XX:+UseCompressedOops") }\"$/) }
  end

  # XXX same issue as FreeBSD
  # -Xms257m -Xmx1024m
  describe command("ps axww") do
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/jdk-1.8.0/bin/java") }\s+.*#{ Regexp.escape("-XX:+UseCompressedOops") }/) }
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/jdk-1.8.0/bin/java") }\s+.*#{ Regexp.escape("-Xms257m") }/) }
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/jdk-1.8.0/bin/java") }\s+.*#{ Regexp.escape("-Xmx1024m") }/) }
  end
end

[9200, 9300].each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe file("#{es_config_path}/elasticsearch.yml") do
  it { should be_file }
  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  it { should be_mode 440 }
  its(:content_as_yaml) { should include("cluster.name" => "testcluster") }
  its(:content_as_yaml) { should include("node.name" => "testnode") }
  its(:content_as_yaml) { should include("network.publish_host" => ["10.0.2.15"]) }
  its(:content_as_yaml) { should include("http.cors.enabled" => "true") }
  its(:content_as_yaml) { should include("http.cors.allow-origin" => "*") }
  its(:content_as_yaml) { should include("http.cors.max-age" => 86_400) }
  its(:content_as_yaml) { should include("http.cors.allow-methods" => "OPTIONS, HEAD, GET, POST, PUT, DELETE") }
  its(:content_as_yaml) { should include("http.cors.allow-headers" => "X-Requested-With, Content-Type, Content-Length") }
  its(:content_as_yaml) { should include("http.cors.allow-credentials" => "true") }
end

describe file(es_plugins_directory) do
  it { should be_directory }
  it { should be_owned_by default_user }
  it { should be_grouped_into default_group }
  it { should be_mode 755 }
end

plugins.each do |p|
  describe command("env JAVA_HOME=#{java_home} #{es_plugin_command} list") do
    its(:stdout) { should match(/^#{p}$/) }
    its(:stderr) do
      pending "ES warns that future versions of Elasticsearch will require Java 11; your Java version from [/usr/local/openjdk8/jre] does not meet this requirement"
      should eq ""
    end
    its(:exit_status) { should eq 0 }
  end
end

extra_files.each do |f|
  describe file "#{es_plugins_directory}/#{f}" do
    it { should be_file }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/Managed by ansible/) }
  end
end
