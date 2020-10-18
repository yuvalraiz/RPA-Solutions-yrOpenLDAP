namespace: YuvalRaiz.ldap.examples
flow:
  name: create_user
  inputs:
    - ldap_url
    - ldap_username
    - ldap_password:
        sensitive: true
    - dn: 'uid=test.user,ou=Users,dc=example,dc=com'
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
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ldap_add:
        x: 55
        'y': 198
        navigate:
          97612964-9c54-18c3-d947-fc5e2acbece9:
            targetId: a1559139-c9e5-f75e-e0f0-206ac64f7bd5
            port: SUCCESS
    results:
      SUCCESS:
        a1559139-c9e5-f75e-e0f0-206ac64f7bd5:
          x: 398
          'y': 198
