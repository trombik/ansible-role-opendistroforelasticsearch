# ansible-role-opendistroforelasticsearch

A brief description of the role goes here.

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
| `opendistroforelasticsearch_extra_files` | | `[]` |


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
