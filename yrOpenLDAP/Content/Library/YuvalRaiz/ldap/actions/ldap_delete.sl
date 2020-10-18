namespace: YuvalRaiz.ldap.actions
operation:
  name: ldap_delete
  inputs:
    - ldap_url
    - ldap_username
    - ldap_password:
        sensitive: true
    - dn
  python_action:
    use_jython: false
    script: "import ldap\n# do not remove the execute function \ndef execute(ldap_url,ldap_username,ldap_password,dn): \n  return_code = 0\n  return_result = ''\n  error_message = ''\n  try:\n    con=ldap.initialize(ldap_url)\n    con.simple_bind_s(ldap_username, ldap_password)\n    delete_result=con.delete_s(dn)\n    return_result=delete_result\n  except Exception as e:\n    return_code = -1\n    error_message = e\n  return locals()"
  outputs:
    - delete_result
    - error_message
    - return_result
    - return_code
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
