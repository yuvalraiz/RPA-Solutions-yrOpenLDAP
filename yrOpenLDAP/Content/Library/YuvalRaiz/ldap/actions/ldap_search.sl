namespace: YuvalRaiz.ldap.actions
operation:
  name: ldap_search
  inputs:
    - ldap_url
    - ldap_username
    - ldap_password:
        sensitive: true
    - ldap_base
    - ldap_query
  python_action:
    use_jython: false
    script: "import ldap\n# do not remove the execute function \ndef execute(ldap_url,ldap_username,ldap_password,ldap_base,ldap_query): \n  return_code = 0\n  return_result = ''\n  error_message = ''\n  try:\n    con=ldap.initialize(ldap_url)\n    con.simple_bind_s(ldap_username, ldap_password)\n    search_result=con.search_s(ldap_base, ldap.SCOPE_SUBTREE, ldap_query)\n    return_result=search_result\n  except Exception as e:\n    return_code = -1\n    error_message = e\n  return locals()"
  outputs:
    - search_result
    - error_message
    - return_result
    - return_code
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
