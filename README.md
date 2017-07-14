# ansible-role-sensu-plugins-bundle

Install bundled `sensu` plug-ins from SCM repository. Plug-ins are cloned and
installed using `bundler`.

Currently supported SCM:

* `git`

## Running installed checks

As the plug-ins are bundled by `bundler`, installed checks must be executed by
a wrapper, `bundled_check`, which is installed under `plugins` directory.

The wrapper takes at least two arguments; repository name and check command.

```sh
bundled_check plugin_name check_command
```

Remaining arguments, if any, are passed to the check command.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `sensu_plugins_bundle_user` | owner of `sensu_plugins_bundle_bundled_plugins_dir` and the user to run `bundle` | `{{ __sensu_plugins_bundle_user }}` |
| `sensu_plugins_bundle_group` | group of `sensu_plugins_bundle_user` | `{{ __sensu_plugins_bundle_group }}` |
| `sensu_plugins_bundle_sensu_dir` | path to `sensu` configuration directory | `{{ __sensu_plugins_bundle_sensu_dir }}` |
| `sensu_plugins_bundle_bundled_plugins_dir` | path to the directory where plug-ins are kept | `{{ sensu_plugins_bundle_sensu_dir }}/bundled_plugins` |
| `sensu_plugins_bundle_plugins_dir` | path to `sensu` `plugins` directory | `{{ sensu_plugins_bundle_sensu_dir }}/plugins` |
| `sensu_plugins_bundle_list` | list of plug-ins to manage (see below) | `[]` |

## `sensu_plugins_bundle_list`

This variable is a list of dict. Keys and values are described below.

| Key | Value | Mandatory? |
|-----|-------|------------|
| `repo` | path to the plug-in's repository | yes |
| `version` | version of the plug-in | no |
| `state` | either `present` or `absent` | yes |

An example:

```yaml
sensu_plugins_bundle_list:
  - repo: https://github.com/sensu-plugins/sensu-plugins-load-checks.git
    version: 2.0.0
    state: present
```

## FreeBSD

| Variable | Default |
|----------|---------|
| `__sensu_plugins_bundle_user` | `sensu` |
| `__sensu_plugins_bundle_group` | `sensu` |
| `__sensu_plugins_bundle_sensu_dir` | `/usr/local/etc/sensu` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - name: reallyenglish.freebsd-repos
      when: ansible_os_family == 'FreeBSD'
    - name: reallyenglish.sensu-client
    - name: ansible-role-sensu-plugins-bundle
  vars:
    freebsd_repos:
      sensu:
        enabled: "true"
        url: https://sensu.global.ssl.fastly.net/freebsd/FreeBSD:10:amd64/
        mirror_type: srv
        signature_type: none
        priority: 100
        state: present
    sensu_client_gem_binary: "{% if ansible_os_family == 'OpenBSD' %}gem{% else %}/opt/sensu/embedded/bin/gem{% endif %}"
    sensu_plugins_bundle_list:
      - repo: https://github.com/sensu-plugins/sensu-plugins-load-checks.git
        version: 2.0.0
        state: present
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

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

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
