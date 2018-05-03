lldpad:
  lookup:
    service: lldpad
  config:
    interface_source: auto
    defaults:
      adminStatus: rxtx
      sysNameTx: 'yes'
      portDescTx: 'yes'
      sysDescTx: 'no'
      sysCapTx: 'no'
      mngAddrTx: 'no'

lldpad:
  lookup:
    service: lldpad
  fix_selinux: True
  config:
    interface_source: list
    interfaces:
      ens32:
        adminStatus: rxtx
        sysName: 'yes'
        portDesc: 'yes'
        sysDesc: 'yes'
        sysCap: 'yes'
        mngAddr: 'yes'
