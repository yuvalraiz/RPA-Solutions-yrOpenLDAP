namespace: YuvalRaiz.ldap.actions
operation:
  name: ldap_add
  inputs:
    - ldap_url
    - ldap_username
    - ldap_password:
        sensitive: true
    - dn
    - modlist
  python_action:
    use_jython: false
    script: "import ldap\nimport ldap.modlist\n\n# do not remove the execute function \ndef execute(ldap_url,ldap_username,ldap_password,dn,modlist): \n  return_code = 0\n  return_result = ''\n  error_message = ''\n  try:\n    con=ldap.initialize(ldap_url)\n    con.simple_bind_s(ldap_username, ldap_password)\n    modlist_obj=eval(modlist)\n    add_result=con.add_s(dn, ldap.modlist.addModlist(modlist_obj))\n    return_result=add_result\n  except Exception as e:\n    return_code = -1\n    error_message = e\n  return locals()"
  outputs:
    - add_result
    - error_message
    - return_result
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
