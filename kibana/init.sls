{%- from 'kibana/map.jinja' import kibana with context %}
{%- set repo = kibana.repository %}

kibana-repository:
  pkgrepo.managed:
    - humanname: {{ repo.title }}
    - name: {{ repo.url }}
    - file: {{ repo.file }}
    - key_url: {{ repo.key_url }}

kibana-package:
  pkg.latest:
    - name: {{ kibana.package }}
    - require:
      - pkgrepo: kibana-repository

kibana-config:
  file.managed:
    - name: {{ kibana.config_file }}
    - mode: 664
    - user: root
    - group: root
    - source: salt://kibana/files/kibana.yml.jinja
    - template: jinja
    - makedirs: True
    - require:
      - pkg: kibana-package
    - defaults:
      config: {{ kibana.config }}

kibana-service:
  service.running:
    - name: {{ kibana.service }}
    - enable: true
    - watch:
      - file: kibana-config

