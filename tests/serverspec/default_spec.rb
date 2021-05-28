# frozen_string_literal: true

require "spec_helper"
require "serverspec"

default_user    = "root"
default_group   = "root"
es_package_name = "opendistroforelasticsearch"
es_service_name = "elasticsearch"
es_config_dir = "/etc/elasticsearch"
es_user_name = "elasticsearch"
es_user_group = "elasticsearch"
java_home = ""
jvm_option = "#{es_config_dir}/jvm.options"
plugins = [
  # XXX depending on versions, some plugins have -, others `_`.
  "opendistro[-_]security",
  "opendistro[-_]alerting"
]
es_extra_packages = []
extra_files = %w[
  opendistro_security/securityconfig/roles.yml
  opendistro_security/securityconfig/roles_mapping.yml
  opendistro_security/securityconfig/internal_users.yml
  opendistro_security/securityconfig/config.yml
]

es_plugin_command = "/usr/share/elasticsearch/bin/elasticsearch-plugin"
es_plugins_directory = "/usr/share/elasticsearch/plugins"
es_data_directory = "/var/lib/elasticsearch"
es_log_directory  = "/var/log/elasticsearch"
public_certs = [
  "admin.pem",
  "node.pem",
  "root-ca.pem"
]
private_certs = [
  "admin-key.pem",
  "node-key.pem",
  "root-ca-key.pem"
]

case os[:family]
when "freebsd"
  default_group = "wheel"
  es_package_name = "opendistroforelasticsearch"
  es_config_dir = "/usr/local/etc/elasticsearch"
  es_plugin_command = "/usr/local/lib/elasticsearch/bin/elasticsearch-plugin"
  es_plugins_directory = "/usr/local/lib/elasticsearch/plugins"
  es_data_directory = "/var/db/elasticsearch"
  java_home = "/usr/local"
  jvm_option = "/usr/local/etc/elasticsearch/jvm.options"
when "openbsd"
  default_group = "wheel"
  es_user_name = "_elasticsearch"
  es_user_group = "_elasticsearch"
  es_plugin_command = "/usr/local/elasticsearch/bin/plugin"
  es_plugins_directory = "/usr/local/elasticsearch/plugins"
  es_data_directory = "/var/elasticsearch"
when "ubuntu"
  es_extra_packages = ["elasticsearch-oss"]
end

describe file es_config_dir do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
end

describe file(es_data_directory) do
  it { should be_directory }
  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  it { should be_mode 755 }
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

es_extra_packages.each do |p|
  describe package p do
    it { should be_installed }
  end
end

describe package(es_package_name) do
  it { should be_installed }
end

describe file jvm_option do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  its(:content) { should match(Regexp.escape("-XX:+UseCompressedOops")) }
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
when "ubuntu"
  describe file("/etc/default/elasticsearch") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/Managed by ansible/) }
    its(:content) { should match(/MAX_OPEN_FILES=65535/) }
  end
when "redhat"
  describe file("/etc/sysconfig/elasticsearch") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/Managed by ansible/) }
    its(:content) { should match(/MAX_OPEN_FILES=65535/) }
  end
when "openbsd"
  describe file("/etc/elasticsearch/jvm.in") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/JAVA_OPTS=\"#{Regexp.escape("-XX:+UseCompressedOops")}\"$/) }
  end
end

[9200, 9300].each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe file("#{es_config_dir}/elasticsearch.yml") do
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
    its(:stderr) { should eq "" }
    its(:exit_status) { should eq 0 }
  end
end

extra_files.each do |f|
  describe file "#{es_plugins_directory}/#{f}" do
    it { should be_file }
    it { should be_owned_by default_user }
    it { should be_grouped_into es_user_group }
    it { should be_mode 640 }
    its(:content) { should match(/Managed by ansible/) }
  end
end

public_certs.each do |c|
  describe file "#{es_config_dir}/#{c}" do
    it { should be_file }
    it { should be_mode 444 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/-----BEGIN CERTIFICATE-----/) }
    its(:content) { should match(/-----END CERTIFICATE-----/) }
  end
end

private_certs.each do |c|
  describe file "#{es_config_dir}/#{c}" do
    it { should be_file }
    it { should be_owned_by es_user_name }
    it { should be_grouped_into es_user_group }
    it { should be_mode c == "node-key.pem" ? 600 : 400 }
    its(:content) { should match(/-----BEGIN (?:RSA )?PRIVATE KEY-----/) }
    its(:content) { should match(/-----END (?:RSA )?PRIVATE KEY-----/) }
  end
end
