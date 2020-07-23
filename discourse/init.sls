{%- from "discourse/map.jinja" import config with context %}
{%- set docker_images = config['images'] %}

discourse-net:
  docker_network.present:
  - driver: bridge

{%- for key, image in docker_images.items() %}

{%- set dker_image = image | traverse('image') %}
{%- set command = image | traverse('command') %}
{%- set ports = image | traverse('ports') %}
{%- set env = image | traverse('env') %}
{%- set binds = image | traverse('binds') %}
#
# container for {{ key }}
#
{{ key }}:
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
{%- endfor %}