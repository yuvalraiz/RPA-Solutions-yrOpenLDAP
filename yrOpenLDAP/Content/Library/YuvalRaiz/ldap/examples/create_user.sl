namespace: YuvalRaiz.ldap.examples
flow:
  name: create_user
  inputs:
    - ldap_url
    - ldap_username
    - ldap_password:
        sensitive: true
    - dn: 'uid=test.user,ou=users,dc=example,dc=com'
    - cn: Test User
    - displayName: Test User
    - gidNumber: '0'
    - givenName: Test
    - sn: User
    - uidNumber: '9999'
    - userPassword: aaa
    - uid: test.user
    - mail: test.user@example.com
    - postalAddress: test.user@gmail.com
    - group_dn: 'cn=testGroup,ou=users,dc=example,dc=com'
  workflow:
    - ldap_add:
        do:
          YuvalRaiz.ldap.actions.ldap_add:
            - ldap_url: '${ldap_url}'
            - ldap_username: '${ldap_username}'
            - ldap_password:
                value: '${ldap_password}'
                sensitive: true
            - dn: '${dn}'
            - modlist: |-
                ${'''{
                 'objectClass': [b'posixAccount', b'top', b'inetOrgPerson'],
                 'cn': [b'%s'],
                 'displayName': [b'%s'],
                 'gidNumber': [b'%s'],
                 'givenName': [b'%s'],
                 'homeDirectory': [b'/'],
                 'sn': [b'%s'],
                 'uidNumber': [b'%s'],
                 'userPassword': [b'%s'],
                 'uid': [b'%s'],
                 'mail': [b'%s'],
                 'postalAddress': [b'%s']
                }''' % (cn,displayName,gidNumber,givenName,sn,uidNumber,userPassword,uid,mail,postalAddress)}
        publish:
          - user_dn: '${dn}'
        navigate:
          - SUCCESS: add_user_to_group
          - FAILURE: on_failure
    - add_user_to_group:
        do:
          YuvalRaiz.ldap.actions.ldap_modify:
            - ldap_url: '${ldap_url}'
            - ldap_username: '${ldap_username}'
            - ldap_password:
                value: '${ldap_password}'
                sensitive: true
            - dn: '${group_dn}'
            - attr: member
            - new_value: '${user_dn}'
            - activity: add
        navigate:
          - SUCCESS: sleep
          - FAILURE: remove_user_from_group
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '60'
        navigate:
          - SUCCESS: remove_user_from_group
          - FAILURE: on_failure
    - remove_user_from_group:
        do:
          YuvalRaiz.ldap.actions.ldap_modify:
            - ldap_url: '${ldap_url}'
            - ldap_username: '${ldap_username}'
            - ldap_password:
                value: '${ldap_password}'
                sensitive: true
            - dn: '${group_dn}'
            - attr: member
            - new_value: '${user_dn}'
            - activity: delete
        navigate:
          - SUCCESS: sleep_1
          - FAILURE: ldap_delete
    - ldap_delete:
        do:
          YuvalRaiz.ldap.actions.ldap_delete:
            - ldap_url: '${ldap_url}'
            - ldap_username: '${ldap_username}'
            - ldap_password:
                value: '${ldap_password}'
                sensitive: true
            - dn: '${user_dn}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - sleep_1:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '60'
        navigate:
          - SUCCESS: ldap_delete
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ldap_add:
        x: 44
        'y': 78
      add_user_to_group:
        x: 46
        'y': 262
      sleep:
        x: 224
        'y': 264
      remove_user_from_group:
        x: 42
        'y': 426
      ldap_delete:
        x: 33
        'y': 605
        navigate:
          74e590ce-aaee-2b8f-8362-a0637e6222d2:
            targetId: a1559139-c9e5-f75e-e0f0-206ac64f7bd5
            port: SUCCESS
      sleep_1:
        x: 217
        'y': 431
    results:
      SUCCESS:
        a1559139-c9e5-f75e-e0f0-206ac64f7bd5:
          x: 218
          'y': 588
