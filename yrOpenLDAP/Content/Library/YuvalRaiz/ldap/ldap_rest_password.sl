namespace: YuvalRaiz.ldap
flow:
  name: ldap_rest_password
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
    - user_dn
    - user_password:
        sensitive: true
    - LDIF:
        default: |-
          ${'''version: 1
          dn: {group_dn}
          changetype: modify
          replace: userPassword
          userPassword: {user_password}
          '''.format(group_dn=group_dn,user_password=user_password)}
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
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      _ldapmodify:
        x: 87
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
