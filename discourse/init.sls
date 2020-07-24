{%- from "discourse/map.jinja" import config with context %}
{%- set docker_images = config['images'] %}

/opt/bitnami/discourse/conf/site_settings.yml:
  file.managed:
  - source:  salt://etcd/files/site_settings.yml.jinja
  - context:
      config: {{ config | json }}

discourse-net:
  docker_network.present:
  - driver: bridge

{%- for key, image in docker_images.items() %}

{%- set container_state = image | traverse('state', 'running') %}
{%- set dker_image = image | traverse('image') %}
{%- set command = image | traverse('command') %}
{%- set ports = image | traverse('ports') %}
{%- set env = image | traverse('env') %}
{%- set binds = image | traverse('binds') %}
#
# container for {{ key }}
#
{{ key }}:
  {%- if container_state == 'absent' %}
  docker_container.absent
  {%- endif %}

  {%- if container_state == 'running' %}
  docker_container.running:
    # Image
    - image: {{ dker_image }}

    # Custom Command
    {%- if command %}
    - command: {{ command }}
    {%- endif %}

    # Ports
    {%- if ports %}
    - port_bindings:
      {%- for port in ports %}
      - {{ port }}
      {%- endfor %}
    {%- endif %}

    # Environment Vars
    {%- if env %}
    - environment:
      {%- for key, value in env.items() %}
      - {{ key }}={{ value }}
      {%- endfor %}
    {%- endif %}

    # Volume Bindings
    {%- if binds %}
    - binds:
      {%- for bind in binds %}
      - {{ bind }}
      {%- endfor %}
    {%- endif %}

    - networks:
      - discourse-net

    - require:
      - docker_network: discourse-net
  {%- endif %}
{%- endfor %}