namespace: YuvalRaiz.ldap
flow:
  name: _ldapmodify
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
    - ldap_uri: 'ldap://localhost:389'
    - ldap_admin_password:
        sensitive: true
    - ldap_admin_dn
    - LDIF
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${\"echo '\"+LDIF+\"' | ldapmodify -x -D \"+ldap_admin_dn+\" -w '\"+ldap_admin_password+\"' -H \"+ldap_uri}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - private_key_data: '${private_key_data}'
        publish:
          - return_result
          - standard_out
          - standard_err
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 119
        'y': 163
        navigate:
          a0c2dc23-762f-c109-6f60-06e139697eca:
            targetId: 4a9e0bbc-cd95-93b8-20b7-928ddfd2b496
            port: SUCCESS
    results:
      SUCCESS:
        4a9e0bbc-cd95-93b8-20b7-928ddfd2b496:
          x: 360
          'y': 177
