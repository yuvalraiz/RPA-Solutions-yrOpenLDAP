namespace: YuvalRaiz.ldap
flow:
  name: ldap_create_user
  inputs:
    - host
    - port: '22'
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - private_key_data:
        required: false
    - ldap_uri
    - ldap_admin_password:
        sensitive: true
    - ldap_admin_dn
    - uid
    - ou_path
    - base_dn
    - calc_dn:
        default: "${'uid='+uid+','+ou_path+','+base_dn}"
        private: true
        required: false
    - fullname
    - firstname
    - email
    - lastname
    - user_password:
        sensitive: true
    - uid_number
    - LDIF:
        default: |-
          ${'''version: 1
          dn: {calc_dn}
          changetype: add
          cn: {fullname}
          displayname: {fullname}
          gidnumber: 0
          givenname: {firstname}
          homedirectory: /
          mail: {email}
          objectclass: posixAccount
          objectclass: top
          objectclass: inetOrgPerson
          sn: {sn}
          uid: {uid}
          uidnumber: {uid_number}
          userpassword: {user_password}'''.format(calc_dn=calc_dn,fullname=fullname,firstname=firstname,email=email,sn=lastname,uid=uid,uid_number=uid_number,user_password=user_password)}
        private: true
  workflow:
    - _ldapmodify:
        do:
          YuvalRaiz.ldap._ldapmodify:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - private_key_data: '${private_key_data}'
            - ldap_uri: '${ldap_uri}'
            - ldap_admin_password: '${ldap_admin_password}'
            - ldap_admin_dn: '${ldap_admin_dn}'
            - LDIF: '${LDIF}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - return_result
    - dn: '${calc_dn}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      _ldapmodify:
        x: 90
        'y': 184
        navigate:
          db09a4ee-bcf4-e58c-9462-3d85b64def7a:
            targetId: 4a9e0bbc-cd95-93b8-20b7-928ddfd2b496
            port: SUCCESS
    results:
      SUCCESS:
        4a9e0bbc-cd95-93b8-20b7-928ddfd2b496:
          x: 360
          'y': 177
