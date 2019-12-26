# `trombik.opendistroforelasticsearch`

`ansible` role to manage `opendistroforelasticsearch`.

## for FreeBSD users

`textproc/opendistroforelasticsearch` is not currently available in the
official ports tree. A WIP port is available at
[trombik/opendistroforelasticsearch](https://github.com/trombik/opendistroforelasticsearch).
The package must be available for installation at somewhere, i.e. in YOUR
package tree.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `opendistroforelasticsearch_user` | | `{{ __opendistroforelasticsearch_user }}` |
| `opendistroforelasticsearch_group` | | `{{ __opendistroforelasticsearch_group }}` |
| `opendistroforelasticsearch_log_dir` | | `{{ __opendistroforelasticsearch_log_dir }}` |
| `opendistroforelasticsearch_db_dir` | | `{{ __opendistroforelasticsearch_db_dir }}` |
| `opendistroforelasticsearch_scripts_dir` | | `{{ __opendistroforelasticsearch_scripts_dir }}` |
| `opendistroforelasticsearch_plugins_dir` | | `{{ __opendistroforelasticsearch_plugins_dir }}` |
| `opendistroforelasticsearch_plugin_command` | | `{{ __opendistroforelasticsearch_plugin_command }}` |
| `opendistroforelasticsearch_plugins` | | `[]` |
| `opendistroforelasticsearch_service` | | `{{ __opendistroforelasticsearch_service }}` |
| `opendistroforelasticsearch_package` | | `{{ __opendistroforelasticsearch_package }}` |
| `opendistroforelasticsearch_conf_dir` | | `{{ __opendistroforelasticsearch_conf_dir }}` |
| `opendistroforelasticsearch_jvm_options` | | `""` |
| `opendistroforelasticsearch_conf_file` | | `{{ opendistroforelasticsearch_conf_dir }}/elasticsearch.yml` |
| `opendistroforelasticsearch_flags` | | `""` |
| `opendistroforelasticsearch_config` | | `""` |
| `opendistroforelasticsearch_http_port` | | `9200` |
| `opendistroforelasticsearch_java_home` | | `{{ __opendistroforelasticsearch_java_home }}` |
| `opendistroforelasticsearch_extra_plugin_files` | | `[]` |
| `opendistroforelasticsearch_include_role_x509_certificate` | | `yes` |

## Debian

| Variable | Default |
|----------|---------|
| `__opendistroforelasticsearch_user` | `elasticsearch` |
| `__opendistroforelasticsearch_group` | `elasticsearch` |
| `__opendistroforelasticsearch_log_dir` | `/var/log/elasticsearch` |
| `__opendistroforelasticsearch_db_dir` | `/var/lib/elasticsearch` |
| `__opendistroforelasticsearch_package` | `opendistroforelasticsearch` |
| `__opendistroforelasticsearch_conf_dir` | `/etc/elasticsearch` |
| `__opendistroforelasticsearch_scripts_dir` | `""` |
| `__opendistroforelasticsearch_plugins_dir` | `/usr/share/elasticsearch/plugins` |
| `__opendistroforelasticsearch_plugin_command` | `/usr/share/elasticsearch/bin/elasticsearch-plugin` |
| `__opendistroforelasticsearch_service` | `elasticsearch` |
| `__opendistroforelasticsearch_java_home` | `""` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__opendistroforelasticsearch_user` | `elasticsearch` |
| `__opendistroforelasticsearch_group` | `elasticsearch` |
| `__opendistroforelasticsearch_log_dir` | `/var/log/elasticsearch` |
| `__opendistroforelasticsearch_db_dir` | `/var/db/elasticsearch` |
| `__opendistroforelasticsearch_package` | `textproc/opendistroforelasticsearch` |
| `__opendistroforelasticsearch_conf_dir` | `/usr/local/etc/elasticsearch` |
| `__opendistroforelasticsearch_scripts_dir` | `""` |
| `__opendistroforelasticsearch_plugins_dir` | `/usr/local/lib/elasticsearch/plugins` |
| `__opendistroforelasticsearch_plugin_command` | `/usr/local/lib/elasticsearch/bin/elasticsearch-plugin` |
| `__opendistroforelasticsearch_service` | `elasticsearch` |
| `__opendistroforelasticsearch_java_home` | `/usr/local` |

## RedHat

| Variable | Default |
|----------|---------|
| `__opendistroforelasticsearch_user` | `elasticsearch` |
| `__opendistroforelasticsearch_group` | `elasticsearch` |
| `__opendistroforelasticsearch_log_dir` | `/var/log/elasticsearch` |
| `__opendistroforelasticsearch_db_dir` | `/var/lib/elasticsearch` |
| `__opendistroforelasticsearch_package` | `opendistroforelasticsearch` |
| `__opendistroforelasticsearch_conf_dir` | `/etc/elasticsearch` |
| `__opendistroforelasticsearch_scripts_dir` | `""` |
| `__opendistroforelasticsearch_plugins_dir` | `/usr/share/elasticsearch/plugins` |
| `__opendistroforelasticsearch_plugin_command` | `/usr/share/elasticsearch/bin/elasticsearch-plugin` |
| `__opendistroforelasticsearch_service` | `elasticsearch` |
| `__opendistroforelasticsearch_java_home` | `""` |

# Dependencies

- `[trombik.x509_certificate](https://github.com/trombik/ansible-role-x509_certificate)`

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - role: trombik.freebsd_pkg_repo
      when: ansible_os_family == "FreeBSD"
    - role: trombik.apt_repo
      when: ansible_os_family == "Debian"
    - role: trombik.redhat_repo
      when: ansible_os_family == "RedHat"
    - role: trombik.java
    - role: trombik.sysctl
    - ansible-role-opendistroforelasticsearch
  vars:
    freebsd_pkg_repo:
      local:
        enabled: "true"
        url: http://192.168.1.105/packages/120amd64-trombik/
        mirror_type: none
        priority: 100
        state: present
    apt_repo_enable_apt_transport_https: yes
    apt_repo_to_add:
      - ppa:openjdk-r/ppa
      - deb [arch=amd64] https://d3g5vo6xdbdb9a.cloudfront.net/apt stable main
      - deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main
    apt_repo_keys_to_add:
      - https://artifacts.elastic.co/GPG-KEY-elasticsearch
      - https://d3g5vo6xdbdb9a.cloudfront.net/GPG-KEY-opendistroforelasticsearch
    redhat_repo:
      elasticsearch7:
        baseurl: https://artifacts.elastic.co/packages/oss-7.x/yum
        gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
        gpgcheck: yes
        enabled: yes
      opendistroforelasticsearch:
        baseurl: https://d3g5vo6xdbdb9a.cloudfront.net/yum/noarch/
        gpgkey: https://d3g5vo6xdbdb9a.cloudfront.net/GPG-KEY-opendistroforelasticsearch
        enabled: yes
        gpgcheck: yes
    os_opendistroforelasticsearch_extra_packages:
      FreeBSD: []
      Debian:
        # XXX install 7.3.2 becasue the current opendistroforelasticsearch
        # depends on 7.3.2, but the latest elasticsearch-oss is 7.5.1
        - elasticsearch-oss=7.3.2
      RedHat: []
    opendistroforelasticsearch_extra_packages: "{{ os_opendistroforelasticsearch_extra_packages[ansible_os_family] }}"
    os_java_packages:
      FreeBSD: []
      Debian:
        - openjdk-11-jdk
      RedHat:
        - java-11-openjdk-devel
    java_packages: "{{ os_java_packages[ansible_os_family] }}"
    os_sysctl:
      FreeBSD:
        kern.maxfilesperproc: 65536
        security.bsd.unprivileged_mlock: 1
      Debian: []
      RedHat: []
    sysctl: "{{ os_sysctl[ansible_os_family] }}"


    os_opendistroforelasticsearch_package:
      FreeBSD: "{{ __opendistroforelasticsearch_package }}"
      Debian: "{{ __opendistroforelasticsearch_package }}"
      RedHat: opendistroforelasticsearch-1.2.0-1
    opendistroforelasticsearch_package: "{{ os_opendistroforelasticsearch_package[ansible_os_family] }}"
    os_opendistroforelasticsearch_flags:
      FreeBSD: |
        elasticsearch_java_home={{ opendistroforelasticsearch_java_home }}
      Debian: |
        ES_PATH_CONF={{ opendistroforelasticsearch_conf_dir }}
        ES_STARTUP_SLEEP_TIME=5
        MAX_OPEN_FILES=65535
        MAX_LOCKED_MEMORY=unlimited
      RedHat: |
        ES_PATH_CONF={{ opendistroforelasticsearch_conf_dir }}
        ES_STARTUP_SLEEP_TIME=5
        MAX_OPEN_FILES=65535
        MAX_LOCKED_MEMORY=unlimited
    opendistroforelasticsearch_flags: "{{ os_opendistroforelasticsearch_flags[ansible_os_family] }}"
    opendistroforelasticsearch_jvm_options: |
      -Xms1024m
      -Xmx1024m
      -Xmx1g
      -XX:+UseConcMarkSweepGC
      -XX:CMSInitiatingOccupancyFraction=75
      -XX:+UseCMSInitiatingOccupancyOnly
      -Des.networkaddress.cache.ttl=60
      -Des.networkaddress.cache.negative.ttl=10
      -XX:+AlwaysPreTouch
      -Xss1m
      -Djava.awt.headless=true
      -Dfile.encoding=UTF-8
      -Djna.nosys=true
      -XX:-OmitStackTraceInFastThrow
      -Dio.netty.noUnsafe=true
      -Dio.netty.noKeySetOptimization=true
      -Dio.netty.recycler.maxCapacityPerThread=0
      -Dlog4j.shutdownHookEnabled=false
      -Dlog4j2.disable.jmx=true
      -Djava.io.tmpdir=${ES_TMPDIR}
      -XX:+HeapDumpOnOutOfMemoryError
      -XX:HeapDumpPath=data
      -XX:ErrorFile={{ opendistroforelasticsearch_log_dir }}/hs_err_pid%p.log
      -XX:+UseCompressedOops
    opendistroforelasticsearch_config:
      opendistro_security.disabled: true
      discovery.type: single-node
      network.publish_host: ["10.0.2.15"]
      path.data: "{{ opendistroforelasticsearch_db_dir }}"
      http.port: "{{ opendistroforelasticsearch_http_port }}"
      path.logs: "{{ opendistroforelasticsearch_log_dir }}"
      node.data: "true"
      http.compression: "true"
      network.host:
        - _local_
        - _site_
      cluster.name: testcluster
      node.name: testnode
      http.cors.enabled: "true"
      http.cors.allow-origin: "*"
      http.cors.max-age: 86400
      http.cors.allow-methods: "OPTIONS, HEAD, GET, POST, PUT, DELETE"
      http.cors.allow-headers: "X-Requested-With, Content-Type, Content-Length"
      http.cors.allow-credentials: "true"
      # _________________________TLS
      opendistro_security.ssl.transport.pemcert_filepath: node.pem
      opendistro_security.ssl.transport.pemkey_filepath: node-key.pem
      opendistro_security.ssl.transport.pemtrustedcas_filepath: root-ca.pem
      opendistro_security.ssl.transport.enforce_hostname_verification: false
      opendistro_security.ssl.http.enabled: true
      opendistro_security.ssl.http.pemcert_filepath: node.pem
      opendistro_security.ssl.http.pemkey_filepath: node-key.pem
      opendistro_security.ssl.http.pemtrustedcas_filepath: root-ca.pem
      opendistro_security.allow_default_init_securityindex: true
      opendistro_security.authcz.admin_dn:
        - CN=localhost,O=Internet Widgits Pty Ltd,ST=Some-State,C=AU
      opendistro_security.nodes_dn:
        - CN=localhost,O=Internet Widgits Pty Ltd,ST=Some-State,C=AU
      opendistro_security.audit.type: internal_elasticsearch
      opendistro_security.enable_snapshot_restore_privilege: true
      opendistro_security.check_snapshot_restore_write_privileges: true
      opendistro_security.restapi.roles_enabled: ["all_access", "security_rest_api_access"]
      cluster.routing.allocation.disk.threshold_enabled: false
      node.max_local_storage_nodes: 3
      opendistro_security.audit.config.disabled_rest_categories: NONE
      opendistro_security.audit.config.disabled_transport_categories: NONE
    project_opendistro_plugin_base_url: https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins

    # XXX see version matrix athttps://opendistro.github.io/for-elasticsearch-docs/docs/install/plugins/
    opendistroforelasticsearch_plugins:
      - name: opendistro_security
        src: "{{ project_opendistro_plugin_base_url }}/opendistro-security/opendistro_security-1.3.0.0.zip"
      - name: opendistro_alerting
        src: "{{ project_opendistro_plugin_base_url }}/opendistro-alerting/opendistro_alerting-1.3.0.1.zip"
    opendistroforelasticsearch_extra_plugin_files:
      - path: opendistro_security/securityconfig/roles.yml
        type: yaml
        content:
          _meta:
            type: roles
            config_version: 2
      - path: opendistro_security/securityconfig/roles_mapping.yml
        type: yaml
        content:
          _meta:
            type: rolesmapping
            config_version: 2
      - path: opendistro_security/securityconfig/internal_users.yml
        type: yaml
        content:
          _meta:
            type: "internalusers"
            config_version: 2
          new-user:
            # XXX the hash is created by tools/hash.sh
            hash: "$2y$12$88IFVl6IfIwCFh5aQYfOmuXVL9j2hz/GusQb35o.4sdTDAEMTOD.K"
            reserved: false
            hidden: false
            backend_roles:
              - "some-backend-role"
            attributes:
              attribute1: "value1"
            static: false
          admin:
            hash: "$2y$12$88IFVl6IfIwCFh5aQYfOmuXVL9j2hz/GusQb35o.4sdTDAEMTOD.K"
            reserved: true
            backend_roles:
              - admin
            description: "Demo admin user"
      - path: opendistro_security/securityconfig/config.yml
        type: yaml
        content:
          http_authenticator:
            type: basic
            challenge: true
    x509_certificate_debug_log: yes
    # XXX these keys were create by following the steps described at:
    # https://opendistro.github.io/for-elasticsearch-docs/docs/security-configuration/generate-certificates/
    #
    # here is the copy of the steps:
    #
    # Root CA
    # openssl genrsa -out root-ca-key.pem 2048
    # openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem
    #
    # Admin cert
    # openssl genrsa -out admin-key-temp.pem 2048
    # openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem
    # openssl req -new -key admin-key.pem -out admin.csr
    # openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem
    #
    # Node cert
    # openssl genrsa -out node-key-temp.pem 204
    # openssl pkcs8 -inform PEM -outform PEM -in node-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out node-key.pem
    # openssl req -new -key node-key.pem -out node.csr
    # openssl x509 -req -in node.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out node.pem
    #
    # Cleanup
    # rm admin-key-temp.pem admin.csr node-key-temp.pem node.csr
    x509_certificate:
      - name: node
        state: present
        public:
          path: "{{ opendistroforelasticsearch_conf_dir }}/node.pem"
          mode: "0444"
          key: |
            -----BEGIN CERTIFICATE-----
            MIIDMzCCAhsCCQDFJMQePWLjHzANBgkqhkiG9w0BAQsFADBeMQswCQYDVQQGEwJB
            VTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0
            cyBQdHkgTHRkMRcwFQYDVQQDDA5jYS5leG1hcGxlLm9yZzAeFw0xOTEwMTAwMjMx
            MThaFw0xOTExMDkwMjMxMThaMFkxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21l
            LVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQxEjAQBgNV
            BAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKbc
            g+Wu9h+zSQDcY59exw2SYcoKCyjjICxU7dyV2UWDuwHMrp0hPKE6Ihd41ftgWVOl
            fIra3I0gmGteWztlaEP3wx0tnZdopBJgMegiPjmUcz/w3wqtzgSqH3fTKbQhO4qL
            jDnwJfOxpoUWdR69DXPFLTi5HrD1/GwmT3ra6ySJGVRKKGnl9ZukwnEqQs58e/+T
            GCwnGOjkItwE5kxEtPSNRqsm+zfJyy6hwoeCGHyqxwiRTwSNjRdL+rQjGzGPj/OU
            VDDuXV389+EmKYbTfH790VRULNsT22VjFCwW1yAsmJTFKVktjcGjdcH2iGtLN7CO
            QVLNR9QIl+x2+9XXSxUCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAnZEGtf28tpzy
            36hGJJxLHqewb7xRnoXnm5d5f3x1vTlmtU/Y3NZg4eqV8fBJr6Z9IpgAe4Mzmzna
            4j4jcUHraKrat/UKxiCqqP+P3FggRhUz5c4aC/pCOF3MRzD4Q9hZHV3gLoZMzerv
            eza1HuWnaRg2hAIBOlb9Oyn7K4LgMdH3Un4L2tH3eyp0KsMQj/JAW0iZFtVuohzu
            R7jSBWvYE3+siM2mpHUw6sf5uevgPTyEZg3ionLsGg0M6XdpvgT61m/pE3+7xjQ1
            I9Eg8TdwRq5gAv0Ywl5BuXyIA40x7x87y4qPpqMpBsc8u7ESlffUs2mor0qfQvm7
            mzd3/gNRFw==
            -----END CERTIFICATE-----
        secret:
          path: "{{ opendistroforelasticsearch_conf_dir }}/node-key.pem"
          owner: "{{ opendistroforelasticsearch_user }}"
          group: "{{ opendistroforelasticsearch_group }}"
          mode: "0600"
          key: |
            -----BEGIN PRIVATE KEY-----
            MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCm3IPlrvYfs0kA
            3GOfXscNkmHKCgso4yAsVO3cldlFg7sBzK6dITyhOiIXeNX7YFlTpXyK2tyNIJhr
            Xls7ZWhD98MdLZ2XaKQSYDHoIj45lHM/8N8Krc4Eqh930ym0ITuKi4w58CXzsaaF
            FnUevQ1zxS04uR6w9fxsJk962uskiRlUSihp5fWbpMJxKkLOfHv/kxgsJxjo5CLc
            BOZMRLT0jUarJvs3ycsuocKHghh8qscIkU8EjY0XS/q0Ixsxj4/zlFQw7l1d/Pfh
            JimG03x+/dFUVCzbE9tlYxQsFtcgLJiUxSlZLY3Bo3XB9ohrSzewjkFSzUfUCJfs
            dvvV10sVAgMBAAECggEAHG83isxl5MEIj7z+vQnJoeZwA53yiOUrdmKCpjRi8hWg
            qI3Ys64WRuNBK/7LeCrTDg4FSyRAsUv8rU9G/LgrLGnsNeywDj0muHrsBkLPl8BU
            Y3EIkSlNEj5rXl/9m1SOcO2W18i0rvJ3Dfblvnc486GGM0RYlo9UlJlysdzcdT0h
            ORjgSzREH2J6S6PB5T/waxZ6XGopy3qkF2Q+Bs7K+Rx1uIrztsPMfJ5YcdPTNEiD
            YDNwWCI5FGI1Wq/5YtpkYlkZx/z+CcAX5njoQKyyZdOJVzUwVRxdEtOPALOYnB8x
            pUmxugKbE8d2pAYbV513dG6r+BXGyA4QptvyGxWXgQKBgQDVqYL1u+DrbSDYCBjd
            s379CD64+vtBe6Yfq6QDQS9XGAtTyYcAj+9oUzTew63vOlgfSZ/xVKcOq4Re88mn
            +KIkl1DA7+O/l8os38lrzDgbZO8vLE+VFpS+TbUegkOFRFpldActyLV6JuyfO58D
            PsDO+xxtw4lneIlCIM9MOiqXbwKBgQDH7O456+XhYy2BMV1fB+BkTnX9M0SjlXwB
            Tv7WUfEEMLFJsHae7P+4q396gBAx4CD3gBH+zBULeRdW3wkJKc22QS5kSJaU0T59
            1bL1n7hIeIu36m+Due+o2PLeda+Hx3hk56JQkXhTpDEZAx2WGOZ81lATOKtUTdDs
            bAISGyGjuwKBgDb2m0zRnwORGCDavGLT2PgIlfIKBnaK82o0QkXgD+iMs+VC82qu
            nDyvIuunVOg0jxTFYNK5HxyD/NJcTmTabgORtWFclK7lwkmW6/7CEzDg3zK4aGSG
            4Y6u+Me3ZN00fziYB3y8pAqfVsGDmd1A2GKmcGLAKWmntU+AlzMZx3kbAoGBAIui
            Sry/qv4hc+3Q2aL+8FV+i1/+B8mtJUAQuWJdNtWzYI/UJPVZGD4V4eJgQW9kWAIl
            O+xXA7fQqmFtQ3VX8iqCGfHG1Q05m8jtkaGGHYLYVtVscthw7Bdk9zQyxBc0VT08
            nxxgjcb1XalXiLmFyK2WTbUvFlK6StplkYit1G/zAoGAYdYiIZmixKsrtdH/CKQY
            kGBqJY9H+3QQB9fckHROtdOalWrJJCUBF+jEa2e6rLbFSpzj2Dpot2QLiENBMZuH
            6DAksJ9+B3lxbQxdssFaFa5NocS2v6oAyLbEGNIOEkQ54f0v5HfaPVeLElK4Hs18
            f5MIWEE6V+z+aNg7aXdrLtU=
            -----END PRIVATE KEY-----
      - name: root-ca
        state: present
        public:
          path: "{{ opendistroforelasticsearch_conf_dir }}/root-ca.pem"
          key: |
            -----BEGIN CERTIFICATE-----
            MIIDMzCCAhsCCQDFJMQePWLjHzANBgkqhkiG9w0BAQsFADBeMQswCQYDVQQGEwJB
            VTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0
            cyBQdHkgTHRkMRcwFQYDVQQDDA5jYS5leG1hcGxlLm9yZzAeFw0xOTEwMTAwMjMx
            MThaFw0xOTExMDkwMjMxMThaMFkxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21l
            LVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQxEjAQBgNV
            BAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKbc
            g+Wu9h+zSQDcY59exw2SYcoKCyjjICxU7dyV2UWDuwHMrp0hPKE6Ihd41ftgWVOl
            fIra3I0gmGteWztlaEP3wx0tnZdopBJgMegiPjmUcz/w3wqtzgSqH3fTKbQhO4qL
            jDnwJfOxpoUWdR69DXPFLTi5HrD1/GwmT3ra6ySJGVRKKGnl9ZukwnEqQs58e/+T
            GCwnGOjkItwE5kxEtPSNRqsm+zfJyy6hwoeCGHyqxwiRTwSNjRdL+rQjGzGPj/OU
            VDDuXV389+EmKYbTfH790VRULNsT22VjFCwW1yAsmJTFKVktjcGjdcH2iGtLN7CO
            QVLNR9QIl+x2+9XXSxUCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAnZEGtf28tpzy
            36hGJJxLHqewb7xRnoXnm5d5f3x1vTlmtU/Y3NZg4eqV8fBJr6Z9IpgAe4Mzmzna
            4j4jcUHraKrat/UKxiCqqP+P3FggRhUz5c4aC/pCOF3MRzD4Q9hZHV3gLoZMzerv
            eza1HuWnaRg2hAIBOlb9Oyn7K4LgMdH3Un4L2tH3eyp0KsMQj/JAW0iZFtVuohzu
            R7jSBWvYE3+siM2mpHUw6sf5uevgPTyEZg3ionLsGg0M6XdpvgT61m/pE3+7xjQ1
            I9Eg8TdwRq5gAv0Ywl5BuXyIA40x7x87y4qPpqMpBsc8u7ESlffUs2mor0qfQvm7
            mzd3/gNRFw==
            -----END CERTIFICATE-----
        secret:
          path: "{{ opendistroforelasticsearch_conf_dir }}/root-ca-key.pem"
          owner: "{{ opendistroforelasticsearch_user }}"
          group: "{{ opendistroforelasticsearch_group }}"
          key: |
            -----BEGIN RSA PRIVATE KEY-----
            MIIEowIBAAKCAQEA2vu3zNFLi5s3afKZsjj4WYTqOyQeu7ajCSOVFWu3/rGUQCxY
            whaN8sZWJ4Tb3giSgFt9daxIAjFT0RNZm9HI9+hthlyQ6EmVtmHv8QOIjWTrIT1S
            9pZuyHsWcnin2FMX/UM1VxJSZQ3lsKhzbqBlGqmRuWbYi4hqsRxAnDuU78frvqDC
            gzFgjIEnDZMJeooM+ZLUrXuIIPi+auEl/7n8u3C/anLtt+K5UMCvZrCUSwSycPx2
            qFdPGpDXedlsfkxzW+mk3s38dHOG/5+qxwZiIexTgRYBRmoASZe5ksSVxKjvEWfF
            Zv1WoOMivEDwXmgbxojXc1hWfKAT6ArgitTyrQIDAQABAoIBAQDQjgtutaYNP7Z2
            4OYgJsHgAAZUbQIYJMkBWzIRRJXnq5hVxeaCcpieLua+nHoJ7IAaXwgNmha6f+Aj
            rxoYnKOZ93LYFDCuCebb3Ep4b7UNdJ+6+Hya/IplxVSLkP3JuNmQCwIx+vEd7S5k
            IQpOwdOIoRZ4TMrPmQyDwTSHlvcxpKJxVZ0XGSAg9jzqhFpmbn28/GUr8iQD2Mo0
            U9N6ToddHyDpll0eJouoXesIbvxwyFI0vdHki5fl6LmazKzKjGtr8yD8QqP5D403
            JdzSNqwElQd7QKpvMPaL1dXpdUUiF+9TUXjt8A1MBtVsSmXMwMiqOfuzPjAj7wkc
            smfTxjABAoGBAPJ8wjWzZV1QDxzYRYMRCuVSuJrLn4jA8jEEf3X5ej3SMyaVaBOJ
            YtSuoV4C66jtgHRiQTcUIewiZAurmemeR/VRsW2RPC/w2SYZRytKKm8l5YM2iXSK
            /VgWTdVSbOhzJYfV0Azp47pY2yW3WZop3lnzcXPM/jthI6NnX4KcdI9BAoGBAOcv
            qIw8DSXYJUStIJ4wf5jfP2jmjeepA0d007XfZCkLE3ltlrxN2llAf/fq+sbhEtTf
            vpFnEcRqSvw4y8jd0G2IrvFZoSdr1SbtF6UfdixcB9Br2kqElNxzSX2eNHFOxOPw
            L+snKT+i1pFAXCOlMBedqZNetyWqBnWSvARUKvRtAoGAQoLl4kTqsMWc35SSvHiY
            PH6MFCl2ANSrmbZaH8nmNb7KOPMSMQmmCiA8MsUqTpOWgFXS/YCQLWzhdDIFbYb0
            xd06hYsorx2o8kJMuxsEuKf0ZCE5YrYc92RmxPRu2vN6f9+tyVz+Ecb9lULNWPPT
            AWk83T6FHVRvqgpYsEKp1gECgYBZ6R8T6wbyAO39l5dn7lSxj6GJmqD1x7WOxNDR
            mt/JVpVsVEKbWWvh6kPal3iQgFhikeH7iqpOSUiAb1ZR+HJnJxFirAkQ2886JFtd
            zK6Y8fHYDRoIgSej1PJv+GdM6eWJAJCiU8inBx2LwAwVkNjzVk3tEpkH/OgmMbsN
            s+5AwQKBgDXibuSSsisvdIN9hsSdCm2TBAx2yiVS/Jm64lVjr+PJpswTG0OY9YLO
            vN7YiVwEifmpgjwYqwbygU47h3OH22fn+A04geI5XPQJytWOgVfzh2oBWoHcFApi
            zrAM2P/g2Lnw/ttxnFUHpLe+f2uq+PTgidDl58R2tbt8kTO5QpGG
            -----END RSA PRIVATE KEY-----
      - name: admin
        state: present
        public:
          path: "{{ opendistroforelasticsearch_conf_dir }}/admin.pem"
          key: |
            -----BEGIN CERTIFICATE-----
            MIIDMzCCAhsCCQDFJMQePWLjHjANBgkqhkiG9w0BAQsFADBeMQswCQYDVQQGEwJB
            VTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0
            cyBQdHkgTHRkMRcwFQYDVQQDDA5jYS5leG1hcGxlLm9yZzAeFw0xOTEwMTAwMjI2
            MDlaFw0xOTExMDkwMjI2MDlaMFkxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21l
            LVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQxEjAQBgNV
            BAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsB
            G8zk8zYLb7KswWprNaAVBnGyNkbBa3eWH3NjsP6TIiSQWii80aSPk4OxI2juLvqX
            BACS3sqAd0qW1HUuFfYqOMW4zCPyxPiBBY+3qZP3VlmDWhVZeRnH9RuEuvp24+TX
            uRv8efri2I3BbKlRObaGwYuwz/S7mCZJX+QkLgOwnkZtjkkoMHQ80UF1C98iroUB
            qASfVOYtNSWZXj3WsR07qI8Juas2ebenMeRMizZIq2M/APJbawZhw1THOUJpL4Jx
            sPr/cJkL3n5HU3S7KLaeePItxmWC1oYq452CDytGFAQoL1U8J2JpJ4XJrqPhiEec
            3JvWD53p8ViSjoNVXkECAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAUfCvEv7D9j+7
            heOYop/OsY6hFHaPIaeYeHnDkZUGcS+9THjYjoZwML0HzsNbunmE9xw6nj6Fp9lh
            Zz+ds93JU4uthIcR5FJrvGJr3cCgkx0CyTMaVMZ3aUYszuWWv/ztF0KbeX5g0OmY
            MDhfH0QLh7crp4vymPuxgzECiyTizuOfb41FaIx32ks3fEUNe6DhGPyjeXjB8AEW
            noZYNT2Iys06qjpIiPa3yKrk38wALRsnY5eJw844YOmTZodlx+rrjCqkwzsPAO52
            quywFajsDuy+FwnxJSibPCgbRqJfOYmCKsWJrPc9LyvEEy9l+1yxFNp2z1Zy7iUe
            qcmtZpbkfg==
            -----END CERTIFICATE-----
        secret:
          path: "{{ opendistroforelasticsearch_conf_dir }}/admin-key.pem"
          owner: "{{ opendistroforelasticsearch_user }}"
          group: "{{ opendistroforelasticsearch_group }}"
          key: |
            -----BEGIN PRIVATE KEY-----
            MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDLARvM5PM2C2+y
            rMFqazWgFQZxsjZGwWt3lh9zY7D+kyIkkFoovNGkj5ODsSNo7i76lwQAkt7KgHdK
            ltR1LhX2KjjFuMwj8sT4gQWPt6mT91ZZg1oVWXkZx/UbhLr6duPk17kb/Hn64tiN
            wWypUTm2hsGLsM/0u5gmSV/kJC4DsJ5GbY5JKDB0PNFBdQvfIq6FAagEn1TmLTUl
            mV491rEdO6iPCbmrNnm3pzHkTIs2SKtjPwDyW2sGYcNUxzlCaS+CcbD6/3CZC95+
            R1N0uyi2nnjyLcZlgtaGKuOdgg8rRhQEKC9VPCdiaSeFya6j4YhHnNyb1g+d6fFY
            ko6DVV5BAgMBAAECggEAJYuh8aZSmSdKVFiBOUZ015Or6nFUeoehca+xR20juiHK
            Scrs8eXiPDZVySCE9Q5AYBZ4JgcD754M8h2tU7LfWvT6JQ+Fqgxng7KRLcCBO52e
            OdYCXjp7HFqQKbPFxTch9Rw030k14kH8XVNt3m7oZqrLtyNPgusDO+mMM6zBWesG
            yhEtrzXFF+mskOLl7xp/0n/WDO7hsz3PZkEx/hGyNpxHikE+or13lRtSogeZEybv
            4Y1hhKcZwsVQOtsoSG7fcBwk4F0hJlesOO1M9UPCE8kUjs97oJfLQukuWqap+T4r
            USECJsVwcsjsruqhr+UQmvDp22PqRGRh6kuZbZwh5QKBgQD8GuWOMAC8R19DPgc3
            ggfQz97uYwBb2cw/xwCCHVjhF/WQfgPg7g7MNsVr256imZuzsjQIQJEX8tmBgdb1
            p9Ebs8C+L8xeIfsi7GqlPOaHm80q8sF1SpeQZ36+23SthHN1JT6pLMl8D8WscBZo
            Kt5NlzpcNCtQ8aqqV/FXyPPp3wKBgQDOJANZPTfWOQO68hm7Zj2sihQTvFb1yxBU
            F89ol8kvajKYw0Mef/IsTEtRS08pE6AVWvjJC9Wi5JSBxdtaGxDje/4fXj1Ili3u
            I/DKIJVCz9uq4y8vaqO4npw7/nTGCeqfZHh19pzMuwHxPEfSvjqzr/5fyecSYzL/
            +0EZz1H73wKBgA89qQcRi9nWDsJH67PFXqeXCYkr3weugRSR+Uvkbk0dX7EejSl5
            +tcJsKG2oz59PtZ8PX0KOjtSaSfVK6OqQ5ADK/HTfe1q7H3OARyANAeauaqRBnUK
            z2Lhft4W8lTTHw/D8qfTl1KyuWaVWCVwAgR60gJk/QFlusWVj3eZJHXNAoGAHFiv
            bTIR349vh+GK0E465OMH577aZmpKEIZFqyhULgT4eDFBpYwKjTTglok4lXlxZf5g
            f6T097VfBolipH1cUSvXwhB/dN/R6RFgJytb2xgiKNmcv3R2lwiYi1duT11Fui1i
            szX6UdzVY4rahYxLHjJxVFK7R7gEZ1bxmM79gxkCgYBfeU0SNr9oUL8Rw7pf1pe6
            H5f1zyPDIKWhzU6aaIdGKr5wUIcQT0/Z75O/JBxXeq3bBkH/eZU/giUE33kpVPsv
            fx/baNmdyVXvHEn9dQd7i/0LUXF1QgJoreYDz9QV4gYzDOtyWiA/XR+snNsTBH7R
            0YX6LjQg646+IyFoK6qw+w==
            -----END PRIVATE KEY-----
```

# License

```
Copyright (c) 2019 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
