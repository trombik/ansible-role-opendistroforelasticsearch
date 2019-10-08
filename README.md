# `trombik.opendistroforelasticsearch`

`ansible` role to manage `opendistroforelasticsearch`.

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
| `__opendistroforelasticsearch_jvm_options_dir` | `/usr/local/etc` |
| `__opendistroforelasticsearch_java_home` | `/usr/local` |

# Dependencies

None

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - role: trombik.freebsd_pkg_repo
      when: ansible_os_family == "FreeBSD"
    - role: trombik.sysctl
    - ansible-role-opendistroforelasticsearch
  vars:
    freebsd_pkg_repo:
      local:
        enabled: "true"
        url: http://192.168.43.75/packages/12_0-trombik/
        mirror_type: none
        priority: 100
        state: present
    os_sysctl:
      FreeBSD:
        kern.maxfilesperproc: 65536
        security.bsd.unprivileged_mlock: 1
    sysctl: "{{ os_sysctl[ansible_os_family] }}"
    opendistroforelasticsearch_flags: |
      elasticsearch_java_home='{{ opendistroforelasticsearch_java_home }}'
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
      -XX:ErrorFile=logs/hs_err_pid%p.log
      -XX:+UseCompressedOops
      8:-XX:+PrintGCDetails
      8:-XX:+PrintGCDateStamps
      8:-XX:+PrintTenuringDistribution
      8:-XX:+PrintGCApplicationStoppedTime
      8:-Xloggc:${ES_TMPDIR}/gc.log
      8:-XX:+UseGCLogFileRotation
      8:-XX:NumberOfGCLogFiles=32
      8:-XX:GCLogFileSize=64m
      9-:-Xlog:gc*,gc+age=trace,safepoint:file=logs/gc.log:utctime,pid,tags:filecount=32,filesize=64m
      9-:-Djava.locale.providers=COMPAT
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
    opendistroforelasticsearch_plugins:
      - name: opendistro_security
        src: https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-security/opendistro_security-1.2.0.0.zip
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
