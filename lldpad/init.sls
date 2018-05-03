{% from "lldpad/map.jinja" import lldpad_settings with context %}

lldpad:
  pkg.installed:
    - pkgs: {{ lldpad_settings.lookup.packages }}
{% if lldpad_settings.fix_selinux == True %}
  cmd.run:
    - name: 'semanage permissive -a lldpad_t'
    - unless: 'semanage permissive -l | grep lldpad_t'
{% endif %}
  service.running:
    - name: {{ lldpad_settings.lookup.service }}
    - enable: True
    - require:
      - pkg: lldpad
{% if lldpad_settings.fix_selinux == True %}
      - cmd: lldpad
{% endif %}
    - watch:
      - pkg: lldpad
{% if lldpad_settings.fix_selinux == True %}
      - cmd: lldpad
{% endif %}

{% if lldpad_settings.config.interface_source == 'auto' %}

{% if lldpad_settings.config.defaults.adminStatus != '' %}
lldp_default_adminStatus:
  cmd.run:
    - name: "for i in `ls /sys/class/net/ | grep -e eth -e eno -e ens` ; do lldptool set-lldp -i $i adminStatus={{ lldpad_settings.config.defaults.adminStatus }} ; done"
    - require:
      - service: lldpad
{% endif %}

{% if lldpad_settings.config.defaults.sysNameTx != '' %}
lldp_default_sysNameTx:
  cmd.run:
    - name: "for i in `ls /sys/class/net/ | grep -e eth -e eno -e ens` ; do lldptool -T -i $i -V  sysName enableTx={{ lldpad_settings.config.defaults.sysNameTx }} ; done"
    - require:
      - service: lldpad
{% endif %}

{% if lldpad_settings.config.defaults.portDescTx != '' %}
lldp_default_portDescTx:
  cmd.run:
    - name: "for i in `ls /sys/class/net/ | grep -e eth -e eno -e ens` ; do lldptool -T -i $i -V  portDesc enableTx={{ lldpad_settings.config.defaults.portDescTx }} ; done"
    - require:
      - service: lldpad
{% endif %}

{% if lldpad_settings.config.defaults.sysDescTx != '' %}
lldp_default_sysDescTx:
  cmd.run:
    - name: "for i in `ls /sys/class/net/ | grep -e eth -e eno -e ens` ; do lldptool -T -i $i -V  sysDesc enableTx={{ lldpad_settings.config.defaults.sysDescTx }} ; done"
    - require:
      - service: lldpad
{% endif %}

{% if lldpad_settings.config.defaults.sysCapTx != '' %}
lldp_default_sysCapTx:
  cmd.run:
    - name: "for i in `ls /sys/class/net/ | grep -e eth -e eno -e ens` ; do lldptool -T -i $i -V sysCap enableTx={{ lldpad_settings.config.defaults.sysCapTx }} ; done"
    - require:
      - service: lldpad
{% endif %}

{% if lldpad_settings.config.defaults.mngAddrTx != '' %}
lldp_default_mngAddrTx:
  cmd.run:
    - name: "for i in `ls /sys/class/net/ | grep -e eth -e eno -e ens` ; do lldptool -T -i $i -V mngAddr enableTx={{ lldpad_settings.config.defaults.mngAddrTx }} ; done"
    - require:
      - service: lldpad
{% endif %}

{% else %}
{# only add/configure interface parameters from pillar config #}
{% if 'interfaces' in lldpad_settings.config %}
{% for interface_name, interface_options in lldpad_settings.config.interfaces.items() %}
{% for option_name, option_value in interface_options %}
{% if option_name == 'adminStatus' %}
{{ interface_name }}_adminStatus:
  cmd.run:
    - name: 'lldptool set-lldp -i {{ interface_name }} adminStatus={{ option_value }}'
    - require:
      - service: lldpad
{% else %}
{{ interface_name }}_{{ option_name }}_Tx:
  cmd.run:
    - name: 'lldptool -T -i {{ interface_name }} -V {{ option_name }} enableTx={{ option_value }}'
    - require:
      - service: lldpad
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
{% endif %}
