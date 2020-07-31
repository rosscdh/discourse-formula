{%- from "discourse/map.jinja" import config with context %}
{%- set docker_images = config['images'] %}
{%- set host_path = config['host_path'] %}

create_discourse_source_dirs:
  file.directory:
    - mode: 755
    - makedirs: True
    - names:
      - {{ host_path }}
      - {{ host_path }}/postgresql/data
      - {{ host_path }}/generated/nginx/cache
      - {{ host_path }}/generated/public/assets
      - {{ host_path }}/generated/public/images
      - {{ host_path }}/generated/public/uploads
      - {{ host_path }}/generated/public/javascripts

{{ host_path }}/config/entrypoint.sh:
  file.managed:
  - source:  salt://discourse/files/entrypoint.sh
  - template: jinja
  - mode: 755
  - makedirs: True

{{ host_path }}/config/application.rb:
  file.managed:
  - source:  salt://discourse/files/application.rb
  - template: jinja
  - mode: 755
  - makedirs: True

{{ host_path }}/config/unicorn.rb:
  file.managed:
  - source:  salt://discourse/files/unicorn.rb
  - template: jinja
  - mode: 755
  - makedirs: True

{{ host_path }}/config/nginx.application.conf:
  file.managed:
  - source:  salt://discourse/files/nginx.application.conf
  - template: jinja
  - mode: 755
  - makedirs: True

{{ host_path }}/envs/production.rb:
  file.managed:
  - source:  salt://discourse/files/envs/production.rb
  - template: jinja
  - mode: 755
  - makedirs: True

{{ host_path }}/overrides/routes.rb:
  file.managed:
  - source:  salt://discourse/files/overrides/routes.rb
  - template: jinja
  - mode: 755
  - makedirs: True

{{ host_path }}/postgresql/data:
  file.directory:
    - mode: 755
    - makedirs: True

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